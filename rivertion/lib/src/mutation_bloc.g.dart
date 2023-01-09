// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutation_bloc.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides, unused_element

mixin _$MutationState<TData> {
  MutationState<TData> get _self => this as MutationState<TData>;

  Iterable<Object?> get _props sync* {}

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MutationState<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('MutationState', [TData])).toString();
}

mixin _$IdleMutation<TData> {
  IdleMutation<TData> get _self => this as IdleMutation<TData>;

  Iterable<Object?> get _props sync* {}

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdleMutation<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('IdleMutation', [TData])).toString();
}

mixin _$LoadingMutation<TData> {
  LoadingMutation<TData> get _self => this as LoadingMutation<TData>;

  Iterable<Object?> get _props sync* {}

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingMutation<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('LoadingMutation', [TData])).toString();
}

mixin _$FailedMutation<TData> {
  FailedMutation<TData> get _self => this as FailedMutation<TData>;

  Iterable<Object?> get _props sync* {
    yield _self.isMutating;
    yield _self.error;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailedMutation<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('FailedMutation', [TData])
        ..add('isMutating', _self.isMutating)
        ..add('error', _self.error))
      .toString();
}

mixin _$SuccessMutation<TData> {
  SuccessMutation<TData> get _self => this as SuccessMutation<TData>;

  Iterable<Object?> get _props sync* {
    yield _self.isMutating;
    yield _self.data;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuccessMutation<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('SuccessMutation', [TData])
        ..add('isMutating', _self.isMutating)
        ..add('data', _self.data))
      .toString();
}
