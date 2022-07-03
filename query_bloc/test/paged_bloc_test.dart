import 'package:mocktail/mocktail.dart';
import 'package:query_bloc/src/query_bloc.dart';
import 'package:test/scaffolding.dart';

class _MockFetcher extends Mock {
  Future<String> call();
}

class FakeError {}

void main() {
  late QueryFetcher<String> mockFetcher;

  setUp(() {
    mockFetcher = _MockFetcher();
  });

  group('QueryBloc', () {
    final tError = FakeError();
    final tStackTrace = StackTrace.empty;
    final tResult = 'RESULT';

    group('init', () {
      // test('Success initializing', () async {
      //   when(() => mockFetcher()).thenAnswer((_) async => tResult);
      //
      //   final bloc = QueryBloc.inline(mockFetcher);
      //   var state = bloc.state;
      //
      //   final expectedState = LoadingQuery<String>(
      //     hasData: false,
      //     data: null,
      //   );
      //   expect(bloc.state, expectedState);
      //
      //   final expectedStates = [
      //     state = state.toFetched(tResult),
      //   ];
      //   await expectLater(bloc.stream, emitsInOrder(expectedStates));
      // });

      // test('Failed initializing', () async {
      //   when(() => mockFetcher()).thenAnswer((_) async {
      //     throw Error.throwWithStackTrace(tError, tStackTrace);
      //   });
      //
      //   final bloc = QueryBloc.inline(mockFetcher);
      //   var state = bloc.state;
      //
      //   final expectedState = LoadingQuery<String>(
      //     hasData: false,
      //     data: null,
      //   );
      //   expect(bloc.state, expectedState);
      //
      //   final expectedStates = [
      //     state = state.toFetchFailed(tError, tStackTrace),
      //   ];
      //   await expectLater(bloc.stream, emitsInOrder(expectedStates));
      // });
    });

    group('fetch', () {
      late QueryBloc<String> bloc;
      late QueryState<String> state;

      final tInitialResult = 'INITIAL_RESULT';

      // setUp(() async {
      //   when(() => mockFetcher()).thenAnswer((_) async => tInitialResult);
      //   bloc = PagedQueryBloc.inline(mockFetcher);
      //   await bloc.stream.firstWhere((state) => state.hasData);
      //   state = bloc.state;
      // });
      //
      // test('Success fetch', () async {
      //   when(() => mockFetcher()).thenAnswer((_) async => tResult);
      //
      //   final expectedStates = [
      //     state = state.toFetching(),
      //     state = state.toFetched(tResult),
      //   ];
      //   await Future.wait([
      //     expectLater(bloc.stream, emitsInOrder(expectedStates)),
      //     expectLater(bloc.fetch(), completion(tResult)),
      //   ]);
      // });

      // test('Failed fetch', () async {
      //   when(() => mockFetcher()).thenAnswer((_) async {
      //     Error.throwWithStackTrace(tError, tStackTrace);
      //   });
      //
      //   final expectedStates = [
      //     state = state.toFetching(),
      //     state = state.toFetchFailed(tError, tStackTrace),
      //   ];
      //   await Future.wait([
      //     expectLater(bloc.stream, emitsInOrder(expectedStates)),
      //     expectLater(() => bloc.fetch(), throwsA(tError)),
      //   ]);
      // });

      // TODO
      // test('Not fetch already fetched args', () async {
      //   final expectedStates = [
      //     emitsDone,
      //   ];
      //   await Future.wait<void>([
      //     expectLater(bloc.stream, emitsInOrder(expectedStates)),
      //     expectLater(bloc.fetch(0), completion(tInitialResult)),
      //     Future.delayed(const Duration(milliseconds: 1)).whenComplete(bloc.close),
      //   ]);
      // });

      // TODO
      // test('Fetch already fetched args if force is true', () async {
      //   when(() => mockFetcher()).thenAnswer((_) async => tResult);
      //
      //   final expectedStates = [
      //     state = state.toFetching(),
      //     state = state.toFetched(tResult),
      //   ];
      //   await Future.wait([
      //     expectLater(bloc.stream, emitsInOrder(expectedStates)),
      //     expectLater(bloc.fetch(0, force: true), completion(tResult)),
      //   ]);
      // });

      // test('Cancel first success fetch and returns new fetch success result', () async {
      //   var count = -1;
      //   when(() => mockFetcher()).thenAnswer((_) async {
      //     await Future.delayed(const Duration());
      //     count++;
      //     return count < 1 ? 'WRONG_RESULT' : tResult;
      //   });
      //
      //   final expectedStates = [
      //     state = state.toFetching(),
      //     state = state.toFetched(tResult),
      //   ];
      //   await Future.wait([
      //     expectLater(bloc.stream, emitsInOrder(expectedStates)),
      //     expectLater(bloc.fetch(), completion(tResult)),
      //     expectLater(bloc.fetch(), completion(tResult)),
      //   ]);
      // });

      // test('Cancel first error fetch and returns new fetch success result', () async {
      //   var count = -1;
      //   when(() => mockFetcher()).thenAnswer((_) async {
      //     count++;
      //     return count == 0 ? throw tError : tResult;
      //   });
      //
      //   final expectedStates = [
      //     state = state.toFetching(),
      //     state = state.toFetched(tResult),
      //   ];
      //   await Future.wait([
      //     expectLater(bloc.stream, emitsInOrder(expectedStates)),
      //     expectLater(bloc.fetch(), completion(tResult)),
      //     expectLater(bloc.fetch(), completion(tResult)),
      //   ]);
      // });

      // test('Cancel first fetch and returns new fetch error result', () async {
      //   var count = -1;
      //   when(() => mockFetcher()).thenAnswer((_) async {
      //     count++;
      //     return count == 0 ? Future.error('', tStackTrace) : Future.error(tError, tStackTrace);
      //   });
      //
      //   final expectedStates = [
      //     state = state.toFetching(),
      //     state = state.toFetchFailed(tError, tStackTrace),
      //   ];
      //   await Future.wait([
      //     expectLater(bloc.stream, emitsInOrder(expectedStates)),
      //     expectLater(() => bloc.fetch(), throwsA(tError)),
      //     expectLater(() => bloc.fetch(), throwsA(tError)),
      //   ]);
      // });
    });
  });
}
