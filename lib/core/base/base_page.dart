import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/base/base_controller.dart';
import 'package:flutter_clean_architecture/core/base/base_state.dart';
import 'package:flutter_clean_architecture/core/base/ui_state.dart';
import 'package:flutter_clean_architecture/core/di/injection_container.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_dialog.dart';

abstract class BasePage<C extends BaseController<T>, T> extends StatefulWidget {
  const BasePage({super.key});

  C createController() {
    return getIt<C>();
  }

  Widget builder(BuildContext context, C cubit, T data);

  Widget buildInitialView() => const _InitialView();

  Widget buildLoadingView() => const _LoadingView();

  Widget buildErrorView({required String message, required VoidCallback onRetry}) =>
      _ErrorView(message: message, onRetry: onRetry);

  @override
  State<BasePage<C, T>> createState() => _BasePageState<C, T>();
}

class _BasePageState<C extends BaseController<T>, T> extends State<BasePage<C, T>> {
  late final C _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.createController();
    _controller.initData();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _controller,
      child: MultiBlocListener(
        listeners: [
          BlocListener<C, BaseState<T>>(
            listenWhen: (prev, curr) => prev.isLoading != curr.isLoading,
            listener: (_, state) {
              if (state.isLoading) {
                AppDialog.showLoading(context);
              } else {
                AppDialog.hideLoading(context);
              }
            },
          ),
          BlocListener<C, BaseState<T>>(
            listenWhen: (prev, curr) =>
                prev.error != curr.error && curr.error != null && curr.uiState is UIStateSuccess,
            listener: (context, state) {
              AppDialog.error(context, message: state.error.toString());
            },
          ),
        ],
        child: BlocBuilder<C, BaseState<T>>(
          buildWhen: (prev, curr) => prev.uiState != curr.uiState || prev.data != curr.data,
          builder: (context, state) {
            return switch (state.uiState) {
              UIStateInitial() => widget.buildInitialView(),
              UIStateLoading() => widget.buildLoadingView(),
              UIStateSuccess() => widget.builder(context, _controller, state.data),
              UIStateError() => widget.buildErrorView(
                message: (state.uiState as UIStateError).message,
                onRetry: _controller.retry,
              ),
            };
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text('Something went wrong', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _InitialView extends StatelessWidget {
  const _InitialView();

  @override
  Widget build(BuildContext context) => const Scaffold();
}
