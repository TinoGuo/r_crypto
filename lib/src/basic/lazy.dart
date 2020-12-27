/// Lazy init heavy function or instance.
_Lazy<T> lazyOf<T>(Function _func) => new _Lazy(_func);

class _Lazy<T> {
  final Function _func;
  bool _isEvaluated = false;

  _Lazy(this._func);

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
