import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';
import 'package:flutter_clean_architecture/core/theme/text_styles.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppBarAction
// ─────────────────────────────────────────────────────────────────────────────

/// A single action item for the AppBar trailing area.
class AppBarAction {
  const AppBarAction({
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.badge,
  });

  AppBarAction.icon({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
    int? badge,
  }) : this(
    icon: Icon(icon),
    onTap: onTap,
    tooltip: tooltip,
    badge: badge,
  );

  final Widget icon;
  final VoidCallback onTap;
  final String? tooltip;

  /// Optional notification count. Shows a red dot/badge when > 0.
  final int? badge;
}

// ─────────────────────────────────────────────────────────────────────────────
// AppBarLeadingType
// ─────────────────────────────────────────────────────────────────────────────

/// Controls what the leading widget (left side) looks like.
enum AppBarLeadingType {
  /// Back arrow. Pops the route. Shown by default when there's a previous route.
  back,

  /// "×" close icon. Typically used for modal / bottom-sheet-like full screens.
  close,

  /// No leading widget at all.
  none,
}

// ─────────────────────────────────────────────────────────────────────────────
// AppBarView
// ─────────────────────────────────────────────────────────────────────────────

/// Common AppBar component that matches the Figma design language.
///
/// **Design tokens (from Figma screens):**
/// - Background  : transparent (inherits scaffold bg = `#121212`)
/// - Leading icon: 32×32 rounded box (rx=4), fill `#1D1D1D`
/// - Title align : left by default (Settings, Task screens)
/// - Bottom line : none (elevation 0)
///
/// ```dart
/// // Basic back + title
/// AppBarView(title: 'Settings')
///
/// // Close button (modal screen)
/// AppBarView(
///   title: 'Add Task',
///   leadingType: AppBarLeadingType.close,
/// )
///
/// // Custom leading + trailing actions
/// AppBarView(
///   title: 'Home',
///   leadingType: AppBarLeadingType.none,
///   actions: [
///     AppBarAction.icon(icon: Icons.notifications_outlined, onTap: () {}),
///     AppBarAction.icon(icon: Icons.search, onTap: () {}),
///   ],
/// )
///
/// // No title — full custom
/// AppBarView(
///   leadingType: AppBarLeadingType.back,
///   customTitle: MyLogoWidget(),
///   actions: [...],
/// )
/// ```
class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  const AppBarView({
    super.key,
    this.title,
    this.customTitle,
    this.leadingType = AppBarLeadingType.back,
    this.onLeadingTap,
    this.actions = const [],
    this.centerTitle = false,
    this.bottom,
    this.backgroundColor,
    this.foregroundColor,
    this.systemOverlayStyle,
  });

  /// Simple text title. Ignored if [customTitle] is provided.
  final String? title;

  /// Fully custom title widget — overrides [title].
  final Widget? customTitle;

  /// Controls which icon appears on the leading (left) side.
  /// Defaults to [AppBarLeadingType.back].
  final AppBarLeadingType leadingType;

  /// Override the default pop/close action.
  final VoidCallback? onLeadingTap;

  /// Trailing action buttons.
  final List<AppBarAction> actions;

  /// Whether to center the title. Defaults to `false` (left-aligned).
  final bool centerTitle;

  /// Optional widget placed below the toolbar (e.g. TabBar).
  final PreferredSizeWidget? bottom;

  /// Overrides the scaffold background colour.
  final Color? backgroundColor;

  /// Overrides the default foreground (icon / title) colour.
  final Color? foregroundColor;

  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final fgColor = foregroundColor ?? colors.onBackground;
    final bgColor = backgroundColor ?? Colors.transparent;

    return AppBar(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      systemOverlayStyle: systemOverlayStyle ??
          (Theme.of(context).brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark),
      // ── Leading ─────────────────────────────────────────────────────────
      automaticallyImplyLeading: false,
      leading: _buildLeading(context, colors, fgColor),
      leadingWidth: leadingType == AppBarLeadingType.none ? 0 : 56,

      // ── Title ────────────────────────────────────────────────────────────
      title: customTitle ?? _buildTitle(context, colors),
      titleSpacing: leadingType == AppBarLeadingType.none ? 16 : 0,

      // ── Actions ──────────────────────────────────────────────────────────
      actions: actions.isNotEmpty
          ? [
        ...actions.map((a) => _ActionButton(action: a, color: fgColor)),
        const SizedBox(width: 8),
      ]
          : null,

      bottom: bottom,
    );
  }

  Widget? _buildLeading(
      BuildContext context,
      AppColors colors,
      Color fgColor,
      ) {
    switch (leadingType) {
      case AppBarLeadingType.none:
        return null;

      case AppBarLeadingType.back:
        return _LeadingButton(
          icon: Icons.arrow_back_ios_new_rounded,
          color: fgColor,
          surfaceColor: colors.surface,
          onTap: onLeadingTap ?? () => Navigator.of(context).maybePop(),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        );

      case AppBarLeadingType.close:
        return _LeadingButton(
          icon: Icons.close_rounded,
          color: fgColor,
          surfaceColor: colors.surface,
          onTap: onLeadingTap ?? () => Navigator.of(context).maybePop(),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        );
    }
  }

  Widget? _buildTitle(BuildContext context, AppColors colors) {
    if (title == null) return null;

    final textStyles = context.appTextStyles;

    return Text(
      title!,
      style: textStyles.titleLarge.copyWith(
        color: colors.onBackground,
        fontWeight: FontWeight.w700,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LeadingButton — the 32×32 rounded icon box from Figma
// ─────────────────────────────────────────────────────────────────────────────

class _LeadingButton extends StatelessWidget {
  const _LeadingButton({
    required this.icon,
    required this.color,
    required this.surfaceColor,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final Color color;
  final Color surfaceColor;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Tooltip(
        message: tooltip ?? '',
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ActionButton — trailing icon button with optional badge
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.action,
    required this.color,
  });

  final AppBarAction action;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = IconTheme(
      data: IconThemeData(color: color, size: 22),
      child: action.icon,
    );

    // Badge overlay
    final badge = action.badge;
    if (badge != null && badge > 0) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: Text(
                  badge > 99 ? '99+' : '$badge',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    final button = Tooltip(
      message: action.tooltip ?? '',
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: iconWidget,
        ),
      ),
    );

    return button;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SliverAppBarView — sliver variant for CustomScrollView
// ─────────────────────────────────────────────────────────────────────────────

/// Sliver version of [AppBarView] for use inside [CustomScrollView].
///
/// Supports all the same options as [AppBarView] plus [expandedHeight]
/// and [flexibleSpace] for collapsing headers.
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverAppBarView(
///       title: 'Home',
///       expandedHeight: 200,
///       flexibleSpace: FlexibleSpaceBar(
///         background: Image.network(url, fit: BoxFit.cover),
///       ),
///     ),
///   ],
/// )
/// ```
class SliverAppBarView extends StatelessWidget {
  const SliverAppBarView({
    super.key,
    this.title,
    this.customTitle,
    this.leadingType = AppBarLeadingType.back,
    this.onLeadingTap,
    this.actions = const [],
    this.centerTitle = false,
    this.expandedHeight,
    this.flexibleSpace,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String? title;
  final Widget? customTitle;
  final AppBarLeadingType leadingType;
  final VoidCallback? onLeadingTap;
  final List<AppBarAction> actions;
  final bool centerTitle;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final bool pinned;
  final bool floating;
  final bool snap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final fgColor = foregroundColor ?? colors.onBackground;
    final bgColor = backgroundColor ?? colors.background;
    final textStyles = context.appTextStyles;

    Widget? leading;
    double? leadingWidth;

    switch (leadingType) {
      case AppBarLeadingType.none:
        leading = const SizedBox.shrink();
        leadingWidth = 0;
        break;
      case AppBarLeadingType.back:
        leading = _LeadingButton(
          icon: Icons.arrow_back_ios_new_rounded,
          color: fgColor,
          surfaceColor: colors.surface,
          onTap: onLeadingTap ?? () => Navigator.of(context).maybePop(),
        );
        leadingWidth = 56;
        break;
      case AppBarLeadingType.close:
        leading = _LeadingButton(
          icon: Icons.close_rounded,
          color: fgColor,
          surfaceColor: colors.surface,
          onTap: onLeadingTap ?? () => Navigator.of(context).maybePop(),
        );
        leadingWidth = 56;
        break;
    }

    return SliverAppBar(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      pinned: pinned,
      floating: floating,
      snap: snap,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: leading,
      leadingWidth: leadingWidth,
      titleSpacing: leadingType == AppBarLeadingType.none ? 16 : 0,
      title: customTitle ??
          (title != null
              ? Text(
            title!,
            style: textStyles.titleLarge.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
              : null),
      actions: actions.isNotEmpty
          ? [
        ...actions.map((a) => _ActionButton(action: a, color: fgColor)),
        const SizedBox(width: 8),
      ]
          : null,
    );
  }
}