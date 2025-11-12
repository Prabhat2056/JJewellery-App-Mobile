class ServiceResult<T> {
  final bool isSuccess;
  final T? result;
  final String? errorMessage;

  ServiceResult({
    required this.isSuccess,
    this.result,
    this.errorMessage,
  });

  static ServiceResult asSuccess({result}) => ServiceResult(
        isSuccess: true,
        result: result,
      );
  static ServiceResult asFailure({String? errorMessage}) => ServiceResult(
        isSuccess: false,
        errorMessage: errorMessage,
      );
}
