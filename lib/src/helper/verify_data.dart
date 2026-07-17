import 'nyx_verify_error.dart';

class VerifyData {
  final NyxVerifyError error;
  final String? message;

  const VerifyData.success()
      : error = NyxVerifyError.none,
        message = null;

  const VerifyData.failed(
    this.error, {
    required this.message,
  });

  bool get isSuccess => error == NyxVerifyError.none;
}
