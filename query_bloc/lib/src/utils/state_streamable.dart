import 'package:bloc/bloc.dart';
import 'package:query_bloc/src/utils/select_state_streamable.dart';
import 'package:rxdart/rxdart.dart';

class RxState {
  static StateStreamable<T> from<T>(T state, Stream<T> stream) {
    return _FromStateStreamable(state, stream);
  }

  static StateStreamable<List<T>> merge<T>(Iterable<StateStreamable<T>> streamables) {
    return _CombineStateStreamable(streamables);
  }

  static StateStreamable<R> combine2<S1, S2, R>(
    StateStreamable<S1> streamable1,
    StateStreamable<S2> streamable2,
    R Function(S1 state1, S2 state2) mapper,
  ) {
    return _CombineStateStreamable<dynamic>([streamable1, streamable2]).select((states) {
      return mapper(states[0] as S1, states[1] as S2);
    });
  }
}

class _FromStateStreamable<T> implements StateStreamable<T> {
  @override
  final T state;
  @override
  final Stream<T> stream;

  const _FromStateStreamable(this.state, this.stream);
}

class _CombineStateStreamable<T> implements StateStreamable<List<T>> {
  final Iterable<StateStreamable<T>> streamables;

  _CombineStateStreamable(this.streamables);

  @override
  List<T> get state => streamables.map((e) => e.state).toList();

  @override
  Stream<List<T>> get stream =>
      Rx.combineLatestList(streamables.map((e) => e.stream.startWith(e.state))).skip(1);
}
