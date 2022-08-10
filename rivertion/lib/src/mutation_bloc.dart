import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:meta/meta.dart';
import 'package:riverbloc/riverbloc.dart';
import 'package:rivertion/src/utils/extensions.dart';

part 'mutation_bloc.g.dart';

class MutationKey {
  @visibleForTesting
  static MutationKey Function()? debugCreator;

  MutationKey._();

  factory MutationKey() => debugCreator?.call() ?? MutationKey._();

  @override
  String toString() => 'MutationKey#$hashCode';
}

@DataClass(copyable: true)
class MutationData with _$MutationData {
  final Object? param;
  final double progress;

  const MutationData({
    required this.param,
    required this.progress,
  });
}

@DataClass()
abstract class MutationState<TData> with _$MutationState<TData> {
  final Map<MutationKey, MutationData> queue;

  const MutationState._({required this.queue});

  bool get isMutating => queue.isNotEmpty;

  bool get isIdle => this is IdleMutation<TData>;
  bool get isLoading => this is LoadingMutation<TData>;
  bool get isFailed => this is FailedMutation<TData>;
  bool get isSuccess => this is SuccessMutation<TData>;

  double get progress =>
      queue.values.fold<double>(0.0, (total, data) => total + data.progress) / queue.length;

  MutationState<TData> toIdle() => IdleMutation();

  MutationState<TData> toLoading({
    Map<MutationKey, MutationData>? queue,
  }) {
    return map(
      idle: (_) => LoadingMutation(queue: queue ?? this.queue),
      loading: (state) => LoadingMutation(queue: queue ?? this.queue),
      failed: (state) => state.queue.isEmpty
          ? LoadingMutation(queue: queue ?? this.queue)
          : state.copyWith(queue: queue),
      success: (state) => state.queue.isEmpty
          ? LoadingMutation(queue: queue ?? this.queue)
          : state.copyWith(queue: queue),
    );
  }

  MutationState<TData> toFailed({
    Map<MutationKey, MutationData>? queue,
    required Object error,
  }) {
    return FailedMutation(
      queue: queue ?? this.queue,
      error: error,
    );
  }

  MutationState<TData> toSuccess({
    Map<MutationKey, MutationData>? queue,
    required TData data,
  }) {
    return SuccessMutation(
      queue: queue ?? this.queue,
      data: data,
    );
  }

  R map<R>({
    required R Function(IdleMutation<TData> state) idle,
    required R Function(LoadingMutation<TData> state) loading,
    required R Function(FailedMutation<TData> state) failed,
    required R Function(SuccessMutation<TData> state) success,
  });

  R maybeMap<R>({
    R Function(IdleMutation<TData> state)? idle,
    R Function(LoadingMutation<TData> state)? loading,
    R Function(FailedMutation<TData> state)? failed,
    R Function(SuccessMutation<TData> state)? success,
    required R Function(MutationState<TData>) orElse,
  }) {
    return map(
      idle: idle ?? orElse,
      loading: loading ?? orElse,
      failed: failed ?? orElse,
      success: success ?? orElse,
    );
  }

  R? mapOrNull<R>({
    R Function(IdleMutation<TData> state)? idle,
    R Function(LoadingMutation<TData> state)? loading,
    R Function(FailedMutation<TData> state)? failed,
    R Function(SuccessMutation<TData> state)? success,
  }) {
    R? orNull(_) => null;
    return map(
      idle: idle ?? orNull,
      loading: loading ?? orNull,
      failed: failed ?? orNull,
      success: success ?? orNull,
    );
  }

  R when<R>({
    required R Function() idle,
    required R Function() loading,
    required R Function(Object error) failed,
    required R Function(TData data) success,
  }) {
    return map(
      idle: (state) => idle(),
      loading: (state) => loading(),
      failed: (state) => failed(state.error),
      success: (state) => success(state.data),
    );
  }

  R maybeWhen<R>({
    R Function()? idle,
    R Function()? loading,
    R Function(Object error)? failed,
    R Function(TData data)? success,
    required R Function() orElse,
  }) {
    return map(
      idle: (_) => idle == null ? orElse() : idle(),
      loading: (_) => loading == null ? orElse() : loading(),
      failed: (state) => failed == null ? orElse() : failed(state.error),
      success: (state) => success == null ? orElse() : success(state.data),
    );
  }

