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

mixin _$PagesState<TCursor, TData> {
  PagesState<TCursor, TData> get _self => this as PagesState<TCursor, TData>;

  Iterable<Object?> get _props sync* {
    yield _self.cursor;
    yield _self.totalPages;
    yield _self.pages;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$PagesState<TCursor, TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('PagesState', [TCursor, TData])
        ..add('cursor', _self.cursor)
        ..add('totalPages', _self.totalPages)
        ..add('pages', _shortMap(_self.pages)))
      .toString();

  PagesState<TCursor, TData> change(
          void Function(_PagesStateChanges<TCursor, TData> c) updates) =>
      (_PagesStateChanges<TCursor, TData>._(_self)..update(updates)).build();

  _PagesStateChanges<TCursor, TData> toChanges() => _PagesStateChanges._(_self);
}

class _PagesStateChanges<TCursor, TData> {
  late TCursor cursor;
  late int? totalPages;
  late Map<TCursor, TData> pages;

  _PagesStateChanges._(PagesState<TCursor, TData> dataClass) {
    replace(dataClass);
  }

  void update(void Function(_PagesStateChanges<TCursor, TData> c) updates) =>
      updates(this);

  void replace(covariant PagesState<TCursor, TData> dataClass) {
    cursor = dataClass.cursor;
    totalPages = dataClass.totalPages;
    pages = dataClass.pages;
  }

  PagesState<TCursor, TData> build() => PagesState(
        cursor: cursor,
        totalPages: totalPages,
        pages: pages,
      );
}
