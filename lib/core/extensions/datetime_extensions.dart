enum AppDateFormat {
  /// 24/02/2026
  ddMMyyyy('dd/MM/yyyy'),

  /// 2026-02-24
  yyyyMMdd('yyyy-MM-dd'),

  /// 2026-02-24 13:00
  yyyyMMddHHmm('yyyy-MM-dd HH:mm'),

  /// 2026-02-24 13:00:00
  yyyyMMddHHmmss('yyyy-MM-dd HH:mm:ss'),

  /// 24/02/2026 13:00
  ddMMyyyyHHmm('dd/MM/yyyy HH:mm'),

  /// 13:00
  HHmm('HH:mm'),

  /// 13:00:00
  HHmmss('HH:mm:ss');

  const AppDateFormat(this.pattern);
  final String pattern;
}

extension StringDateExtension on String {
  DateTime? toDateTimeOrNull() => DateTime.tryParse(this);
  DateTime toDateTime() => DateTime.parse(this);
}

extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  bool get isPast => isBefore(DateTime.now());
  bool get isFuture => isAfter(DateTime.now());

  String toRelativeLabel({AppDateFormat format = .ddMMyyyy}) {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    if (isTomorrow) return 'Tomorrow';
    return toFormatted(format);
  }

  String toFormatted(AppDateFormat format) {
    final y = year.toString().padLeft(4, '0');
    final M = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    final H = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    final s = second.toString().padLeft(2, '0');
    return format.pattern
        .replaceAll('yyyy', y)
        .replaceAll('MM', M)
        .replaceAll('dd', d)
        .replaceAll('HH', H)
        .replaceAll('mm', m)
        .replaceAll('ss', s);
  }
}
