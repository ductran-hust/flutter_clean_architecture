import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/presentation/router/router.dart';
import 'package:flutter_clean_architecture/shared/extension/datetime.dart';

import '../../../base/base_page.dart';
import 'components/category_grid.dart';
import 'components/task_list.dart';
import 'home_bloc.dart';

@RoutePage()
class HomePage extends BasePage<HomeBloc, HomeEvent, HomeState> {
  const HomePage({Key? key}) : super(key: key);

  @override
  void onInitState(BuildContext context) {
    context.read<HomeBloc>().add(const HomeEvent.loadData());
    super.onInitState(context);
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateTime.now().format(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const CategoryGrid(),
              const SizedBox(height: 20),
              const Expanded(
                child: TaskList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.pushRoute<bool>(NewTaskRoute());

          if(result == true) {
            context.read<HomeBloc>().add(const HomeEvent.loadData());
          }
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}