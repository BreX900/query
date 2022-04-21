import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

extension ListenStateStreamable<T> on StateStreamable<T> {
  StreamSubscription<T> listen(
    FutureOr<void> Function(T current) listener, {
    bool Function(T prev, T curr)? listenWhen,
    bool fireImmediately = false,
  }) {
    if (fireImmediately) {
      void fire() async {
        try {
          await listener(state);
        } catch (error, stackTrace) {
          Zone.current.handleUncaughtError(error, stackTrace);
        }
      }

      fire();
    }
    var stream = this.stream;

    if (listenWhen != null) {
      if (fireImmediately) {
        stream = stream.startWith(state);
      }

      stream = stream.distinct((prev, curr) => !listenWhen(prev, curr));

      if (fireImmediately) {
        stream = stream.skip(1);
      }
    }
    return stream.listen(listener);
  }
}
