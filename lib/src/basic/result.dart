abstract class Result<T> {
  final T value;
  const Result(this.value);
}

class Ok<T> extends Result<T> {
  const Ok(T value) : super(value);
}

class Err<Exception> extends Result<Exception> {
  const Err(Exception e) : super(e);
}
