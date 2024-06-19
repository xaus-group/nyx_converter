enum NyxStatus { success, running, completed, cancel, failed }

extension NyxStatusCommandExtension on NyxStatus {
  String get title {
    switch (this) {
      case NyxStatus.success:
        return 'Success';
      case NyxStatus.running:
        return 'Running';
      case NyxStatus.completed:
        return 'Completed';
      case NyxStatus.cancel:
        return 'Cancel';
      case NyxStatus.failed:
        return 'Failed';
    }
  }
}
