import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:meta/meta.dart';

part 'query_bloc.g.dart';

@DataClass()
abstract class QueryState<TData> with _$QueryState<TData> {
  bool get hasError => false;
  Object? get error => null;
  Object get requiredError => hasError ? error as Object : throw 'Missing error';
  StackTrace? get stackTrace => null;

  bool get hasData => false;
  bool get hasMoreData => true;
  TData? get data => null;
  TData get requiredData => hasData ? data as TData : throw 'Missing data';

  const QueryState();

  bool get isIdle => this is IdleQuery<TData>;
  bool get isLoading => this is LoadingQuery<TData>;
  bool get isFailed => this is FailedQuery<TData>;
  bool get isSuccess => this is SuccessQuery<TData>;

  bool get isInitialing => !(hasData || hasError);

  R mapStatus<R>({
    required R Function() loading,
    required R Function(Object error) error,
    required R Function(TData data) data,
  }) {
    if (hasData) {
      return data(requiredData);
    } else if (hasError) {
      return error(requiredError);
    } else {
      return loading();
    }
  }

  R maybeMapStatus<R>({
    R Function()? loading,
    R Function(Object error)? error,
    R Function(TData data)? data,
    required R Function() orElse,
  }) {
    return mapStatus(loading: () {
      return loading != null ? loading() : orElse();
    }, error: (e) {
      return error != null ? error(e) : orElse();
    }, data: (d) {
      return data != null ? data(d) : orElse();
    });
  }

  R map<R>({
    required R Function(IdleQuery<TData> state) idle,
    required R Function(LoadingQuery<TData> state) loading,
    required R Function(FailedQuery<TData> state) failed,
    required R Function(SuccessQuery<TData> state) success,
  });

  R maybeMap<R>({
    R Function(IdleQuery<TData> state)? idle,
    R Function(LoadingQuery<TData> state)? loading,
    R Function(FailedQuery<TData> state)? failed,
    R Function(SuccessQuery<TData> state)? success,
    required R Function(QueryState<TData> state) orElse,
  }) {
    return map(
      idle: idle ?? orElse,
      loading: loading ?? orElse,
      failed: failed ?? orElse,
      success: success ?? orElse,
    );
  }

  QueryState<TData> toFetching() {
    return LoadingQuery(
      hasData: hasData,
      data: data,
    );
  }

  QueryState<TData> toFetchingWithData(TData data) {
    return LoadingQuery(
      hasData: true,
      data: data,
    );
  }

  QueryState<TData> toFetchFailed(Object error, StackTrace stackTrace) {
    return FailedQuery(
      error: error,
      stackTrace: stackTrace,
      hasData: hasData,
      data: data,
    );
  }

  QueryState<TData> toFetched(TData data) {
    return SuccessQuery(
      data: data,
    );
  }
}

@DataClass()
class IdleQuery<TData> extends QueryState<TData> with _$IdleQuery<TData> {
  @override
  final bool hasData;
  @override
  final TData? data;

  const IdleQuery({
    required this.hasData,
    required this.data,
  });

  @override
  R map<R>({
    required R Function(IdleQuery<TData> state) idle,
    required R Function(LoadingQuery<TData> state) loading,
    required R Function(FailedQuery<TData> state) failed,
    required R Function(SuccessQuery<TData> state) success,
  }) {
    return idle(this);
  }
}

@DataClass()
class LoadingQuery<TData> extends QueryState<TData> with _$LoadingQuery<TData> {
  @override
  final bool hasData;
  @override
  final TData? data;

  const LoadingQuery({
    required this.hasData,
    required this.data,
  });

  @override
  R map<R>({
    required R Function(IdleQuery<TData> state) idle,
    required R Function(LoadingQuery<TData> state) loading,
    required R Function(FailedQuery<TData> state) failed,
    required R Function(SuccessQuery<TData> state) success,
  }) {
    return loading(this);
  }
}

@DataClass()
class FailedQuery<TData> extends QueryState<TData> with _$FailedQuery<TData> {
  @override
  bool get hasError => true;
  @override
  final Object error;
  @override
  final StackTrace stackTrace;