  R? whenOrNull<R>({
    R Function()? idle,
    R Function()? loading,
    R Function(Object error)? failed,
    R Function(TData data)? success,
  }) {
    return map(
      idle: (_) => idle?.call(),
      loading: (_) => loading?.call(),
      failed: (state) => failed?.call(state.error),
      success: (state) => success?.call(state.data),
    );
  }
}

@DataClass()
class IdleMutation<TData> extends MutationState<TData> with _$IdleMutation<TData> {
  IdleMutation() : super._(queue: const {});

  @override
  R map<R>({
    required R Function(IdleMutation<TData> state) idle,
    required R Function(LoadingMutation<TData> state) loading,
    required R Function(FailedMutation<TData> state) failed,
    required R Function(SuccessMutation<TData> state) success,
  }) {
    return idle(this);
  }
}

@DataClass()
class LoadingMutation<TData> extends MutationState<TData> with _$LoadingMutation<TData> {
  LoadingMutation({
    required Map<MutationKey, MutationData> queue,
  }) : super._(queue: queue);

  @override
  R map<R>({
    required R Function(IdleMutation<TData> state) idle,
    required R Function(LoadingMutation<TData> state) loading,
    required R Function(FailedMutation<TData> state) failed,
    required R Function(SuccessMutation<TData> state) success,
  }) {
    return loading(this);
  }
}

@DataClass()
class FailedMutation<TData> extends MutationState<TData> with _$FailedMutation<TData> {
  final Object error;

  FailedMutation({
    required Map<MutationKey, MutationData> queue,
    required this.error,
  }) : super._(queue: queue);

  @override
  R map<R>({
    required R Function(IdleMutation<TData> state) idle,
    required R Function(LoadingMutation<TData> state) loading,
    required R Function(FailedMutation<TData> state) failed,
    required R Function(SuccessMutation<TData> state) success,
  }) {
    return failed(this);
  }

  FailedMutation<TData> copyWith({
    Map<MutationKey, MutationData>? queue,
    Object? error,
  }) {
    return FailedMutation(
      queue: queue ?? this.queue,
      error: error ?? this.error,
    );
  }
}

@DataClass()
class SuccessMutation<TData> extends MutationState<TData> with _$SuccessMutation<TData> {
  final TData data;

  SuccessMutation({
    required Map<MutationKey, MutationData> queue,
    required this.data,
  }) : super._(queue: queue);

  @override
  R map<R>({
    required R Function(IdleMutation<TData> state) idle,
    required R Function(LoadingMutation<TData> state) loading,
    required R Function(FailedMutation<TData> state) failed,
    required R Function(SuccessMutation<TData> state) success,
  }) {
    return success(this);
  }

  SuccessMutation<TData> copyWith({
    Map<MutationKey, MutationData>? queue,
    bool? isMutating,
    TData? data,
  }) {
    return SuccessMutation(
      queue: queue ?? this.queue,
      data: data ?? this.data,
    );
  }
}

typedef Mutator<TParam, TData> = FutureOr<TData> Function(MutationKey key, TParam param);

typedef FailedListener<TParam> = FutureOr<void> Function(TParam param, Object error);
typedef SuccessListener<TParam, TData> = FutureOr<void> Function(TParam param, TData data);
typedef SettledListener<TParam, TData> = FutureOr<void> Function(
    TParam param, TData? data, Object? error);

abstract class MutationBloc<TParam, TData> extends Cubit<MutationState<TData>> {
  MutationBloc._() : super(IdleMutation<TData>());

  /// Implements [mutator] to define a mutation
  ///
  /// Use [onFailed] to capture the error, [onSuccess] to capture the result, [onSettled] to capture the error or result.
  /// These callbacks are invoked even if the bloc has been closed.
  factory MutationBloc(
    Mutator<TParam, TData> mutator, {
    FailedListener<TParam>? onFailed,
    SuccessListener<TParam, TData>? onSuccess,
    SettledListener<TParam, TData>? onSettled,
  }) = _InlineMutationBloc<TParam, TData>;

