class SavedPrinter {
  final String address;
  final String name;

  const SavedPrinter({required this.address, required this.name});

  String get displayName => name.trim().isEmpty ? 'طابعة بدون اسم' : name;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SavedPrinter && other.address == address;
  }

  @override
  int get hashCode => address.hashCode;
}
