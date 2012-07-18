// TODO: real tests
class SlowMapper<TInput, TOutput> {
  SlowMapper() :
    _outputChangedHandle = new EventHandle<EventArgs>();

  TInput get input() => _input;

  void set input(TInput value) {
    _input = value;
    if(_future == null) {
      _startFuture();
    } else {
      _pending = true;
    }
  }

  TOutput get output() => _output;

  EventRoot<EventArgs> get outputChanged() =>
      _outputChangedHandle;

  abstract Future<TOutput> getFuture(TInput value);

  void _futureCompleted(TOutput value) {
    assert(_future != null);
    _future = null;
    _output = value;
    _outputChangedHandle.fireEvent(EventArgs.empty);
    if(_pending) {
      _pending = false;
      _startFuture();
    }
  }

  void _startFuture() {
    assert(_future == null);
    assert(!_pending);
    _future = getFuture(_input);
    _future.then(_futureCompleted);
  }

  TInput _input;
  Future<TOutput> _future;
  TOutput _output;
  bool _pending = false;

  final EventHandle<EventArgs> _outputChangedHandle;
}