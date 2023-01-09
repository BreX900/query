# CHANGELOG

## 2.0.0
- Support riverpod ^2.0.0

## 0.1.0-dev.3
- Fix MutationBloc emit new state when it is closed
- Added on `MutationState` new methods: `mapOrNull`, `when`, `maybeWhen`, `whenOrNull`

## 0.1.0-dev.2
- Now the errors of onFailed, onSuccess, onSettled are brought back to BlocObserver
- Fix DebounceBloc not correct emits state 

## 0.1.0-dev.1

- Perform asynchronous data mutations
- Refresh a provider's when mutation complete
