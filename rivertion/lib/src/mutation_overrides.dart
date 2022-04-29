// typedef ThrowErrorCondition = bool Function(Object error);
//
// class MutationOverrides {
//   static final _zoneToken = Object();
//
//   final ThrowErrorCondition emitErrorWhen;
//
//   const MutationOverrides._({required this.emitErrorWhen});
//
//   factory MutationOverrides({
//     bool Function(Object error)? emitErrorWhen,
//   }) {
//     final currentOverrides = MutationOverrides.fromZone();
//     return MutationOverrides._(
//       emitErrorWhen: emitErrorWhen ?? currentOverrides.emitErrorWhen,
//     );
//   }
//
//   factory MutationOverrides.fromZone() {
//     return (Zone.current[_zoneToken] as MutationOverrides?) ??
//         const MutationOverrides._(
//           emitErrorWhen: defaultThrowErrorWhen,
//         );
//   }
//
//   static Map<Object, Object> wrapZoneValues({
//     required MutationOverrides overrides,
//     required Map<Object, Object> dependencies,
//   }) {
//     return {
//       ...dependencies,
//       _zoneToken: overrides,
//     };
//   }
//
//   static bool defaultThrowErrorWhen(Object error) => false;
// }
