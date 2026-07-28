enum ReturnResolutionKind { replaced, returnedToSupplier }

class ReturnResolutionDraft {
  final String returnId;
  final String supplierName;
  final ReturnResolutionKind kind;

  const ReturnResolutionDraft({
    required this.returnId,
    required this.supplierName,
    required this.kind,
  });
}

class SavedReturnResolution {
  final String returnId;
  final String returnNumber;
  final String movementId;
  final ReturnResolutionKind kind;

  const SavedReturnResolution({
    required this.returnId,
    required this.returnNumber,
    required this.movementId,
    required this.kind,
  });
}
