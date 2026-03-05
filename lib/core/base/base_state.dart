import 'package:flutter_clean_architecture/core/base/ui_state.dart';

class BaseState<T> {
  const BaseState({
    required this.data,
    this.isLoading = false,
    this.error,
    this.uiState = const UIState.initial(),
  });

  final UIState uiState;
  final bool isLoading;
  final Object? error;
  final T data;

  BaseState<T> copyWith({UIState? uiState, bool? isLoading, Object? error, T? data}) {
    return BaseState<T>(
      uiState: uiState ?? this.uiState,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }

  BaseState<T> clearError() {
    return BaseState<T>(uiState: uiState, isLoading: isLoading, data: data);
  }
}
