import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_bar_view.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_button.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_checkbox.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_chip.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_dialog.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_dropdown.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_radio.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_switch.dart';
import 'package:flutter_clean_architecture/shared/components/atoms/app_text_field.dart';

/// A debug screen that previews all shared widgets in the app.
///
/// Useful for:
/// - Quickly checking widget styles and variants
/// - Validating theme changes across all components
/// - Onboarding new developers to available UI components
///
/// Add to [AppRouter] in debug mode only:
/// ```dart
/// if (kDebugMode)
///   AutoRoute(
///     page: WidgetCatalogRoute.page,
///     path: '/debug/widgets',
///     meta: const {
///       'screenName': 'WidgetCatalog',
///       'screenCode': 'SCREEN-015',
///     },
///   ),
/// ```
@RoutePage()
class WidgetCatalogPage extends StatefulWidget {
  const WidgetCatalogPage({super.key});

  @override
  State<WidgetCatalogPage> createState() => _WidgetCatalogPageState();
}

class _WidgetCatalogPageState extends State<WidgetCatalogPage> {
  // TextField
  final _textController = TextEditingController();

  // Checkbox
  bool _checkboxValue = false;
  bool _checkboxChecked = true;

  // Switch
  bool _switchValue = false;

  // Radio
  String _radioValue = 'option1';

  // Chip
  bool _chip1Selected = true;
  bool _chip2Selected = false;
  bool _chip3Selected = false;

