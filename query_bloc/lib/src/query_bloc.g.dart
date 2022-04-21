// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_bloc.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$QueryState<TData> {
  QueryState<TData> get _self => this as QueryState<TData>;

  Iterable<Object?> get _props sync* {}

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$QueryState<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('QueryState', [TData])).toString();
}

mixin _$IdleQuery<TData> {
  IdleQuery<TData> get _self => this as IdleQuery<TData>;

  Iterable<Object?> get _props sync* {
    yield _self.hasData;
    yield _self.data;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$IdleQuery<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('IdleQuery', [TData])
        ..add('hasData', _self.hasData)
        ..add('data', _self.data))
      .toString();
}

mixin _$LoadingQuery<TData> {
  LoadingQuery<TData> get _self => this as LoadingQuery<TData>;

  Iterable<Object?> get _props sync* {
    yield _self.hasData;
    yield _self.data;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$LoadingQuery<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('LoadingQuery', [TData])
        ..add('hasData', _self.hasData)
        ..add('data', _self.data))
      .toString();
}

mixin _$FailedQuery<TData> {
  FailedQuery<TData> get _self => this as FailedQuery<TData>;

  Iterable<Object?> get _props sync* {
    yield _self.error;
    yield _self.stackTrace;
    yield _self.hasData;
    yield _self.data;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$FailedQuery<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('FailedQuery', [TData])
        ..add('error', _self.error)
        ..add('stackTrace', _self.stackTrace)
        ..add('hasData', _self.hasData)
        ..add('data', _self.data))
      .toString();
}

mixin _$SuccessQuery<TData> {
  SuccessQuery<TData> get _self => this as SuccessQuery<TData>;

  Iterable<Object?> get _props sync* {
    yield _self.data;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$SuccessQuery<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() =>
      (ClassToString('SuccessQuery', [TData])..add('data', _self.data))
          .toString();
}
