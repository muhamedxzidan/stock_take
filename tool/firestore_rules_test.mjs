const projectId = 'stock-sira';
const databaseId = '(default)';
const baseUrl =
  `http://127.0.0.1:8080/v1/projects/${projectId}` +
  `/databases/${databaseId}/documents`;
const workerToken = createMockAuthToken({
  projectId,
  uid: 'warehouse-worker',
  email: 'worker@example.com',
});

let passed = 0;

await expectStatus({
  name: 'unauthenticated reads are denied',
  expected: [401, 403],
  request: () => fetch(`${baseUrl}/items/test-item`),
});

await expectStatus({
  name: 'unauthenticated item creation is denied',
  expected: [401, 403],
  request: () =>
    commit([
        createItemWrite({
          itemId: 'ITM-001',
          openingStockPieces: 10,
      }),
    ]),
});

await expectStatus({
  name: 'authenticated user can create a valid item',
  expected: [200],
  request: () =>
    commit(
      [
        createItemWrite({
          itemId: 'ITM-001',
          openingStockPieces: 10,
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'item code counter and generated item can be created atomically',
  expected: [200],
  request: () =>
    commit(
      [
        createCounterWrite({
          counterId: 'itemCode',
          value: 1,
        }),
        createItemWrite({
          itemId: 'S-N-1',
          openingStockPieces: 0,
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'negative opening stock is denied',
  expected: [401, 403],
  request: () =>
    commit(
      [
        createItemWrite({
          itemId: 'ITM-NEGATIVE',
          openingStockPieces: -1,
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'stock cannot change without a linked movement',
  expected: [401, 403],
  request: () =>
    commit(
      [
        updateItemStockWrite({
          itemId: 'ITM-001',
          currentStockPieces: 15,
          totalInboundPieces: 5,
          lastMovementId: 'missing-movement',
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'movement and stock update succeed atomically',
  expected: [200],
  request: () =>
    commit(
      [
        createCounterWrite({
          counterId: 'inboundVoucher',
          value: 1,
        }),
        createMovementWrite({
          movementId: 'movement-1',
          itemId: 'ITM-001',
          delta: 5,
          type: 'inbound',
        }),
        updateItemStockWrite({
          itemId: 'ITM-001',
          currentStockPieces: 15,
          totalInboundPieces: 5,
          lastMovementId: 'movement-1',
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'outbound movement atomically deducts available stock',
  expected: [200],
  request: () =>
    commit(
      [
        createCounterWrite({
          counterId: 'outboundVoucher',
          value: 1,
        }),
        createMovementWrite({
          movementId: 'movement-2',
          itemId: 'ITM-001',
          delta: -4,
          type: 'outbound',
        }),
        updateItemOutboundStockWrite({
          itemId: 'ITM-001',
          currentStockPieces: 11,
          totalOutboundPieces: 4,
          lastMovementId: 'movement-2',
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'outbound movement that would create negative stock is denied',
  expected: [401, 403],
  request: () =>
    commit(
      [
        updateCounterWrite({
          counterId: 'outboundVoucher',
          value: 2,
        }),
        createMovementWrite({
          movementId: 'movement-3',
          itemId: 'ITM-001',
          delta: -20,
          type: 'outbound',
        }),
        updateItemOutboundStockWrite({
          itemId: 'ITM-001',
          currentStockPieces: -9,
          totalOutboundPieces: 24,
          lastMovementId: 'movement-3',
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'rejected outbound movement leaves no partial movement document',
  expected: [404],
  request: () => readDocument('movements', 'movement-3', workerToken),
});

await expectIntegerField({
  name: 'rejected outbound movement preserves the latest item stock',
  collection: 'items',
  documentId: 'ITM-001',
  field: 'currentStockPieces',
  expected: 11,
  token: workerToken,
});

await expectStatus({
  name: 'customer return, stock increase, and return log succeed atomically',
  expected: [200],
  request: () =>
    commit(
      [
        createCounterWrite({
          counterId: 'customerReturn',
          value: 1,
        }),
        createMovementWrite({
          movementId: 'movement-return-1',
          itemId: 'ITM-001',
          delta: 3,
          type: 'customerReturn',
          returnId: 'return-1',
        }),
        updateItemCustomerReturnStockWrite({
          itemId: 'ITM-001',
          currentStockPieces: 14,
          totalCustomerReturnPieces: 3,
          lastMovementId: 'movement-return-1',
        }),
        createCustomerReturnWrite({
          returnId: 'return-1',
          movementId: 'movement-return-1',
          itemId: 'ITM-001',
          quantityPieces: 3,
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'customer return log is readable after atomic save',
  expected: [200],
  request: () => readDocument('returns', 'return-1', workerToken),
});

await expectIntegerField({
  name: 'customer return increases the item stock',
  collection: 'items',
  documentId: 'ITM-001',
  field: 'currentStockPieces',
  expected: 14,
  token: workerToken,
});

await expectStatus({
  name: 'supplier replacement resolves a return without changing stock',
  expected: [200],
  request: () =>
    commit(
      [
        createCounterWrite({
          counterId: 'returnResolution',
          value: 1,
        }),
        createMovementWrite({
          movementId: 'resolution-replaced-1',
          itemId: 'ITM-001',
          delta: 0,
          type: 'supplierReplacement',
          returnId: 'return-1',
        }),
        resolveCustomerReturnWrite({
          returnId: 'return-1',
          movementId: 'resolution-replaced-1',
          status: 'replaced',
        }),
      ],
      workerToken,
    ),
});

await expectIntegerField({
  name: 'supplier replacement preserves item stock',
  collection: 'items',
  documentId: 'ITM-001',
  field: 'currentStockPieces',
  expected: 14,
  token: workerToken,
});

await expectStatus({
  name: 'the same customer return cannot be resolved twice',
  expected: [401, 403],
  request: () =>
    commit(
      [
        updateCounterWrite({
          counterId: 'returnResolution',
          value: 2,
        }),
        createMovementWrite({
          movementId: 'resolution-duplicate',
          itemId: 'ITM-001',
          delta: 0,
          type: 'supplierReplacement',
          returnId: 'return-1',
        }),
        resolveCustomerReturnWrite({
          returnId: 'return-1',
          movementId: 'resolution-duplicate',
          status: 'replaced',
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'rejected duplicate resolution leaves no movement document',
  expected: [404],
  request: () =>
    readDocument('movements', 'resolution-duplicate', workerToken),
});

await expectStatus({
  name: 'a second customer return can be recorded for supplier return',
  expected: [200],
  request: () =>
    commit(
      [
        updateCounterWrite({
          counterId: 'customerReturn',
          value: 2,
        }),
        createMovementWrite({
          movementId: 'movement-return-2',
          itemId: 'ITM-001',
          delta: 2,
          type: 'customerReturn',
          returnId: 'return-2',
        }),
        updateItemCustomerReturnStockWrite({
          itemId: 'ITM-001',
          currentStockPieces: 16,
          totalCustomerReturnPieces: 5,
          lastMovementId: 'movement-return-2',
        }),
        createCustomerReturnWrite({
          returnId: 'return-2',
          returnNumber: 'RET-2026-000002',
          movementId: 'movement-return-2',
          itemId: 'ITM-001',
          quantityPieces: 2,
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'returning to supplier resolves the return and deducts stock',
  expected: [200],
  request: () =>
    commit(
      [
        updateCounterWrite({
          counterId: 'returnResolution',
          value: 2,
        }),
        createMovementWrite({
          movementId: 'resolution-supplier-1',
          itemId: 'ITM-001',
          delta: -2,
          type: 'supplierReturn',
          returnId: 'return-2',
        }),
        updateItemSupplierReturnStockWrite({
          itemId: 'ITM-001',
          currentStockPieces: 14,
          totalSupplierReturnPieces: 2,
          lastMovementId: 'resolution-supplier-1',
        }),
        resolveCustomerReturnWrite({
          returnId: 'return-2',
          movementId: 'resolution-supplier-1',
          status: 'returnedToSupplier',
        }),
      ],
      workerToken,
    ),
});

await expectIntegerField({
  name: 'supplier return deducts exactly the returned quantity',
  collection: 'items',
  documentId: 'ITM-001',
  field: 'currentStockPieces',
  expected: 14,
  token: workerToken,
});

await expectStatus({
  name: 'stocktake session and system snapshot lines start atomically',
  expected: [200],
  request: () =>
    commit(
      [
        createCounterWrite({
          counterId: 'stocktakeNumber',
          value: 1,
        }),
        createStocktakeWrite({
          stocktakeId: 'stocktake-1',
        }),
        writeInventoryControl({
          activeStocktakeId: 'stocktake-1',
          exists: false,
        }),
        createStocktakeLineWrite({
          stocktakeId: 'stocktake-1',
          itemId: 'ITM-001',
          systemQuantityPieces: 14,
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'inventory movements are blocked while stocktake is open',
  expected: [401, 403],
  request: () =>
    commit(
      [
        createMovementWrite({
          movementId: 'blocked-inbound-during-stocktake',
          itemId: 'ITM-001',
          delta: 1,
          type: 'inbound',
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'actual stocktake count can be saved while the session is open',
  expected: [200],
  request: () =>
    commit(
      [
        countStocktakeLineWrite({
          stocktakeId: 'stocktake-1',
          itemId: 'ITM-001',
          actualQuantityPieces: 12,
          systemQuantityPieces: 14,
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'stocktake completion creates its adjustment and updates stock atomically',
  expected: [200],
  request: () =>
    commit(
      [
        createCounterWrite({
          counterId: 'stocktakeAdjustmentVoucher',
          value: 1,
        }),
        createMovementWrite({
          movementId: 'stocktake-adjustment-1',
          itemId: 'ITM-001',
          delta: -2,
          type: 'stocktakeAdjustment',
          stocktakeId: 'stocktake-1',
        }),
        updateItemAdjustmentStockWrite({
          itemId: 'ITM-001',
          currentStockPieces: 12,
          totalAdjustmentPieces: -2,
          lastMovementId: 'stocktake-adjustment-1',
        }),
        completeStocktakeWrite({
          stocktakeId: 'stocktake-1',
          movementId: 'stocktake-adjustment-1',
        }),
        writeInventoryControl({
          activeStocktakeId: '',
          exists: true,
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'an open stocktake can be cancelled and releases the inventory lock',
  expected: [200],
  request: () =>
    commit(
      [
        updateCounterWrite({
          counterId: 'stocktakeNumber',
          value: 2,
        }),
        createStocktakeWrite({
          stocktakeId: 'stocktake-2',
        }),
        writeInventoryControl({
          activeStocktakeId: 'stocktake-2',
          exists: true,
        }),
        createStocktakeLineWrite({
          stocktakeId: 'stocktake-2',
          itemId: 'ITM-001',
          systemQuantityPieces: 12,
        }),
      ],
      workerToken,
    ).then(async (startResponse) => {
      if (startResponse.status !== 200) {
        return startResponse;
      }
      return commit(
        [
          cancelStocktakeWrite({ stocktakeId: 'stocktake-2' }),
          writeInventoryControl({
            activeStocktakeId: '',
            exists: true,
          }),
        ],
        workerToken,
      );
    }),
});

await expectIntegerField({
  name: 'stocktake adjustment applies the exact counted difference',
  collection: 'items',
  documentId: 'ITM-001',
  field: 'currentStockPieces',
  expected: 12,
  token: workerToken,
});

await expectStatus({
  name: 'the same stocktake session cannot be completed twice',
  expected: [401, 403],
  request: () =>
    commit(
      [
        completeStocktakeWrite({
          stocktakeId: 'stocktake-1',
          movementId: 'stocktake-adjustment-1',
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'counts cannot change after stocktake completion',
  expected: [401, 403],
  request: () =>
    commit(
      [
        countStocktakeLineWrite({
          stocktakeId: 'stocktake-1',
          itemId: 'ITM-001',
          actualQuantityPieces: 13,
          systemQuantityPieces: 14,
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'integration flow starts an independent item at 100 pieces',
  expected: [200],
  request: () =>
    commit(
      [
        createItemWrite({
          itemId: 'FLOW-001',
          openingStockPieces: 100,
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'integration flow inbound adds 20 pieces',
  expected: [200],
  request: () =>
    commit(
      [
        createMovementWrite({
          movementId: 'flow-inbound-20',
          itemId: 'FLOW-001',
          delta: 20,
          type: 'inbound',
        }),
        updateItemStockWrite({
          itemId: 'FLOW-001',
          currentStockPieces: 120,
          totalInboundPieces: 20,
          lastMovementId: 'flow-inbound-20',
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'integration flow outbound deducts 15 pieces',
  expected: [200],
  request: () =>
    commit(
      [
        createMovementWrite({
          movementId: 'flow-outbound-15',
          itemId: 'FLOW-001',
          delta: -15,
          type: 'outbound',
        }),
        updateItemOutboundStockWrite({
          itemId: 'FLOW-001',
          currentStockPieces: 105,
          totalOutboundPieces: 15,
          lastMovementId: 'flow-outbound-15',
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'integration flow customer return adds 5 pieces',
  expected: [200],
  request: () =>
    commit(
      [
        createMovementWrite({
          movementId: 'flow-customer-return-5',
          itemId: 'FLOW-001',
          delta: 5,
          type: 'customerReturn',
        }),
        updateItemCustomerReturnStockWrite({
          itemId: 'FLOW-001',
          currentStockPieces: 110,
          totalCustomerReturnPieces: 5,
          lastMovementId: 'flow-customer-return-5',
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'integration flow supplier return deducts 3 pieces',
  expected: [200],
  request: () =>
    commit(
      [
        createMovementWrite({
          movementId: 'flow-supplier-return-3',
          itemId: 'FLOW-001',
          delta: -3,
          type: 'supplierReturn',
        }),
        updateItemSupplierReturnStockWrite({
          itemId: 'FLOW-001',
          currentStockPieces: 107,
          totalSupplierReturnPieces: 3,
          lastMovementId: 'flow-supplier-return-3',
        }),
      ],
      workerToken,
    ),
});

await expectIntegerField({
  name: 'integration flow reaches the expected 107-piece balance',
  collection: 'items',
  documentId: 'FLOW-001',
  field: 'currentStockPieces',
  expected: 107,
  token: workerToken,
});

await expectStatus({
  name: 'integration stocktake snapshots the exact 107-piece balance',
  expected: [200],
  request: () =>
    commit(
      [
        updateCounterWrite({
          counterId: 'stocktakeNumber',
          value: 3,
        }),
        createStocktakeWrite({
          stocktakeId: 'flow-stocktake-1',
        }),
        writeInventoryControl({
          activeStocktakeId: 'flow-stocktake-1',
          exists: true,
        }),
        createStocktakeLineWrite({
          stocktakeId: 'flow-stocktake-1',
          itemId: 'FLOW-001',
          systemQuantityPieces: 107,
        }),
      ],
      workerToken,
    ),
});

await expectIntegerField({
  name: 'integration stocktake line stores system quantity as pieces',
  collection: 'stocktakes/flow-stocktake-1/lines',
  documentId: 'FLOW-001',
  field: 'systemQuantityPieces',
  expected: 107,
  token: workerToken,
});

await expectStatus({
  name: 'new inventory items are blocked while stocktake is open',
  expected: [401, 403],
  request: () =>
    commit(
      [
        createItemWrite({
          itemId: 'BLOCKED-DURING-STOCKTAKE',
          openingStockPieces: 1,
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'a second integration stocktake cannot open concurrently',
  expected: [401, 403],
  request: () =>
    commit(
      [
        createStocktakeWrite({
          stocktakeId: 'flow-stocktake-duplicate',
        }),
        writeInventoryControl({
          activeStocktakeId: 'flow-stocktake-duplicate',
          exists: true,
        }),
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'cancelling integration stocktake releases lock without stock write',
  expected: [200],
  request: () =>
    commit(
      [
        cancelStocktakeWrite({ stocktakeId: 'flow-stocktake-1' }),
        writeInventoryControl({
          activeStocktakeId: '',
          exists: true,
        }),
      ],
      workerToken,
    ),
});

await expectIntegerField({
  name: 'integration cancellation preserves the 107-piece balance',
  collection: 'items',
  documentId: 'FLOW-001',
  field: 'currentStockPieces',
  expected: 107,
  token: workerToken,
});

await expectStatus({
  name: 'new integration stocktake re-snapshots and completes without a delta',
  expected: [200],
  request: () =>
    commit(
      [
        updateCounterWrite({
          counterId: 'stocktakeNumber',
          value: 4,
        }),
        createStocktakeWrite({
          stocktakeId: 'flow-stocktake-2',
        }),
        writeInventoryControl({
          activeStocktakeId: 'flow-stocktake-2',
          exists: true,
        }),
        createStocktakeLineWrite({
          stocktakeId: 'flow-stocktake-2',
          itemId: 'FLOW-001',
          systemQuantityPieces: 107,
        }),
      ],
      workerToken,
    ).then(async (startResponse) => {
      if (startResponse.status !== 200) {
        return startResponse;
      }
      return commit(
        [
          countStocktakeLineWrite({
            stocktakeId: 'flow-stocktake-2',
            itemId: 'FLOW-001',
            actualQuantityPieces: 107,
            systemQuantityPieces: 107,
          }),
        ],
        workerToken,
      );
    }).then(async (countResponse) => {
      if (countResponse.status !== 200) {
        return countResponse;
      }
      return commit(
        [
          completeStocktakeWrite({
            stocktakeId: 'flow-stocktake-2',
            movementId: '',
          }),
          writeInventoryControl({
            activeStocktakeId: '',
            exists: true,
          }),
        ],
        workerToken,
      );
    }),
});

await expectIntegerField({
  name: 'zero-difference integration completion keeps 107 pieces',
  collection: 'items',
  documentId: 'FLOW-001',
  field: 'currentStockPieces',
  expected: 107,
  token: workerToken,
});

await expectStatus({
  name: 'completed movements are immutable',
  expected: [401, 403],
  request: () =>
    commit(
      [
        {
          update: {
            name: documentName('movements', 'movement-1'),
            fields: {
              notes: stringValue('tampered'),
            },
          },
          updateMask: {
            fieldPaths: ['notes'],
          },
        },
      ],
      workerToken,
    ),
});

await expectStatus({
  name: 'items cannot be deleted',
  expected: [401, 403],
  request: () =>
    commit(
      [
        {
          delete: documentName('items', 'ITM-001'),
        },
      ],
      workerToken,
    ),
});

console.log(`Firestore Rules: ${passed} checks passed.`);

function createItemWrite({ itemId, openingStockPieces }) {
  return {
    update: {
      name: documentName('items', itemId),
      fields: {
        code: stringValue(itemId),
        name: stringValue('صنف اختبار'),
        unit: stringValue('piece'),
        itemsPerCarton: integerValue(12),
        openingStockPieces: integerValue(openingStockPieces),
        currentStockPieces: integerValue(openingStockPieces),
        totalInboundPieces: integerValue(0),
        totalOutboundPieces: integerValue(0),
        totalCustomerReturnPieces: integerValue(0),
        totalSupplierReturnPieces: integerValue(0),
        totalAdjustmentPieces: integerValue(0),
        active: booleanValue(true),
        lastMovementId: stringValue(''),
        createdBy: stringValue('warehouse-worker'),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    currentDocument: {
      exists: false,
    },
    updateTransforms: [
      serverTimestampTransform('createdAt'),
      serverTimestampTransform('updatedAt'),
    ],
  };
}

function updateItemStockWrite({
  itemId,
  currentStockPieces,
  totalInboundPieces,
  lastMovementId,
}) {
  return {
    update: {
      name: documentName('items', itemId),
      fields: {
        currentStockPieces: integerValue(currentStockPieces),
        totalInboundPieces: integerValue(totalInboundPieces),
        lastMovementId: stringValue(lastMovementId),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    updateMask: {
      fieldPaths: [
        'currentStockPieces',
        'totalInboundPieces',
        'lastMovementId',
        'updatedBy',
      ],
    },
    currentDocument: {
      exists: true,
    },
    updateTransforms: [serverTimestampTransform('updatedAt')],
  };
}

function updateItemOutboundStockWrite({
  itemId,
  currentStockPieces,
  totalOutboundPieces,
  lastMovementId,
}) {
  return {
    update: {
      name: documentName('items', itemId),
      fields: {
        currentStockPieces: integerValue(currentStockPieces),
        totalOutboundPieces: integerValue(totalOutboundPieces),
        lastMovementId: stringValue(lastMovementId),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    updateMask: {
      fieldPaths: [
        'currentStockPieces',
        'totalOutboundPieces',
        'lastMovementId',
        'updatedBy',
      ],
    },
    currentDocument: {
      exists: true,
    },
    updateTransforms: [serverTimestampTransform('updatedAt')],
  };
}

function updateItemCustomerReturnStockWrite({
  itemId,
  currentStockPieces,
  totalCustomerReturnPieces,
  lastMovementId,
}) {
  return {
    update: {
      name: documentName('items', itemId),
      fields: {
        currentStockPieces: integerValue(currentStockPieces),
        totalCustomerReturnPieces: integerValue(totalCustomerReturnPieces),
        lastMovementId: stringValue(lastMovementId),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    updateMask: {
      fieldPaths: [
        'currentStockPieces',
        'totalCustomerReturnPieces',
        'lastMovementId',
        'updatedBy',
      ],
    },
    currentDocument: {
      exists: true,
    },
    updateTransforms: [serverTimestampTransform('updatedAt')],
  };
}

function updateItemSupplierReturnStockWrite({
  itemId,
  currentStockPieces,
  totalSupplierReturnPieces,
  lastMovementId,
}) {
  return {
    update: {
      name: documentName('items', itemId),
      fields: {
        currentStockPieces: integerValue(currentStockPieces),
        totalSupplierReturnPieces: integerValue(totalSupplierReturnPieces),
        lastMovementId: stringValue(lastMovementId),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    updateMask: {
      fieldPaths: [
        'currentStockPieces',
        'totalSupplierReturnPieces',
        'lastMovementId',
        'updatedBy',
      ],
    },
    currentDocument: {
      exists: true,
    },
    updateTransforms: [serverTimestampTransform('updatedAt')],
  };
}

function updateItemAdjustmentStockWrite({
  itemId,
  currentStockPieces,
  totalAdjustmentPieces,
  lastMovementId,
}) {
  return {
    update: {
      name: documentName('items', itemId),
      fields: {
        currentStockPieces: integerValue(currentStockPieces),
        totalAdjustmentPieces: integerValue(totalAdjustmentPieces),
        lastMovementId: stringValue(lastMovementId),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    updateMask: {
      fieldPaths: [
        'currentStockPieces',
        'totalAdjustmentPieces',
        'lastMovementId',
        'updatedBy',
      ],
    },
    currentDocument: {
      exists: true,
    },
    updateTransforms: [serverTimestampTransform('updatedAt')],
  };
}

function createMovementWrite({
  movementId,
  itemId,
  delta,
  type,
  returnId = '',
  stocktakeId = '',
}) {
  const quantity = Math.abs(delta);
  return {
    update: {
      name: documentName('movements', movementId),
      fields: {
        voucherNumber: stringValue(
          type === 'inbound' ? 'IN-000001' : 'OUT-000001',
        ),
        type: stringValue(type),
        status: stringValue('completed'),
        businessAt: timestampValue(
          new Date(Date.now() - 1000).toISOString(),
        ),
        partyName: stringValue('شركة اختبار'),
        deliveredBy: stringValue('مندوب المورد'),
        receivedBy: stringValue('أمين المخزن'),
        driverName: stringValue(''),
        notes: stringValue(''),
        itemIds: arrayValue([stringValue(itemId)]),
        itemDeltas: mapValue({
          [itemId]: integerValue(delta),
        }),
        lines: arrayValue([
          mapValue({
            itemId: stringValue(itemId),
            itemName: stringValue('صنف اختبار'),
            itemCode: stringValue('ITM-001'),
            cartons: integerValue(0),
            pieces: integerValue(quantity),
            totalPieces: integerValue(quantity),
          }),
        ]),
        returnId: stringValue(returnId),
        stocktakeId: stringValue(stocktakeId),
        createdBy: stringValue('warehouse-worker'),
      },
    },
    currentDocument: {
      exists: false,
    },
    updateTransforms: [serverTimestampTransform('createdAt')],
  };
}

function createStocktakeWrite({ stocktakeId }) {
  return {
    update: {
      name: documentName('stocktakes', stocktakeId),
      fields: {
        stocktakeNumber: stringValue('STK-2026-000001'),
        status: stringValue('open'),
        periodFrom: timestampValue(
          new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
        ),
        periodTo: timestampValue(
          new Date(Date.now() - 1000).toISOString(),
        ),
        completedAt: nullValue(),
        completedBy: stringValue(''),
        completionMovementId: stringValue(''),
        cancelledAt: nullValue(),
        cancelledBy: stringValue(''),
        notes: stringValue('جرد اختبار'),
        createdBy: stringValue('warehouse-worker'),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    currentDocument: {
      exists: false,
    },
    updateTransforms: [
      serverTimestampTransform('startedAt'),
      serverTimestampTransform('createdAt'),
      serverTimestampTransform('updatedAt'),
    ],
  };
}

function cancelStocktakeWrite({ stocktakeId }) {
  return {
    update: {
      name: documentName('stocktakes', stocktakeId),
      fields: {
        status: stringValue('cancelled'),
        cancelledBy: stringValue('warehouse-worker'),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    updateMask: {
      fieldPaths: ['status', 'cancelledBy', 'updatedBy'],
    },
    currentDocument: {
      exists: true,
    },
    updateTransforms: [
      serverTimestampTransform('cancelledAt'),
      serverTimestampTransform('updatedAt'),
    ],
  };
}

function writeInventoryControl({ activeStocktakeId, exists }) {
  return {
    update: {
      name: documentName('inventoryControl', 'primaryWarehouse'),
      fields: {
        activeStocktakeId: stringValue(activeStocktakeId),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    currentDocument: {
      exists,
    },
    updateTransforms: [serverTimestampTransform('updatedAt')],
  };
}

function createStocktakeLineWrite({
  stocktakeId,
  itemId,
  systemQuantityPieces,
}) {
  return {
    update: {
      name: documentName(
        `stocktakes/${stocktakeId}/lines`,
        itemId,
      ),
      fields: {
        itemId: stringValue(itemId),
        itemNameSnapshot: stringValue('صنف اختبار'),
        itemCodeSnapshot: stringValue(itemId),
        unit: stringValue('piece'),
        itemsPerCarton: integerValue(12),
        systemQuantityPieces: integerValue(systemQuantityPieces),
        actualQuantityPieces: integerValue(0),
        differencePieces: integerValue(-systemQuantityPieces),
        counted: booleanValue(false),
        countedAt: nullValue(),
        countedBy: stringValue(''),
      },
    },
    currentDocument: {
      exists: false,
    },
  };
}

function countStocktakeLineWrite({
  stocktakeId,
  itemId,
  actualQuantityPieces,
  systemQuantityPieces,
}) {
  return {
    update: {
      name: documentName(
        `stocktakes/${stocktakeId}/lines`,
        itemId,
      ),
      fields: {
        actualQuantityPieces: integerValue(actualQuantityPieces),
        differencePieces: integerValue(
          actualQuantityPieces - systemQuantityPieces,
        ),
        counted: booleanValue(true),
        countedBy: stringValue('warehouse-worker'),
      },
    },
    updateMask: {
      fieldPaths: [
        'actualQuantityPieces',
        'differencePieces',
        'counted',
        'countedBy',
      ],
    },
    currentDocument: {
      exists: true,
    },
    updateTransforms: [serverTimestampTransform('countedAt')],
  };
}

function completeStocktakeWrite({ stocktakeId, movementId }) {
  return {
    update: {
      name: documentName('stocktakes', stocktakeId),
      fields: {
        status: stringValue('completed'),
        completedBy: stringValue('warehouse-worker'),
        completionMovementId: stringValue(movementId),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    updateMask: {
      fieldPaths: [
        'status',
        'completedBy',
        'completionMovementId',
        'updatedBy',
      ],
    },
    currentDocument: {
      exists: true,
    },
    updateTransforms: [
      serverTimestampTransform('completedAt'),
      serverTimestampTransform('updatedAt'),
    ],
  };
}

function createCustomerReturnWrite({
  returnId,
  returnNumber = 'RET-2026-000001',
  movementId,
  itemId,
  quantityPieces,
}) {
  return {
    update: {
      name: documentName('returns', returnId),
      fields: {
        returnNumber: stringValue(returnNumber),
        itemId: stringValue(itemId),
        itemNameSnapshot: stringValue('صنف اختبار'),
        itemCodeSnapshot: stringValue(itemId),
        itemsPerCartonSnapshot: integerValue(12),
        quantityPieces: integerValue(quantityPieces),
        sourceName: stringValue('فرع اختبار'),
        status: stringValue('pendingSupplierResolution'),
        supplierName: stringValue(''),
        receiptMovementId: stringValue(movementId),
        resolutionMovementId: stringValue(''),
        receivedAt: timestampValue(
          new Date(Date.now() - 1000).toISOString(),
        ),
        resolvedAt: nullValue(),
        resolvedBy: stringValue(''),
        createdBy: stringValue('warehouse-worker'),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    currentDocument: {
      exists: false,
    },
    updateTransforms: [
      serverTimestampTransform('createdAt'),
      serverTimestampTransform('updatedAt'),
    ],
  };
}

function resolveCustomerReturnWrite({
  returnId,
  movementId,
  status,
}) {
  return {
    update: {
      name: documentName('returns', returnId),
      fields: {
        status: stringValue(status),
        supplierName: stringValue('المورد الرئيسي'),
        resolutionMovementId: stringValue(movementId),
        resolvedBy: stringValue('warehouse-worker'),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    updateMask: {
      fieldPaths: [
        'status',
        'supplierName',
        'resolutionMovementId',
        'resolvedBy',
        'updatedBy',
      ],
    },
    currentDocument: {
      exists: true,
    },
    updateTransforms: [
      serverTimestampTransform('resolvedAt'),
      serverTimestampTransform('updatedAt'),
    ],
  };
}

function createCounterWrite({ counterId, value }) {
  return {
    update: {
      name: documentName('counters', counterId),
      fields: {
        value: integerValue(value),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    currentDocument: {
      exists: false,
    },
    updateTransforms: [serverTimestampTransform('updatedAt')],
  };
}

function updateCounterWrite({ counterId, value }) {
  return {
    update: {
      name: documentName('counters', counterId),
      fields: {
        value: integerValue(value),
        updatedBy: stringValue('warehouse-worker'),
      },
    },
    updateMask: {
      fieldPaths: ['value', 'updatedBy'],
    },
    currentDocument: {
      exists: true,
    },
    updateTransforms: [serverTimestampTransform('updatedAt')],
  };
}

async function commit(writes, token) {
  const headers = {
    'Content-Type': 'application/json',
  };
  if (token) {
    headers.Authorization = `Bearer ${token}`;
  }

  return fetch(
    `http://127.0.0.1:8080/v1/projects/${projectId}` +
      `/databases/${databaseId}/documents:commit`,
    {
      method: 'POST',
      headers,
      body: JSON.stringify({ writes }),
    },
  );
}

function readDocument(collection, documentId, token) {
  return fetch(`${baseUrl}/${collection}/${documentId}`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
}

async function expectStatus({ name, expected, request }) {
  const response = await request();
  if (!expected.includes(response.status)) {
    const body = await response.text();
    throw new Error(
      `${name}: expected ${expected.join(' or ')}, ` +
        `received ${response.status}\n${body}`,
    );
  }
  passed++;
  console.log(`✓ ${name}`);
}

async function expectIntegerField({
  name,
  collection,
  documentId,
  field,
  expected,
  token,
}) {
  const response = await readDocument(collection, documentId, token);
  if (response.status !== 200) {
    throw new Error(`${name}: document read returned ${response.status}`);
  }

  const document = await response.json();
  const actual = Number(document.fields?.[field]?.integerValue);
  if (actual !== expected) {
    throw new Error(`${name}: expected ${expected}, received ${actual}`);
  }

  passed++;
  console.log(`✓ ${name}`);
}

function documentName(collection, id) {
  return `projects/${projectId}/databases/${databaseId}` +
    `/documents/${collection}/${id}`;
}

function stringValue(value) {
  return { stringValue: value };
}

function integerValue(value) {
  return { integerValue: String(value) };
}

function booleanValue(value) {
  return { booleanValue: value };
}

function nullValue() {
  return { nullValue: null };
}

function timestampValue(value) {
  return { timestampValue: value };
}

function arrayValue(values) {
  return { arrayValue: { values } };
}

function mapValue(fields) {
  return { mapValue: { fields } };
}

function serverTimestampTransform(fieldPath) {
  return {
    fieldPath,
    setToServerValue: 'REQUEST_TIME',
  };
}

function createMockAuthToken({ projectId, uid, email }) {
  const now = Math.floor(Date.now() / 1000);
  const header = encodeBase64Url({
    alg: 'none',
    type: 'JWT',
  });
  const payload = encodeBase64Url({
    iss: `https://securetoken.google.com/${projectId}`,
    aud: projectId,
    auth_time: now,
    user_id: uid,
    sub: uid,
    iat: now,
    exp: now + 3600,
    email,
    email_verified: true,
    firebase: {
      identities: {
        email: [email],
      },
      sign_in_provider: 'password',
    },
  });
  return `${header}.${payload}.`;
}

function encodeBase64Url(value) {
  return Buffer.from(JSON.stringify(value)).toString('base64url');
}
