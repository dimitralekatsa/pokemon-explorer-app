sealed class Result<T> {
  const Result();
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

class Error<T> extends Result<T> {
  final Exception error;
  const Error(this.error);
}
