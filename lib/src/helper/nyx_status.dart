enum NyxStatus { success, cancel, error }

extension NyxStatusCommandExtension on NyxStatus {
  String get title {
    switch (this) {
      case NyxStatus.success:
        return 'Success';
      case NyxStatus.cancel:
        return 'Cancel';
      case NyxStatus.error:
        return 'Error';
    }
  }
}
