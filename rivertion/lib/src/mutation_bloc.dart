import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:meta/meta.dart';
import 'package:riverbloc/riverbloc.dart';

part 'mutation_bloc.g.dart';

@DataClass()
abstract class MutationState<TData> with _$MutationState<TData> {
  const MutationState._();

  bool get isMutating;

  bool get isIdle => this is IdleMutation<TData>;
  bool get isLoading => this is LoadingMutation<TData>;
  bool get isFailed => this is FailedMutation<TData>;
  bool get isSuccess => this is SuccessMutation<TData>;

  MutationState<TData> toIdle() => IdleMutation();

  MutationState<TData> toLoading() => LoadingMutation();

  MutationState<TData> toFailed({
    bool isMutating = false,
    required Object error,
  }) {
    return FailedMutation(isMutating: isMutating, error: error);
  }

  MutationState<TData> toSuccess({
    bool isMutating = false,
    required TData data,
  }) {
    return SuccessMutation(isMutating: isMutating, data: data);
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
}

@DataClass()
class IdleMutation<TData> extends MutationState<TData> with _$IdleMutation<TData> {
  IdleMutation() : super._();

  @override
  bool get isMutating => false;

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
  LoadingMutation() : super._();

  @override
  bool get isMutating => true;

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
  @override
  final bool isMutating;

  final Object error;

  FailedMutation({
    required this.isMutating,
    required this.error,
  }) : super._();

  @override
  R map<R>({
    required R Function(IdleMutation<TData> state) idle,
    required R Function(LoadingMutation<TData> state) loading,
    required R Function(FailedMutation<TData> state) failed,
    required R Function(SuccessMutation<TData> state) success,
  }) {
    return failed(this);
  }
}

@DataClass()
class SuccessMutation<TData> extends MutationState<TData> with _$SuccessMutation<TData> {
  @override
  final bool isMutating;

  final TData data;

  SuccessMutation({
    required this.isMutating,
    required this.data,
  }) : super._();

  @override
  R map<R>({
    required R Function(IdleMutation<TData> state) idle,
    required R Function(LoadingMutation<TData> state) loading,
    required R Function(FailedMutation<TData> state) failed,
    required R Function(SuccessMutation<TData> state) success,
  }) {
    return success(this);
  }
}

typedef Mutator<TParam, TData> = FutureOr<TData> Function(TParam param);

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
}

abstract class MutationBlocBase<TParam, TData> extends MutationBloc<TParam, TData> {
  var _queueLength = 0;
  var _resetKey = const Object();

  MutationBlocBase() : super._();

  /// Implements it to define a mutation
  @protected
  FutureOr<TData> onMutating(TParam param);

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
    final resetKey = _resetKey;

    if (_queueLength == 0) {
      emit(state.toLoading());
    }

    _queueLength += 1;

    try {
      final data = await onMutating(param);

      await _notifySuccess(param, data);
      await _notifySettled(param, data, null);
      if (_resetKey == resetKey) {
        emit(state.toSuccess(
          isMutating: _queueLength > 1,
          data: data,
        ));
      }

      return data;
    } catch (error, stackTrace) {
      onError(error, stackTrace);

      await _notifyFailed(param, error);
      await _notifySettled(param, null, error);
      if (_resetKey == resetKey) {
        emit(state.toFailed(
          isMutating: _queueLength > 1,
          error: error,
        ));
      }

      rethrow;
    } finally {
      _queueLength -= 1;
    }
  }

  @override
  void reset() {
    _resetKey = Object();
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
  FutureOr<TData> onMutating(TParam arg) => mutator(arg);

  @override
  FutureOr<void> onFailed(TParam param, Object error) => _onFailed?.call(param, error);

  @override
  FutureOr<void> onSuccess(TParam param, TData data) => _onSuccess?.call(param, data);

  @override
  FutureOr<void> onSettled(TParam param, TData? data, Object? error) =>
      _onSettled?.call(param, data, error);
}
