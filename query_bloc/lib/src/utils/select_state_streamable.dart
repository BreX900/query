import 'package:bloc/bloc.dart';

extension SelectStateStreamable<T> on StateStreamable<T> {
  StateStreamable<R> select<R>(R Function(T state) selector) =>
      _SelectStateStreamable(this, selector);
}

class _SelectStateStreamable<I, O> implements StateStreamable<O> {
  final StateStreamable<I> streamable;
  final O Function(I state) selector;

  _SelectStateStreamable(this.streamable, this.selector);

  @override
  O get state => selector(streamable.state);

  @override
  Stream<O> get stream => streamable.stream.map(selector);
}
