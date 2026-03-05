import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/base/base_state.dart';
import 'package:flutter_clean_architecture/core/base/ui_state.dart';
import 'package:flutter_clean_architecture/core/utils/app_logger.dart';

abstract class BaseController<T> extends Cubit<BaseState<T>> {
  BaseController(super.initialState);

  Future<void> initData();

  Future<void> retry() => initData();

  Future<R> launch<R>(Future<R> Function() function) async {
    if (state.uiState is UIStateSuccess) {
      try {
        _showLoading();
        final result = await function();
        _hideLoading();
        return result;
      } catch (e, s) {
        _hideLoading();
        handleError(e, s);
        rethrow;
      }
    } else {
      try {
        emit(state.copyWith(uiState: const UIState.loading()));
        final result = await function();
        emit(state.copyWith(uiState: const UIState.success()));
        return result;
      } catch (e, s) {
        emit(state.copyWith(uiState: UIState.error(e.toString())));
        handleError(e, s);
        rethrow;
      }
    }
  }

  void updateData(T newData) => emit(state.copyWith(data: newData));

  void _showLoading() => emit(state.copyWith(isLoading: true));

  void _hideLoading() => emit(state.copyWith(isLoading: false));

  void handleError(Object e, StackTrace s) {
    AppLogger.e('[$runtimeType] error', error: e, stackTrace: s);
    emit(state.copyWith(error: e));
  }

  void clearError() => emit(state.clearError());
}