  @override
  final bool hasData;
  @override
  final TData? data;

  const FailedQuery({
    required this.error,
    required this.stackTrace,
    required this.hasData,
    required this.data,
  });

  @override
  R map<R>({
    required R Function(IdleQuery<TData> state) idle,
    required R Function(LoadingQuery<TData> state) loading,
    required R Function(FailedQuery<TData> state) failed,
    required R Function(SuccessQuery<TData> state) success,
  }) {
    return failed(this);
  }
}

@DataClass()
class SuccessQuery<TData> extends QueryState<TData> with _$SuccessQuery<TData> {
  @override
  bool get hasData => true;
  @override
  final TData data;

  const SuccessQuery({
    required this.data,
  });

  @override
  R map<R>({
    required R Function(IdleQuery<TData> state) idle,
    required R Function(LoadingQuery<TData> state) loading,
    required R Function(FailedQuery<TData> state) failed,
    required R Function(SuccessQuery<TData> state) success,
  }) {
    return success(this);
  }
}

class _CancelledFutureException implements Exception {}

typedef QueryFetcher<TData> = Future<TData> Function();

typedef QueryInitializer<TData> = TData Function();

abstract class QueryBlocBase<TData> extends Cubit<QueryState<TData>> {
  var _key = const Object();
  Completer<TData>? _result;

  QueryBlocBase({
    bool shouldFetch = true,
    QueryInitializer<TData>? dataInitializer,
  }) : super(shouldFetch
            ? LoadingQuery<TData>(
                hasData: dataInitializer != null,
                data: dataInitializer?.call(),
              )
            : IdleQuery(
                hasData: dataInitializer != null,
                data: dataInitializer?.call(),
              )) {
    if (shouldFetch) maybeFetch();
  }

  Future<TData> fetch() async {
    emit(state.toFetching());
    _key = Object();

    try {
      return await _fetching(key: _key);
    } on _CancelledFutureException {
      return await _result!.future;
    }
  }

  Future<void> maybeFetch() async {
    try {
      await fetch();
    } catch (_) {}
  }

  Future<TData> _fetching({required Object key}) async {
    _result ??= Completer()..future.ignore(); // Ignore the error because it is thrown in the zone
    late TData result;
    try {
      result = await onFetching();
    } catch (error, stackTrace) {
      onError(error, stackTrace);
      if (_key != key) throw _CancelledFutureException();

      emit(state.toFetchFailed(error, stackTrace));
      _result!.completeError(error, stackTrace);

      _result = null;
      rethrow;
    }

    if (_key != key) throw _CancelledFutureException();

    emit(state.toFetched(result));
    _result!.complete(result);

    _result = null;
    return result;
  }

  @protected
  Future<TData> onFetching();
}

class QueryBloc<TData> extends QueryBlocBase<TData> {
  final QueryFetcher<TData> fetcher;

  QueryBloc(
    this.fetcher, {
    QueryInitializer<TData>? dataInitializer,
  }) : super(
          dataInitializer: dataInitializer,
        );

  @override
  Future<TData> onFetching() => fetcher();
}

// abstract class PagedQueryBloc<TArg, TData> extends QueryBloc<QueryPages<TArg, TData>> {
//   TArg _arg;
//
//   PagedQueryBloc({
//     required TArg initialArg,
//   })  : _initialArg = initialArg,
//         _arg = initialArg,
//         super(
//           dataInitializer: () => QueryPages(totalPages: null, pages: {}),
//         );
//
//   Future<TData?> fetchPage(TArg arg) async {
//     emit(state.toFetching());
//     _key = Object();
//
//     return _fetchPage(arg, merge: true);
//   }
//
//   @override
//   Future<QueryPages<TArg, TData>> onFetching() async {
//     _arg = _initialArg;
//     emit(state.toFetching());
//     await _fetchPage(_initialArg, merge: false);
//     return state.requiredData;
//   }
//
//   Future<TData?> onFetchingPage(TArg arg);
//
//   Future<TData?> _fetchPage(TArg arg, {required bool merge}) async {
//     try {
//       final page = await onFetchingPage(arg);
//       emit(state.toFetched(state.requiredData.copyWith(
//         totalPages: page == null ? state.requiredData.pages.length : null,
//         pages: {
//           if (merge) ...state.requiredData.pages,
//           if (page != null) arg: page,
//         },
//       )));
//       return page;
//     } catch (error, stackTrace) {
//       addError(error, stackTrace);
//       emit(state.toFetchFailed(error, stackTrace));
//       rethrow;
//     }
//   }
// }

