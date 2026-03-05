sealed class UIState {
  const UIState();
  const factory UIState.initial() = UIStateInitial;
  const factory UIState.loading() = UIStateLoading;
  const factory UIState.success() = UIStateSuccess;
  const factory UIState.error(String message) = UIStateError;
}

final class UIStateInitial extends UIState {
  const UIStateInitial();
}

final class UIStateLoading extends UIState {
  const UIStateLoading();
}

final class UIStateSuccess extends UIState {
  const UIStateSuccess();
}

final class UIStateError extends UIState {
  const UIStateError(this.message);
  final String message;
}
