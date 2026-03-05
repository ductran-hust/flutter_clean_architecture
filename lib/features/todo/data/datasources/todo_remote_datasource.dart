import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/features/todo/data/models/todo_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'todo_remote_datasource.g.dart';

@RestApi()
@injectable
abstract class TodoRemoteDataSource {
  @factoryMethod
  factory TodoRemoteDataSource(Dio dio) = _TodoRemoteDataSource;

  @GET('/todos')
  Future<List<TodoModel>> getTodos();

  @GET('/todos/{id}')
  Future<TodoModel> getTodoById(@Path('id') String id);

  @POST('/todos')
  Future<TodoModel> createTodo(@Body() Map<String, dynamic> body);

  @PUT('/todos/{id}')
  Future<TodoModel> updateTodo(@Path('id') String id, @Body() TodoModel todo);

  @DELETE('/todos/{id}')
  Future<void> deleteTodo(@Path('id') String id);

  @DELETE('/todos/completed')
  Future<void> deleteCompletedTodos();

  @PATCH('/todos/{id}/toggle')
  Future<TodoModel> toggleTodoCompletion(@Path('id') String id);
}
