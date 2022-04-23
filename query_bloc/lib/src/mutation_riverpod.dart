import 'dart:async';

import 'package:query_bloc/query_bloc.dart';
import 'package:riverbloc/riverbloc.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';

typedef _Mutator<TRef, TParam, TData> = FutureOr<TData> Function(TRef ref, TParam param);
typedef _FamilyMutator<TRef, TArg, TParam, TData> = FutureOr<TData> Function(
    TRef ref, TArg arg, TParam param);

typedef _FailedListener<TParam> = Function(TParam param, Object error);
typedef _SuccessListener<TParam, TData> = Function(TParam param, TData data);
typedef _SettledListener<TParam, TData> = Function(TParam param, TData? data, Object? error);

// ignore: subtype_of_sealed_class
/// {@macro bloc_provider}
class MutationProvider<TParam, TData>
    extends BlocProvider<MutationBloc<TParam, TData>, MutationState<TData>> {
  MutationProvider(
    _Mutator<BlocProviderRef<MutationBloc<TParam, TData>>, TParam, TData> mutator, {
    String? name,
    List<ProviderOrFamily>? dependencies,
    Family? from,
    Object? argument,
    FailedListener<TParam>? onFailed,
    SuccessListener<TParam, TData>? onSuccess,
    SettledListener<TParam, TData>? onSettled,
  }) : super(
          (ref) => MutationBloc((arg) => mutator(ref, arg), on),
          name: name,
          dependencies: dependencies,
          from: from,
          argument: argument,
        );

  /// {@macro bloc_provider_auto_dispose}
  static const autoDispose = AutoDisposeMutationProviderBuilder();

  /// {@macro riverpod.family}
  static const family = MutationProviderFamilyBuilder();
}

/// Builds a [AutoDisposeBlocProvider].
class AutoDisposeMutationProviderBuilder {
  /// Builds a [AutoDisposeBlocProviderBuilder].
  const AutoDisposeMutationProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeBlocProvider<MutationBloc<TParam, TData>, MutationState<TData>> call<TParam, TData>(
    _Mutator<AutoDisposeBlocProviderRef<MutationBloc<TParam, TData>>, TParam, TData> mutator, {
    String? name,
    List<ProviderOrFamily>? dependencies,
    Family<dynamic, dynamic, ProviderBase>? from,
    Object? argument,
  }) {
    return AutoDisposeBlocProvider(
      (ref) => MutationBloc((arg) => mutator(ref, arg)),
      name: name,
      dependencies: dependencies,
      from: from,
      argument: argument,
    );
  }
}

/// Builds a [BlocProviderFamily].
class MutationProviderFamilyBuilder {
  /// Builds a [BlocProviderFamily].
  const MutationProviderFamilyBuilder();

  /// {@macro riverpod.family}
  BlocProviderFamily<MutationBloc<TParam, TData>, MutationState<TData>, TArg>
      call<TArg, TParam, TData>(
    _FamilyMutator<BlocProviderRef<MutationBloc<TParam, TData>>, TArg, TParam, TData> mutator, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) {
    return BlocProviderFamily(
      (ref, arg) => MutationBloc((data) => mutator(ref, arg, data)),
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeMutationProviderFamilyBuilder get autoDispose {
    return const AutoDisposeMutationProviderFamilyBuilder();
  }
}

/// Builds a [AutoDisposeBlocProviderFamily].
class AutoDisposeMutationProviderFamilyBuilder {
  /// Builds a [AutoDisposeBlocProviderFamily].
  const AutoDisposeMutationProviderFamilyBuilder();

  /// {@macro riverpod.family}
  AutoDisposeBlocProviderFamily<MutationBloc<TParam, TData>, MutationState<TData>, TArg>
      call<TArg, TParam, TData>(
    _FamilyMutator<AutoDisposeBlocProviderRef<MutationBloc<TParam, TData>>, TArg, TParam, TData>
        mutator, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeBlocProviderFamily(
      (ref, arg) => MutationBloc((data) => mutator(ref, arg, data)),
      name: name,
      dependencies: dependencies,
    );
  }
}
