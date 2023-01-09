// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debounce_bloc.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides, unused_element

mixin _$DebounceState<T> {
  DebounceState<T> get _self => this as DebounceState<T>;

  Iterable<Object?> get _props sync* {
    yield _self.value;
    yield _self.debouncedValue;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebounceState<T> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('DebounceState', [T])
        ..add('value', _self.value)
        ..add('debouncedValue', _self.debouncedValue))
      .toString();
}

mixin _$IdleDebounce<T> {
  IdleDebounce<T> get _self => this as IdleDebounce<T>;

  Iterable<Object?> get _props sync* {
    yield _self.value;
    yield _self.debouncedValue;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdleDebounce<T> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('IdleDebounce', [T])
        ..add('value', _self.value)
        ..add('debouncedValue', _self.debouncedValue))
      .toString();
}

mixin _$WaitingDebounce<T> {
  WaitingDebounce<T> get _self => this as WaitingDebounce<T>;

  Iterable<Object?> get _props sync* {
    yield _self.value;
    yield _self.debouncedValue;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaitingDebounce<T> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('WaitingDebounce', [T])
        ..add('value', _self.value)
        ..add('debouncedValue', _self.debouncedValue))
      .toString();
}

mixin _$CompletedDebounce<T> {
  CompletedDebounce<T> get _self => this as CompletedDebounce<T>;

  Iterable<Object?> get _props sync* {
    yield _self.value;
    yield _self.debouncedValue;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletedDebounce<T> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('CompletedDebounce', [T])
        ..add('value', _self.value)
        ..add('debouncedValue', _self.debouncedValue))
      .toString();
}
