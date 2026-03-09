sealed class Result<T> {
  const Result();
  factory Result.success(T data) => Success(data);
  factory Result.failure(String error) => Failure(error);
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final String error;
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Failure() => null,
      };

  String? get errorOrNull => switch (this) {
        Success() => null,
        Failure(:final error) => error,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(String error) failure,
  }) =>
      switch (this) {
        Success(:final data) => success(data),
        Failure(:final error) => failure(error),
      };
}
