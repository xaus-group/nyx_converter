enum NyxStatus {
  success(title: 'Success'),
  running(title: 'Running'),
  completed(title: 'Completed'),
  cancel(title: 'Cancel'),
  failed(title: 'Failed');

  final String title;
  const NyxStatus({required this.title});
}
