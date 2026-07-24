/// Represents the current state of a media conversion.
///
/// Conversion lifecycle:
///
/// - [running] conversion is currently processing.
/// - [completed] conversion finished successfully.
/// - [failed] conversion failed.
/// - [cancel] conversion was cancelled.
///
enum NyxStatus {
  /// Operation completed successfully.
  success(title: 'Success'),

  /// Conversion is currently running.
  running(title: 'Running'),

  /// Conversion finished successfully.
  completed(title: 'Completed'),

  /// Conversion was cancelled.
  cancel(title: 'Cancel'),

  /// Conversion failed.
  failed(title: 'Failed');

  /// Display title for this status.
  final String title;
  const NyxStatus({required this.title});
}
