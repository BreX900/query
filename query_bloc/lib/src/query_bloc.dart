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

abstract class QueryBloc<TData> extends Cubit<QueryState<TData>> {
  var _key = const Object();
  Completer<TData>? _result;

  QueryBloc({
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

  factory QueryBloc.inline(
    QueryFetcher<TData> fetcher, {
    QueryInitializer<TData>? dataInitializer,
  }) = _InlineDemandBloc<TData>;

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

class _InlineDemandBloc<TData> extends QueryBloc<TData> {
  final QueryFetcher<TData> fetcher;

  _InlineDemandBloc(
    this.fetcher, {
    QueryInitializer<TData>? dataInitializer,
  }) : super(
          dataInitializer: dataInitializer,
        );

  @override
  Future<TData> onFetching() => fetcher();
}

// class QueryPages<TArg, TData> {
//   final int? totalPages;
//   final Map<TArg, TData> pages;
//
//   const QueryPages({
//     required this.totalPages,
//     required this.pages,
//   });
//
//   QueryPages<TArg, TData> copyWith({
//     int? totalPages,
//     Map<TArg, TData>? pages,
//   }) {
//     return QueryPages(
//       totalPages: totalPages ?? this.totalPages,
//       pages: pages ?? this.pages,
//     );
//   }
// }
//
// abstract class PagedDemandBloc<TArg, TData> extends QueryBloc<QueryPages<TArg, TData>> {
//   TArg _arg;
//
//   PagedDemandBloc({
//     required TArg initialArg,
//   })  : _arg = initialArg,
//         super(
//           dataInitializer: () => QueryPages(totalPages: null, pages: {}),
//         );
//
//   @override
//   Future<QueryPages<TArg, TData>> fetch() {
//     // Delete all keys
//     return super.fetch();
//   }
//
//   Future<TData> fetchPage(TArg arg) async {
//     if (state.requiredData.pages.containsKey(arg)) {
//       return state.requiredData.pages[arg] as TData;
//     }
//     if (_arg == arg) {
//       final result = state.map<Future<TData>?>(idle: (state) {
//         return null;
//       }, loading: (state) {
//         return _result!.future.then((value) => value.pages[arg] as TData);
//       }, failed: (state) {
//         return Future.error(state.error, state.stackTrace);
//       }, success: (state) {
//         return Future.value(state.data.pages[arg] as TData);
//       });
//       if (result != null) return result;
//     }
//
//     emit(state.toFetching());
//     _key = Object();
//
//     return _fetchPage(arg);
//   }
//
//   @override
//   Future<QueryPages<TArg, TData>> onFetching(TArg arg) async {
//     fetchPage(arg);
//   }
//
//   Future<TData> onFetchingPage(TArg arg);
//
//   Future<TData> _fetchPage(TArg arg) async {
//     try {
//       final page = await onFetchingPage(arg);
//       emit(state.toFetched(state.requiredData.copyWith(
//         pages: {
//           ...state.requiredData.pages,
//           arg: page,
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
