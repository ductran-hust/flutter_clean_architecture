part of 'home_bloc.dart';

@freezed
sealed class HomeEvent with _$HomeEvent {
  const factory HomeEvent.loadData() = _LoadData;
  const factory HomeEvent.completeTask(Task task) = _CompleteTask;
  const factory HomeEvent.deleteTask(Task task) = _DeleteTask;
}