String _shortMap(dynamic value) => '${(value as Map).length}';

@DataClass(changeable: true)
class PagesState<TCursor, TData> with _$PagesState<TCursor, TData> {
  final TCursor cursor;
  final int? totalPages;
  @DataField(stringifier: _shortMap)
  final Map<TCursor, TData> pages;

  bool get hasNextPage => totalPages == null;

  const PagesState({
    required this.cursor,
    required this.totalPages,
    required this.pages,
  });
}

abstract class Cursor<TCursor, TData> {
  TCursor get initial;
  TCursor next(PagesState<TCursor, TData> state);
  TCursor previous(PagesState<TCursor, TData> state);
}

class IndexedCursor extends Cursor<int, Never> {
  @override
  int get initial => 1;

  @override
  int next(PagesState<int, dynamic> state) => state.cursor + 1;

  @override
  int previous(PagesState<int, dynamic> state) => state.cursor - 1;
}

typedef IndexedQueryBloc<TData> = PagedQueryBloc<int, TData>;

typedef PageFetcher<TCursor, TData> = Future<TData?> Function(TCursor cursor);

class PagedQueryBloc<TCursor, TData> extends Cubit<QueryState<PagesState<TCursor, TData>>> {
  var _key = Object();
  final Cursor<TCursor, TData> _cursor;
  final PageFetcher<TCursor, TData> _pageFetcher;

  PagedQueryBloc(
    this._pageFetcher, {
    required Cursor<TCursor, TData> cursor,
  })  : _cursor = cursor,
        super(LoadingQuery(
          hasData: true,
          data: PagesState(
            totalPages: null,
            pages: {},
            cursor: cursor.initial,
          ),
        )) {
    _fetchPage(state.requiredData.cursor, key: _key, merge: true);
  }

  Future<TData?> fetch() {
    emit(state.toFetchingWithData(state.requiredData.change((c) => c..cursor = _cursor.initial)));
    _key = Object();

    return _fetchPage(_cursor.initial, key: _key, merge: false);
  }

  Future<TData?> fetchPage(TCursor cursor) async {
    emit(state.toFetchingWithData(state.requiredData.change((c) => c..cursor = cursor)));
    _key = Object();

    return _fetchPage(cursor, key: _key, merge: true);
  }

  Future<TData?> fetchNextPage() => fetchPage(_cursor.next(state.requiredData));

  Future<TData?> fetchPreviousPage() => fetchPage(_cursor.previous(state.requiredData));

  Future<TData?> onFetchingPage(TCursor cursor) => _pageFetcher(cursor);

  Future<TData?> _fetchPage(TCursor cursor, {required Object key, required bool merge}) async {
    try {
      final page = await onFetchingPage(cursor);

      emit(state.toFetched(state.requiredData.change((b) => b
        ..totalPages = page == null
            ? state.requiredData.pages.length
            : merge
                ? b.totalPages
                : null
        ..pages = {
          if (merge) ...state.requiredData.pages,
          if (page != null) cursor: page,
        })));

      return page;
    } catch (error, stackTrace) {
      onError(error, stackTrace);
      emit(state.toFetchFailed(error, stackTrace));
      rethrow;
    }
  }
}

// class MyQueryBloc extends PagedQueryBloc<int, List<String>> {
//   MyQueryBloc() : super(cursorMover: IndexedCursor());
//
//   @override
//   Future<List<String>?> onFetchingPage(int index) {
//     return null;
//   }
// }
