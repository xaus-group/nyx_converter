import 'package:nyx_converter/src/helper/nyx_status.dart';

class NyxData {
  final String path;
  final NyxStatus status;
  final String? message;
  const NyxData(this.path, this.status, {this.message});
}