  /// Start the safe mutation given a [param]
  ///
  /// Does not launch any exception if the mutation fails
  Future<void> maybeMutate(TParam param);

  /// Start the mutation given a [param]
  ///
  /// Launches an exception if the mutation fails otherwise the result returns
  Future<TData> mutate(TParam param);

  void reset();

  void emitProgress(MutationKey key, double value);
}

abstract class MutationBlocBase<TParam, TData> extends MutationBloc<TParam, TData> {
  MutationBlocBase() : super._();

  /// Implements it to define a mutation
  @protected
  FutureOr<TData> onMutating(MutationKey key, TParam param);

  /// It is recalled when the mutation fails
  ///
  /// It is recalled even if the bloc is closed
  @protected
  FutureOr<void> onFailed(TParam param, Object error) {}

  /// It is recalled when the mutation successfully completes
  ///
  /// It is recalled even if the bloc is closed
  @protected
  FutureOr<void> onSuccess(TParam param, TData data) {}

  /// It is recalled when the mutation fails or successfully completes
  ///
  /// It is recalled even if the bloc is closed
  @protected
  FutureOr<void> onSettled(TParam param, TData? data, Object? error) {}

  @override
  Future<void> maybeMutate(TParam param) async {
    try {
      await mutate(param);
    } catch (_) {}
  }

  @override
  Future<TData> mutate(TParam param) async {
    final key = MutationKey();

    emit(state.toLoading(
      queue: {...state.queue, key: MutationData(param: param, progress: 0.0)},
    ));

    bool canEmit() => !isClosed && state.queue.containsKey(key);

    try {
      final data = await onMutating(key, param);

      await _notifySuccess(param, data);
      await _notifySettled(param, data, null);

      if (canEmit()) {
        emit(state.toSuccess(
          queue: state.queue.without(key),
          data: data,
        ));
      }

      return data;
    } catch (error, stackTrace) {
      onError(error, stackTrace);

      await _notifyFailed(param, error);
      await _notifySettled(param, null, error);

      if (canEmit()) {
        emit(state.toFailed(
          queue: state.queue.without(key),
          error: error,
        ));
      }

      rethrow;
    }
  }

  @override
  void reset() {
    emit(state.toIdle());
  }

  Future<void> _notifyFailed(TParam param, Object error) async {
    try {
      return await onFailed(param, error);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
    }
  }

  FutureOr<void> _notifySuccess(TParam param, TData data) async {
    try {
      return await onSuccess(param, data);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
    }
  }

  FutureOr<void> _notifySettled(TParam param, TData? data, Object? error) async {
    try {
      return await onSettled(param, data, error);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
    }
  }

  @override
  void emitProgress(MutationKey key, double value) {
    if (isClosed) return;
    final data = state.queue[key];
    if (data == null) return;
    emit(state.toLoading(
      queue: {...state.queue, key: data.copyWith(progress: value)},
    ));
  }
}

class _InlineMutationBloc<TParam, TData> extends MutationBlocBase<TParam, TData> {
  final Mutator<TParam, TData> mutator;
  final FailedListener<TParam>? _onFailed;
  final SuccessListener<TParam, TData>? _onSuccess;
  final SettledListener<TParam, TData>? _onSettled;

  _InlineMutationBloc(
    this.mutator, {
    FailedListener<TParam>? onFailed,
    SuccessListener<TParam, TData>? onSuccess,
    SettledListener<TParam, TData>? onSettled,
  })  : _onFailed = onFailed,
        _onSuccess = onSuccess,
        _onSettled = onSettled,
        super();

  @override
  FutureOr<TData> onMutating(MutationKey key, TParam arg) => mutator(key, arg);

  @override
  FutureOr<void> onFailed(TParam param, Object error) => _onFailed?.call(param, error);

  @override
  FutureOr<void> onSuccess(TParam param, TData data) => _onSuccess?.call(param, data);

  @override
  FutureOr<void> onSettled(TParam param, TData? data, Object? error) =>
      _onSettled?.call(param, data, error);
}
