// ignore_for_file: invalid_use_of_internal_member, subtype_of_sealed_class

import 'package:riverbloc/riverbloc.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';
import 'package:rivertion/src/mutation_bloc.dart';

/// {@macro bloc_provider}
class MutationProvider<TParam, TData>
    extends BlocProvider<MutationBloc<TParam, TData>, MutationState<TData>> {
  MutationProvider(
    Create<MutationBloc<TParam, TData>,
            BlocProviderRef<MutationBloc<TParam, TData>, MutationState<TData>>>
        create, {
    String? name,
    Family? from,
    Object? argument,
    List<ProviderOrFamily>? dependencies,
  }) : super(
          create,
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
    Create<MutationBloc<TParam, TData>,
            AutoDisposeBlocProviderRef<MutationBloc<TParam, TData>, MutationState<TData>>>
        create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeBlocProvider(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.family}
  AutoDisposeMutationProviderFamilyBuilder get family {
    return const AutoDisposeMutationProviderFamilyBuilder();
  }
}

/// Builds a [BlocProviderFamily].
class MutationProviderFamilyBuilder {
  /// Builds a [BlocProviderFamily].
  const MutationProviderFamilyBuilder();

  /// {@macro riverpod.family}
  BlocProviderFamily<MutationBloc<TParam, TData>, MutationState<TData>, TArg>
      call<TArg, TParam, TData>(
    FamilyCreate<MutationBloc<TParam, TData>,
            BlocProviderRef<MutationBloc<TParam, TData>, MutationState<TData>>, TArg>
        create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) {
    return BlocProviderFamily(
      create,
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
    FamilyCreate<MutationBloc<TParam, TData>,
            AutoDisposeBlocProviderRef<MutationBloc<TParam, TData>, MutationState<TData>>, TArg>
        create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeBlocProviderFamily(
      create,
      name: name,
      dependencies: dependencies,
    );
  }
}
