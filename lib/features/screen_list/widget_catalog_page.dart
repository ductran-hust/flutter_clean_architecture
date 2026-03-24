import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/colors.dart';
import 'package:flutter_clean_architecture/core/theme/text_styles.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_avatar.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_badge.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_button.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_card.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_chip.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_divider.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_dropdown.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_list_tile.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_status_tag.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_text_field.dart';

/// Debug screen listing all UI components.
/// Add to your router in DEBUG mode:
///   AutoRoute(page: WidgetCatalogRoute.page, path: '/debug/widgets')
@RoutePage()
class WidgetCatalogPage extends StatefulWidget {
  const WidgetCatalogPage({super.key});

  @override
  State<WidgetCatalogPage> createState() => _WidgetCatalogPageState();
}

class _WidgetCatalogPageState extends State<WidgetCatalogPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _selectedCategory;
  bool _chipA = true;
  bool _chipB = false;
  bool _isLoading = false;

  static const _categories = ['Work', 'Personal', 'Health', 'Finance'];

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Catalog')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // ── Section: Typography ──────────────────────────────────────────
          _Section(label: 'Typography', children: [
            Text('Headline Large', style: textStyles.headlineLarge.copyWith(color: colors.onSurfaceMuted)),
            Text('Headline Small', style: textStyles.headlineSmall.copyWith(color: colors.onSurfaceMuted)),
            Text('Title Medium', style: textStyles.titleMedium.copyWith(color: colors.onSurfaceMuted)),
            Text('Body Large', style: textStyles.bodyLarge.copyWith(color: colors.onSurfaceMuted)),
            Text('Body Medium — muted', style: textStyles.bodyMedium.copyWith(color: colors.onSurfaceMuted)),
            Text('Label Large', style: textStyles.labelLarge.copyWith(color: colors.onSurfaceMuted)),
            Text('Body Small', style: textStyles.bodySmall.copyWith(color: colors.onSurfaceMuted)),
          ]),

          // ── Section: Buttons ─────────────────────────────────────────────
          _Section(label: 'Buttons', children: [
            AppButton(label: 'Login', onPressed: () {}),
            const SizedBox(height: 12),
            AppButton.outlined(label: 'Register', onPressed: () {}),
            const SizedBox(height: 12),
            AppButton.ghost(label: 'Forgot password?', onPressed: () {}),
            const SizedBox(height: 12),
            AppButton.danger(label: 'Delete account', onPressed: () {}),
            const SizedBox(height: 12),
            const AppButton(
              label: 'Disabled',
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Loading',
              isLoading: _isLoading,
              onPressed: () async {
                setState(() => _isLoading = true);
                await Future.delayed(const Duration(seconds: 2));
                if (mounted) setState(() => _isLoading = false);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Medium',
                    size: AppButtonSize.medium,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                AppButton(
                  label: 'Small',
                  size: AppButtonSize.small,
                  isFullWidth: false,
                  onPressed: () {},
                ),
              ],
            ),
          ]),

          // ── Section: Text Fields ─────────────────────────────────────────
          _Section(label: 'Text Fields', children: [
            AppTextField(
              label: 'Email',
              hint: 'you@example.com',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 12),
            AppTextField.password(controller: _passCtrl),
            const SizedBox(height: 12),
            const AppTextField(
              label: 'Disabled Field',
              hint: 'Cannot edit this',
              enabled: false,
              prefixIcon: Icons.lock_outline,
            ),
            const SizedBox(height: 12),
            const AppTextField(
              label: 'With Error',
              errorText: 'This field is required',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 12),
            const AppTextField(
              label: 'Note',
              hint: 'Write something...',
              maxLines: 4,
              minLines: 3,
            ),
          ]),

          // ── Section: Dropdown ────────────────────────────────────────────
          _Section(label: 'Dropdown', children: [
            AppDropdown<String>(
              label: 'Category',
              hint: 'Select a category',
              value: _selectedCategory,
              items: _categories,
              prefixIcon: Icons.category_outlined,
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
          ]),

          // ── Section: Chips ───────────────────────────────────────────────
          _Section(label: 'Chips', children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppChip(
                  label: 'Work',
                  isSelected: _chipA,
                  leading: const Icon(Icons.work_outline, size: 14),
                  onTap: () => setState(() => _chipA = !_chipA),
                ),
                AppChip(
                  label: 'Personal',
                  isSelected: _chipB,
                  onTap: () => setState(() => _chipB = !_chipB),
                ),
                AppChip(
                  label: 'Removable',
                  isSelected: true,
                  onTap: () {},
                  onDeleted: () {},
                ),
                const AppChip(label: 'Inactive'),
              ],
            ),
          ]),

          // ── Section: Status Tags ─────────────────────────────────────────
          const _Section(label: 'Status Tags', children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppStatusTag(label: 'Active', type: AppStatusTagType.success, icon: Icons.check_circle_outline),
                AppStatusTag(label: 'Error', type: AppStatusTagType.error, icon: Icons.error_outline),
                AppStatusTag(label: 'Pending', type: AppStatusTagType.warning, icon: Icons.access_time),
                AppStatusTag(label: 'Info', type: AppStatusTagType.info),
                AppStatusTag(label: 'Neutral'),
              ],
            ),
          ]),

          // ── Section: Badges ──────────────────────────────────────────────
          const _Section(label: 'Badges', children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppBadge(
                  count: 3,
                  child: Icon(Icons.notifications_outlined, size: 28),
                ),
                AppBadge(
                  count: 99,
                  child: Icon(Icons.mail_outline, size: 28),
                ),
                AppBadge(
                  count: 120,
                  child: Icon(Icons.chat_bubble_outline, size: 28),
                ),
                AppBadge(
                  count: 0,
                  child: Icon(Icons.shopping_cart_outlined, size: 28),
                ),
              ],
            ),
          ]),

          // ── Section: Cards ───────────────────────────────────────────────
          _Section(label: 'Cards', children: [
            AppCard(
              onTap: () {},
              child: Row(
                children: [
                  const AppAvatar(name: 'John Doe', size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: textStyles.titleSmall.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        Text(
                          'john@example.com',
                          style: textStyles.bodySmall.copyWith(
                            color: colors.onSurfaceMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const AppStatusTag(
                    label: 'Pro',
                    type: AppStatusTagType.info,
                  ),
                ],
              ),
            ),
          ]),

          // ── Section: List Tiles ──────────────────────────────────────────
          _Section(label: 'List Tiles', children: [
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  AppListTile(
                    leading: Icon(Icons.person_outline, color: colors.primary),
                    title: 'Profile',
                    subtitle: 'View and edit your profile',
                    onTap: () {},
                    showDivider: true,
                  ),
                  AppListTile(
                    leading: Icon(Icons.notifications_outlined, color: colors.primary),
                    title: 'Notifications',
                    trailing: const AppBadge(count: 3, child: SizedBox(width: 8, height: 8)),
                    onTap: () {},
                    showDivider: true,
                  ),
                  AppListTile(
                    leading: Icon(Icons.settings_outlined, color: colors.primary),
                    title: 'Settings',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ]),

          // ── Section: Dividers ────────────────────────────────────────────
          const _Section(label: 'Dividers', children: [
            AppDivider(),
            SizedBox(height: 8),
            AppDivider.labeled(label: 'or continue with'),
            SizedBox(height: 8),
            AppDivider(),
          ]),

          // ── Section: Avatars ─────────────────────────────────────────────
          const _Section(label: 'Avatars', children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppAvatar(name: 'Alice B', size: 56),
                AppAvatar(name: 'CD', size: 48),
                AppAvatar(name: 'E'),
                AppAvatar(size: 32),
              ],
            ),
          ]),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            label.toUpperCase(),
            style: textStyles.labelSmall.copyWith(
              color: colors.onSurfaceMuted,
              letterSpacing: 1.5,
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 32),
      ],
    );
  }
}