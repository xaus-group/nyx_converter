enum NyxVerifyError {
  none,

  inputFileNotFound,
  inputIsNotFile,
  inputFileEmpty,
  inputFileUnreadable,
  inputMediaInvalid,

  outputDirectoryNotFound,
  outputFileAlreadyExists,
  outputFileNameInvalid,
}

extension NyxVerifyErrorMessage on NyxVerifyError {
  String get message {
    switch (this) {
      case NyxVerifyError.none:
        return '';

      case NyxVerifyError.inputFileNotFound:
        return 'Input file does not exist.';

      case NyxVerifyError.inputIsNotFile:
        return 'Input path is not a file.';

      case NyxVerifyError.inputFileEmpty:
        return 'Input file is empty.';

      case NyxVerifyError.inputFileUnreadable:
        return 'Unable to read the input file.';

      case NyxVerifyError.inputMediaInvalid:
        return 'Unsupported or corrupted media file.';

      case NyxVerifyError.outputDirectoryNotFound:
        return 'Output directory does not exist.';

      case NyxVerifyError.outputFileAlreadyExists:
        return 'Output file already exists.';

      case NyxVerifyError.outputFileNameInvalid:
        return 'Output file name is invalid.';
    }
  }
}
