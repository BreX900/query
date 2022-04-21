import 'dart:async';

class NeverFuture<T> implements Future<T> {
  const NeverFuture();

  @override
  Stream<T> asStream() => const Stream.empty();

  @override
  Future<T> catchError(Function onError, {bool Function(Object error)? test}) => this;

  @override
  Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError}) => NeverFuture();

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) => this;

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) => this;
}
