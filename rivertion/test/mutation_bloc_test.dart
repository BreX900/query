import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:riverbloc/riverbloc.dart';
import 'package:rivertion/src/mutation_bloc.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class _MockMutator extends Mock {
  Future<String> call(MutationKey key, bool param);
}

class _MockFailed extends Mock {
  FutureOr<void> call(bool param, Object error);
}

class _MockSuccess extends Mock {
  FutureOr<void> call(bool param, String data);
}

class _MockSettled extends Mock {
  FutureOr<void> call(bool param, String? data, Object? error);
}

class _FakeMutationKey extends Fake implements MutationKey {}

void main() {
  late Mutator<bool, String> mockMutator;
  late FailedListener<bool> mockFailedListener;
  late SuccessListener<bool, String> mockSuccessListener;
  late SettledListener<bool, String> mockSettledListener;

  late MutationBloc<bool, String> bloc;
  late MutationState<String> state;
  final keys = [_FakeMutationKey(), _FakeMutationKey()];

  setUp(() {
    mockMutator = _MockMutator();
    mockFailedListener = _MockFailed();
    mockSuccessListener = _MockSuccess();
    mockSettledListener = _MockSettled();

    bloc = MutationBloc(
      mockMutator,
      onFailed: mockFailedListener,
      onSuccess: mockSuccessListener,
      onSettled: mockSettledListener,
    );
    state = bloc.state;

    var index = 0;
    MutationKey.debugCreator = () => keys[index++];

    registerFallbackValue(_FakeMutationKey());
  });

  group('MutationBloc', () {
    final tData = true;
    final tError = 'ERROR';
    final tStackTrace = StackTrace.empty;
    final tResult = 'RESULT';

    group('constructor', () {
      test('initial state', () {
        final expectedState = IdleMutation<String>();
        expect(state, expectedState);
      });
    });

    group('mutate', () {
      test('emits and return result', () async {
        when(() => mockMutator(any(), any())).thenAnswer((_) async => tResult);

        final expectedStates = [
          state = state.toLoading(queue: {keys[0]: MutationData(param: tData, progress: 0.0)}),
          state = state.toSuccess(queue: {}, data: tResult),
        ];
        await Future.wait([
          expectLater(bloc.stream, emitsInOrder(expectedStates)),
          expectLater(bloc.mutate(tData), completion(tResult)),
        ]);
        verifyNever(() => mockFailedListener(any(), any()));
        verify(() => mockSuccessListener(any(), any()));
        verify(() => mockSettledListener(any(), any(), any()));
      });

      test('emits and throw error', () async {
        when(() => mockMutator(any(), any())).thenAnswer((_) async {
          return Future.error(tError, tStackTrace);
        });

        final expectedStates = [
          state = state.toLoading(queue: {keys[0]: MutationData(param: tData, progress: 0.0)}),
          state = state.toFailed(queue: {}, error: tError),
        ];
        await Future.wait([
          expectLater(bloc.stream, emitsInOrder(expectedStates)),
          expectLater(bloc.mutate(tData), throwsA(isA<String>())),
        ]);
        verify(() => mockFailedListener(any(), any()));
        verifyNever(() => mockSuccessListener(any(), any()));
        verify(() => mockSettledListener(any(), any(), any()));
      });

      test('the execution of two success mutations at the same time', () async {
        when(() => mockMutator(any(), any())).thenAnswer((_) async => tResult);

        final expectedStates = [
          state = state.toLoading(queue: {keys[0]: MutationData(param: tData, progress: 0.0)}),
          state = state.toLoading(
            queue: {...state.queue, keys[1]: MutationData(param: tData, progress: 0.0)},
          ),
          state = state.toSuccess(
            queue: {keys[1]: MutationData(param: tData, progress: 0.0)},
            data: tResult,
          ),
          state = state.toSuccess(queue: {}, data: tResult),
        ];
        await Future.wait([
          expectLater(bloc.stream, emitsInOrder(expectedStates)),
          expectLater(bloc.mutate(tData), completion(tResult)),
          expectLater(bloc.mutate(tData), completion(tResult)),
        ]);
        verifyNever(() => mockFailedListener(any(), any()));
        verify(() => mockSuccessListener(any(), any())).called(2);
        verify(() => mockSettledListener(any(), any(), any())).called(2);
      });

      test('the execution of two failed mutations at the same time', () async {
        when(() => mockMutator(any(), any())).thenAnswer((_) async {
          return Future.error(tError, tStackTrace);
        });

        final expectedStates = [
          state = state.toLoading(queue: {keys[0]: MutationData(param: tData, progress: 0.0)}),
          state = state.toLoading(
            queue: {...state.queue, keys[1]: MutationData(param: tData, progress: 0.0)},
          ),
          state = state.toFailed(
            queue: {keys[1]: MutationData(param: tData, progress: 0.0)},
            error: tError,
          ),
          state = state.toFailed(queue: {}, error: tError),
        ];
        await Future.wait([
          expectLater(bloc.stream, emitsInOrder(expectedStates)),
          expectLater(bloc.mutate(tData), throwsA(isA<String>())),
          expectLater(bloc.mutate(tData), throwsA(isA<String>())),
        ]);
        verify(() => mockFailedListener(any(), any())).called(2);
        verifyNever(() => mockSuccessListener(any(), any()));
        verify(() => mockSettledListener(any(), any(), any())).called(2);
      });
    });

    group('reset', () {
      test('reset', () async {
        when(() => mockMutator(any(), any())).thenAnswer((_) async => tResult);

        final expectedStates = [
          state = state.toLoading(queue: {keys[0]: MutationData(param: tData, progress: 0.0)}),
          state = state.toIdle(),
        ];
        await Future.wait([
          expectLater(bloc.stream, emitsInOrder(expectedStates)),
          expectLater(bloc.mutate(tData), completion(tResult)),
          expectLater(Future.sync(bloc.reset), completion(null)),
        ]);
        verifyNever(() => mockFailedListener(any(), any()));
        verify(() => mockSuccessListener(any(), any()));
        verify(() => mockSettledListener(any(), any(), any()));

        await expectBlocClose(bloc);
      });
    });
  });
}

Future<void> expectBlocClose(BlocBase<dynamic> bloc) {
  return Future.wait([
    expectLater(bloc.stream, emitsInOrder([emitsDone])),
    bloc.close(),
  ]);
}
