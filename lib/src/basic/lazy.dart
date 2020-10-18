Lazy<T> lazyOf<T>(Function _func) => new Lazy(_func);

class Lazy<T> {
  final Function _func;
  bool _isEvaluated = false;

  Lazy(this._func);

  T _value;

  T call() {
    if (!_isEvaluated) {
      if (_func != null) {
        _value = _func();
      }
      _isEvaluated = true;
    }
    return _value;
  }
}
