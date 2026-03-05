import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/app_colors.dart';

@RoutePage()
class ChooseModePage extends StatefulWidget {
  final Function(bool isDark)? onContinue;
  const ChooseModePage({super.key, this.onContinue});

  @override
  State<ChooseModePage> createState() => _ChooseModePageState();
}

class _ChooseModePageState extends State<ChooseModePage> {
  bool _isDarkSelected = false; // light selected by default based on screenshot

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dark background
          Container(color: const Color(0xFF2A2A2A)),
          // Face background with overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.grey[700]!.withOpacity(0.6), Colors.grey[900]!.withOpacity(0.9)],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Spotify logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                      child: const Icon(Icons.music_note, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Spotify®',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Choose Mode text
                const Text(
                  'Choose Mode',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                // Mode toggle buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ModeButton(
                      icon: Icons.nightlight_round,
                      label: 'Dark Mode',
                      isSelected: _isDarkSelected,
                      onTap: () => setState(() => _isDarkSelected = true),
                    ),
                    const SizedBox(width: 60),
                    _ModeButton(
                      icon: Icons.wb_sunny_outlined,
                      label: 'Light Mode',
                      isSelected: !_isDarkSelected,
                      onTap: () => setState(() => _isDarkSelected = false),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Continue button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => widget.onContinue?.call(_isDarkSelected),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey[600] : Colors.transparent,
              shape: BoxShape.circle,
              border: isSelected ? null : Border.all(color: Colors.white38, width: 1),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }
}
