import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/extensions/num_extensions.dart';
import 'package:flutter_clean_architecture/routes/app_router.dart';

/// A debug screen that lists all registered routes in the app.
///
/// Features:
/// - Auto-groups routes by first path segment
/// - Search by screen name, screen code, or path
/// - Highlights search query in results
/// - Supports navigation to screens with mock arguments
///
/// To configure a route, add meta to [AppRouter]:
/// ```dart
/// AutoRoute(
///   page: TodoListRoute.page,
///   path: '/debug/todos',
///   meta: const {
///     'screenName': 'TodoList',
///     'screenCode': 'DBG-004',
///   },
/// )
/// ```
@RoutePage()
class ScreenListPage extends StatelessWidget {
  const ScreenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ScreenListView();
  }
}

class _ScreenListView extends StatefulWidget {
  const _ScreenListView();

  @override
  State<_ScreenListView> createState() => _ScreenListViewState();
}

class _ScreenListViewState extends State<_ScreenListView> {
  final _searchController = TextEditingController();
  String _query = '';

  static String _groupFromPath(String? path) {
    if (path == null) return 'Other';

    final segment = path
        .split('/')
        .where((s) => s.isNotEmpty && !s.startsWith(':'))
        .firstOrNull;

    if (segment == null) return 'Other';

    return segment
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  List<AutoRoute> _getRoutes() {
    final router = context.router.root as AppRouter;
    return router.routes
        .where((r) => r.meta['screenCode'] != null)
        .where((r) => r.meta['screenCode'] != 'DBG-001')
        .toList();
  }

  List<AutoRoute> _filterRoutes(List<AutoRoute> routes) {
    if (_query.isEmpty) return routes;

    final q = _query.toLowerCase();
    return routes.where((route) {
      final screenName = (route.meta['screenName'] as String? ?? '').toLowerCase();
      final screenCode = (route.meta['screenCode'] as String? ?? '').toLowerCase();
      final path = (route.path ?? '').toLowerCase();

      return screenName.contains(q) ||
          screenCode.contains(q) ||
          path.contains(q);
    }).toList();
  }

  Map<String, List<AutoRoute>> _groupRoutes(List<AutoRoute> routes) {
    final grouped = <String, List<AutoRoute>>{};
    for (final route in routes) {
      final group = _groupFromPath(route.path);
      grouped.putIfAbsent(group, () => []).add(route);
    }
    return grouped;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allRoutes = _getRoutes();
    final filtered = _filterRoutes(allRoutes);
    final grouped = _groupRoutes(filtered);

    return Scaffold(
      appBar: AppBar(title: const Text('Screen List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search by name, code, path...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          if (filtered.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No screens found',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: ListView(
                children: grouped.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _GroupHeader(title: entry.key),
                      ...entry.value.map((route) => _ScreenTile(
                        route: route,
                        query: _query,
                      )),
                      4.verticalSpace,
                      const Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _ScreenTile extends StatelessWidget {
  const _ScreenTile({required this.route, required this.query});

  final AutoRoute route;
  final String query;

  String get _screenName =>
      route.meta['screenName'] as String? ?? route.path ?? '';

  String get _screenCode => route.meta['screenCode'] as String? ?? '';

  String get _path => route.path ?? '';

  Map<String, dynamic>? get _mockArgs =>
      route.meta['mockArgs'] as Map<String, dynamic>?;

  void _handleTap(BuildContext context) {
    final mockArgs = _mockArgs;
    if (mockArgs != null && mockArgs.isNotEmpty) {
      _showArgsDialog(context, mockArgs);
    } else {
      context.router.pushPath(_path);
    }
  }

  void _showArgsDialog(
      BuildContext context,
      Map<String, dynamic> mockArgs,
      ) {
    final controllers = {
      for (final entry in mockArgs.entries)
        entry.key: TextEditingController(
          text: entry.value?.toString() ?? '',
        ),
    };

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Params — $_screenName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: controllers.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: entry.value,
                decoration: InputDecoration(
                  labelText: entry.key,
                  hintText: mockArgs[entry.key]?.toString() ?? '',
                  border: const OutlineInputBorder(),
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              var resolvedPath = _path;
              controllers.forEach((key, controller) {
                final value = controller.text.isNotEmpty
                    ? controller.text
                    : mockArgs[key]?.toString() ?? key;
                resolvedPath = resolvedPath.replaceAll(':$key', value);
              });
              context.router.pushPath(resolvedPath);
              for (final c in controllers.values) {
                c.dispose();
              }
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleTap(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: _HighlightText(
                text: _screenCode,
                query: query,
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'monospace',
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HighlightText(
                    text: _screenName,
                    query: query,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  _HighlightText(
                    text: _path,
                    query: query,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (_mockArgs != null)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.tune, size: 14, color: Colors.grey),
              ),
            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _HighlightText extends StatelessWidget {
  const _HighlightText({
    required this.text,
    required this.query,
    this.style,
  });

  final String text;
  final String query;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) return Text(text, style: style);

    final q = query.toLowerCase();
    final lower = text.toLowerCase();
    final index = lower.indexOf(q);

    if (index == -1) return Text(text, style: style);

    final before = text.substring(0, index);
    final match = text.substring(index, index + query.length);
    final after = text.substring(index + query.length);

    final baseStyle = style ?? DefaultTextStyle.of(context).style;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: before, style: baseStyle),
          TextSpan(
            text: match,
            style: baseStyle.copyWith(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: after, style: baseStyle),
        ],
      ),
    );
  }
}