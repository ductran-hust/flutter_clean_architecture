import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

/// Mock interceptor — intercepts all requests and returns fake data.
/// Remove this and use real API when backend is ready.
class MockInterceptor extends Interceptor {
  final _uuid = const Uuid();

  // In-memory "database"
  final List<Map<String, dynamic>> _todos = [
    {
      'id': '1',
      'title': 'Buy groceries',
      'description': 'Milk, eggs, bread',
      'isCompleted': false,
      'createdAt': '2026-01-01T08:00:00.000Z',
      'updatedAt': null,
    },
    {
      'id': '2',
      'title': 'Read Flutter docs',
      'description': 'Clean Architecture section',
      'isCompleted': true,
      'createdAt': '2026-01-02T09:00:00.000Z',
      'updatedAt': null,
    },
    {
      'id': '3',
      'title': 'Write unit tests',
      'description': 'Cover repository layer',
      'isCompleted': false,
      'createdAt': '2026-01-03T10:00:00.000Z',
      'updatedAt': null,
    },
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method.toUpperCase();
    final path = options.path;

    // GET /todos
    if (method == 'GET' && path == '/todos') {
      return handler.resolve(_response(options, List<Map<String, dynamic>>.from(_todos)));
    }

    // GET /todos/:id
    if (method == 'GET' && path.startsWith('/todos/')) {
      final id = _extractId(path);
      final todo = _findById(id);
      if (todo == null) {
        return handler.resolve(_response(options, null, statusCode: 404));
      }
      return handler.resolve(_response(options, todo));
    }

    // POST /todos
    if (method == 'POST' && path == '/todos') {
      final body = options.data as Map<String, dynamic>;
      final newTodo = {
        'id': _uuid.v4(),
        'title': body['title'] ?? '',
        'description': body['description'] ?? '',
        'isCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': null,
      };
      _todos.add(newTodo);
      return handler.resolve(_response(options, newTodo, statusCode: 201));
    }

    // PUT /todos/:id
    if (method == 'PUT' && path.startsWith('/todos/')) {
      final id = _extractId(path);
      final index = _findIndex(id);
      if (index == -1) {
        return handler.resolve(_response(options, null, statusCode: 404));
      }
      final body = options.data as Map<String, dynamic>;
      _todos[index] = {..._todos[index], ...body, 'updatedAt': DateTime.now().toIso8601String()};
      return handler.resolve(_response(options, _todos[index]));
    }

    // DELETE /todos/completed
    if (method == 'DELETE' && path == '/todos/completed') {
      _todos.removeWhere((t) => t['isCompleted'] == true);
      return handler.resolve(_response(options, null, statusCode: 204));
    }

    // DELETE /todos/:id
    if (method == 'DELETE' && path.startsWith('/todos/')) {
      final id = _extractId(path);
      _todos.removeWhere((t) => t['id'] == id);
      return handler.resolve(_response(options, null, statusCode: 204));
    }

    // PATCH /todos/:id/toggle
    if (method == 'PATCH' && path.contains('/toggle')) {
      final id = path.split('/')[2];
      final index = _findIndex(id);
      if (index == -1) {
        return handler.resolve(_response(options, null, statusCode: 404));
      }
      _todos[index] = {
        ..._todos[index],
        'isCompleted': !(_todos[index]['isCompleted'] as bool),
        'updatedAt': DateTime.now().toIso8601String(),
      };
      return handler.resolve(_response(options, _todos[index]));
    }

    // Fallback — 404
    handler.resolve(_response(options, {'message': 'Not found'}, statusCode: 404));
  }

  // Helpers
  String _extractId(String path) => path.split('/').last;

  Map<String, dynamic>? _findById(String id) =>
      _todos.cast<Map<String, dynamic>?>().firstWhere((t) => t?['id'] == id, orElse: () => null);

  int _findIndex(String id) => _todos.indexWhere((t) => t['id'] == id);

  Response<dynamic> _response(RequestOptions options, dynamic data, {int statusCode = 200}) {
    // Simulate network delay
    // In a real scenario you'd use Future.delayed, but interceptors are sync
    return Response(requestOptions: options, data: data, statusCode: statusCode);
  }
}
