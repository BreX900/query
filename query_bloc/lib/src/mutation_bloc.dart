import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:meta/meta.dart';

part 'mutation_bloc.g.dart';

@DataClass()
abstract class MutationState<TData> with _$MutationState<TData> {
  const MutationState._();

  bool get isIdle => this is IdleMutation<TData>;
  bool get isLoading => this is LoadingMutation<TData>;
  bool get isFailed => this is FailedMutation<TData>;
  bool get isSuccess => this is SuccessMutation<TData>;

  MutationState<TData> toIdle() => const IdleMutation();

  MutationState<TData> toLoading() => const LoadingMutation();

  MutationState<TData> toError(Object error) => FailedMutation(error: error);

  MutationState<TData> toSuccess(TData data) => SuccessMutation(data: data);

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
  const IdleMutation() : super._();

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
  const LoadingMutation() : super._();

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

  const FailedMutation({required this.error}) : super._();

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
  final TData data;

  const SuccessMutation({required this.data}) : super._();

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

typedef FailedListener<TParam> = Function(TParam param, Object error);
typedef SuccessListener<TParam, TData> = Function(TParam param, TData data);
typedef SettledListener<TParam, TData> = Function(TParam param, TData? data, Object? error);

abstract class MutationBloc<TParam, TData> extends Cubit<MutationState<TData>> {
  MutationBloc._() : super(IdleMutation<TData>());

  factory MutationBloc(
    Mutator<TParam, TData> mutator, {
    FailedListener<TParam>? onFailed,
    SuccessListener<TParam, TData>? onSuccess,
    SettledListener<TParam, TData>? onSettled,
  }) = _InlineMutationBloc<TParam, TData>;

  Future<void> maybeMutate(TParam param);

  Future<TData> mutate(TParam param);

  void reset();
}

abstract class MutationBlocBase<TParam, TData> extends MutationBloc<TParam, TData> {
  MutationBlocBase() : super._();

  @protected
  FutureOr<TData> onMutating(TParam param);

  @protected
  FutureOr<void> onFailed(TParam param, Object error) {}

  @protected
  FutureOr<void> onSuccess(TParam param, TData data) {}

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
    if (state.isLoading) throw ImmutableStateError();

    emit(state.toLoading());

    try {
      final data = await onMutating(param);

      await onSuccess(param, data);
      await onSettled(param, data, null);
      emit(state.toSuccess(data));

      return data;
    } catch (error, stackTrace) {
      onError(error, stackTrace);

      await onFailed(param, error);
      await onSettled(param, null, error);
      emit(state.toError(error));

      rethrow;
    }
  }

  @override
  void reset() {
    if (state.isLoading) throw ImmutableStateError();

    emit(state.toIdle());
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

class ImmutableStateError extends Error {
  @override
  String toString() => 'You cannot start a new mutation if one is already in progress';
}
