import 'dart:async';

import 'package:mek_data_class/mek_data_class.dart';
import 'package:meta/meta.dart';
import 'package:riverbloc/riverbloc.dart';
import 'package:rivertion/src/utils/typedefs.dart';
import 'package:rxdart/rxdart.dart';

part 'debounce_bloc.g.dart';

@DataClass()
abstract class DebounceState<T> with _$DebounceState<T> {
  final T value;
  final T debouncedValue;

  const DebounceState({
    required this.value,
    required this.debouncedValue,
  });

  @visibleForTesting
  DebounceState<T> toIdle(T value) {
    return WaitingDebounce(value: value, debouncedValue: value);
  }

  @visibleForTesting
  DebounceState<T> toWaiting(T value) {
    return WaitingDebounce(value: value, debouncedValue: debouncedValue);
  }

  @visibleForTesting
  DebounceState<T> toCompleted(T debouncedValue) {
    return WaitingDebounce(value: debouncedValue, debouncedValue: debouncedValue);
  }
}

@DataClass()
class IdleDebounce<T> extends DebounceState<T> with _$IdleDebounce<T> {
  IdleDebounce({
    required T value,
    required T debouncedValue,
  }) : super(
          value: value,
          debouncedValue: debouncedValue,
        );
}

@DataClass()
class WaitingDebounce<T> extends DebounceState<T> with _$WaitingDebounce<T> {
  WaitingDebounce({
    required T value,
    required T debouncedValue,
  }) : super(
          value: value,
          debouncedValue: debouncedValue,
        );
}

@DataClass()
class CompletedDebounce<T> extends DebounceState<T> with _$CompletedDebounce<T> {
  CompletedDebounce({
    required T value,
    required T debouncedValue,
  }) : super(
          value: value,
          debouncedValue: debouncedValue,
        );
}

class DebounceBloc<T> extends Cubit<DebounceState<T>> {
  final ValueChanged<T>? _onChanged;
  late final StreamSubscription<DebounceState<T>> _debounceSub;

  DebounceBloc({
    Duration duration = const Duration(milliseconds: 500),
    required T initialValue,
    ValueChanged<T>? onChanged,
    ValueChanged<T>? onDebounced,
  })  : _onChanged = onChanged,
        super(IdleDebounce(
          value: initialValue,
          debouncedValue: initialValue,
        )) {
    _debounceSub = stream.debounce((state) async* {
      if (state is! WaitingDebounce<T>) return;
      yield await Future.delayed(duration);
    }).listen((state) {
      if (state is! WaitingDebounce<T>) return;
      onDebounced?.call(state.value);
      emit(state.toCompleted(state.value));
    });
  }

  void restore(T value) {
    emit(state.toIdle(value));
  }

  void debounce(T value) {
    if (state.debouncedValue == value) {
      emit(state.toIdle(value));
      return;
    }

    _onChanged?.call(value);
    emit(state.toWaiting(value));
  }

  @override
  Future<void> close() async {
    await _debounceSub.cancel();
    return super.close();
  }
}