  // Dropdown
  String? _dropdownValue;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarView(title: 'Widget Catalog'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(title: 'Button', children: [
            _Row(children: [
              AppButton(label: 'Filled', onPressed: () {}),
              AppButton(label: 'Outlined', onPressed: () {}, variant: AppButtonVariant.outlined),
              AppButton(label: 'Text', onPressed: () {}, variant: AppButtonVariant.text),
            ]),
            const SizedBox(height: 8),
            _Row(children: [
              AppButton(label: 'Small', onPressed: () {}, size: AppButtonSize.small),
              AppButton(label: 'Medium', onPressed: () {}),
              AppButton(label: 'Large', onPressed: () {}, size: AppButtonSize.large),
            ]),
            const SizedBox(height: 8),
            _Row(children: [
              AppButton(label: 'Prefix', onPressed: () {}, prefixIcon: Icons.add),
              AppButton(label: 'Suffix', onPressed: () {}, suffixIcon: Icons.arrow_forward),
              AppButton(label: 'Loading', onPressed: () {}, isLoading: true),
            ]),
            const SizedBox(height: 8),
            AppButton(label: 'Full Width', onPressed: () {}, isFullWidth: true),
            const SizedBox(height: 8),
            const AppButton(label: 'Disabled', isFullWidth: true),
          ]),

          _Section(title: 'Text Field', children: [
            AppTextField(
              controller: _textController,
              label: 'Label',
              hint: 'Hint text',
            ),
            const SizedBox(height: 8),
            const AppTextField(
              label: 'With prefix icon',
              hint: 'Search...',
              prefixIcon: Icons.search,
            ),
            const SizedBox(height: 8),
            const AppTextField(
              label: 'With error',
              errorText: 'This field is required',
            ),
            const SizedBox(height: 8),
            const AppTextField(
              label: 'Disabled',
              hint: 'Cannot edit',
              enabled: false,
            ),
            const SizedBox(height: 8),
            const AppTextField(
              label: 'Multiline',
              hint: 'Enter long text...',
              maxLines: 3,
            ),
          ]),

          _Section(title: 'Checkbox', children: [
            _Row(children: [
              AppCheckbox(
                value: _checkboxValue,
                onChanged: (v) => setState(() => _checkboxValue = v ?? false),
                label: 'Unchecked',
              ),
              AppCheckbox(
                value: _checkboxChecked,
                onChanged: (v) => setState(() => _checkboxChecked = v ?? false),
                label: 'Checked',
              ),
            ]),
            const SizedBox(height: 8),
            AppCheckbox(
              value: false,
              onChanged: (_) {},
              label: 'Disabled',
              enabled: false,
            ),
          ]),

          _Section(title: 'Switch', children: [
            AppSwitch(
              value: _switchValue,
              onChanged: (v) => setState(() => _switchValue = v),
              label: 'Toggle feature',
              description: 'Enable or disable this feature',
            ),
            const SizedBox(height: 8),
            AppSwitch(
              value: true,
              onChanged: (_) {},
              label: 'Disabled switch',
              enabled: false,
            ),
          ]),

          _Section(title: 'Radio', children: [
            AppRadioGroup<String>(
              value: _radioValue,
              onChanged: (v) => setState(() => _radioValue = v),
              items: const [
                AppRadioItem(label: 'Option 1', value: 'option1'),
                AppRadioItem(label: 'Option 2', value: 'option2'),
                AppRadioItem(label: 'Option 3', value: 'option3'),
              ],
            ),
            const SizedBox(height: 8),
            AppRadioGroup<String>(
              value: _radioValue,
              onChanged: (v) => setState(() => _radioValue = v),
              direction: Axis.horizontal,
              items: const [
                AppRadioItem(label: 'A', value: 'option1'),
                AppRadioItem(label: 'B', value: 'option2'),
                AppRadioItem(label: 'C', value: 'option3'),
              ],
            ),
          ]),

          _Section(title: 'Chip', children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppChip(
                  label: 'Selected',
                  selected: _chip1Selected,
                  onTap: () => setState(() => _chip1Selected = !_chip1Selected),
                ),
                AppChip(
                  label: 'Unselected',
                  selected: _chip2Selected,
                  onTap: () => setState(() => _chip2Selected = !_chip2Selected),
                ),
                AppChip(
                  label: 'With icon',
                  selected: _chip3Selected,
                  prefixIcon: Icons.music_note,
                  onTap: () => setState(() => _chip3Selected = !_chip3Selected),
                ),
                AppChip(
                  label: 'Deletable',
                  onDeleted: () {},
                ),
              ],
            ),
          ]),

          _Section(title: 'Dropdown', children: [
            AppDropdown<String>(
              value: _dropdownValue,
              label: 'Select option',
              hint: 'Choose one',
              onChanged: (v) => setState(() => _dropdownValue = v),
              items: const [
                AppDropdownItem(label: 'Option A', value: 'a', icon: Icons.star),
                AppDropdownItem(label: 'Option B', value: 'b', icon: Icons.favorite),
                AppDropdownItem(label: 'Option C', value: 'c', icon: Icons.music_note),
              ],
            ),
            const SizedBox(height: 8),
            AppDropdown<String>(
              value: null,
              label: 'Disabled',
              hint: 'Cannot select',
              enabled: false,
              onChanged: (_) {},
              items: const [
                AppDropdownItem(label: 'Option A', value: 'a'),
              ],
            ),
          ]),

          _Section(title: 'Dialog', children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppButton(
                  label: 'Success',
                  onPressed: () => AppDialog.success(context, message: 'Operation completed successfully.'),
                  color: Colors.green,
                  size: AppButtonSize.small,
                ),
                AppButton(
                  label: 'Error',
                  onPressed: () => AppDialog.error(context, message: 'Something went wrong. Please try again.'),
                  color: Colors.red,
                  size: AppButtonSize.small,
                ),
                AppButton(
                  label: 'Warning',
                  onPressed: () => AppDialog.warning(context, message: 'This action cannot be undone.'),
                  color: Colors.orange,
                  size: AppButtonSize.small,
                ),
                AppButton(
                  label: 'Info',
                  onPressed: () => AppDialog.info(context, message: 'Here is some useful information.'),
                  size: AppButtonSize.small,
                ),
                AppButton(
                  label: 'Confirm',
                  onPressed: () async {
                    final result = await AppDialog.confirm(
                      context,
                      message: 'Are you sure you want to proceed?',
                    );
                    if (context.mounted) {
                      AppDialog.info(context, message: 'Result: $result');
                    }
                  },
                  variant: AppButtonVariant.outlined,
                  size: AppButtonSize.small,
                ),
                AppButton(
                  label: 'Dangerous',
                  onPressed: () async {
                    await AppDialog.confirm(
                      context,
                      title: 'Delete Item',
                      message: 'This will permanently delete the item.',
                      isDangerous: true,
                      confirmLabel: 'Delete',
                    );
                  },
                  color: Colors.red,
                  variant: AppButtonVariant.outlined,
                  size: AppButtonSize.small,
                ),
                AppButton(
                  label: 'Input',
                  onPressed: () async {
                    final result = await AppDialog.input(
                      context,
                      title: 'Enter Name',
                      hint: 'Your name',
                    );
                    if (context.mounted && result != null) {
                      AppDialog.success(context, message: 'Hello, $result!');
                    }
                  },
                  variant: AppButtonVariant.outlined,
                  size: AppButtonSize.small,
                ),
                AppButton(
                  label: 'Loading',
                  onPressed: () async {
                    AppDialog.showLoading(context);
                    await Future.delayed(const Duration(seconds: 2));
                    if (context.mounted) AppDialog.hideLoading(context);
                  },
                  variant: AppButtonVariant.outlined,
                  size: AppButtonSize.small,
                ),
              ],
            ),
          ]),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Internal Widgets ──────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 12),
          child: Row(
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: Divider(color: Colors.grey.shade200)),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: children,
    );
  }
}