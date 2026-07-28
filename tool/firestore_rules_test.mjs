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

function createMovementWrite({ movementId, itemId, delta, type }) {
  return {
    update: {
      name: documentName('movements', movementId),
      fields: {
        voucherNumber: stringValue('IN-000001'),
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
            pieces: integerValue(delta),
            totalPieces: integerValue(delta),
          }),
        ]),
        returnId: stringValue(''),
        stocktakeId: stringValue(''),
        createdBy: stringValue('warehouse-worker'),
      },
    },
    currentDocument: {
      exists: false,
    },
    updateTransforms: [serverTimestampTransform('createdAt')],
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
