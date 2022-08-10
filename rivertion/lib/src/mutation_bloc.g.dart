// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutation_bloc.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$MutationData {
  MutationData get _self => this as MutationData;

  Iterable<Object?> get _props sync* {
    yield _self.param;
    yield _self.progress;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$MutationData &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('MutationData')
        ..add('param', _self.param)
        ..add('progress', _self.progress))
      .toString();

  MutationData copyWith({
    Object? param,
    double? progress,
  }) {
    return MutationData(
      param: param ?? _self.param,
      progress: progress ?? _self.progress,
    );
  }
}

mixin _$MutationState<TData> {
  MutationState<TData> get _self => this as MutationState<TData>;

  Iterable<Object?> get _props sync* {
    yield _self.queue;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$MutationState<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() =>
      (ClassToString('MutationState', [TData])..add('queue', _self.queue))
          .toString();
}

mixin _$IdleMutation<TData> {
  IdleMutation<TData> get _self => this as IdleMutation<TData>;

  Iterable<Object?> get _props sync* {
    yield _self.queue;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$IdleMutation<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() =>
      (ClassToString('IdleMutation', [TData])..add('queue', _self.queue))
          .toString();
}

mixin _$LoadingMutation<TData> {
  LoadingMutation<TData> get _self => this as LoadingMutation<TData>;

  Iterable<Object?> get _props sync* {
    yield _self.queue;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$LoadingMutation<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() =>
      (ClassToString('LoadingMutation', [TData])..add('queue', _self.queue))
          .toString();
}

mixin _$FailedMutation<TData> {
  FailedMutation<TData> get _self => this as FailedMutation<TData>;

  Iterable<Object?> get _props sync* {
    yield _self.queue;
    yield _self.error;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$FailedMutation<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('FailedMutation', [TData])
        ..add('queue', _self.queue)
        ..add('error', _self.error))
      .toString();
}

mixin _$SuccessMutation<TData> {
  SuccessMutation<TData> get _self => this as SuccessMutation<TData>;

  Iterable<Object?> get _props sync* {
    yield _self.queue;
    yield _self.data;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$SuccessMutation<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('SuccessMutation', [TData])
        ..add('queue', _self.queue)
        ..add('data', _self.data))
      .toString();
}
