import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/app_colors.dart';

@RoutePage()
class MusicPlayerPage extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onLyrics;

  const MusicPlayerPage({super.key, this.onBack, this.onLyrics});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  bool _isPlaying = true;
  bool _isFavorite = false;
  double _progress = 0.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack ?? () => Navigator.maybePop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: const Icon(Icons.chevron_left, color: Colors.black),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Now playing',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Icon(Icons.more_vert, color: Colors.black54),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Album art
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF1A3020),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.person, size: 180, color: Colors.green.withOpacity(0.3)),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.green.withOpacity(0.4)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Song info + favorite
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bad Guy',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Billie Eilish',
                        style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _isFavorite = !_isFavorite),
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? AppColors.green : Colors.grey[400],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                      activeTrackColor: Colors.black87,
                      inactiveTrackColor: Colors.grey[300],
                      thumbColor: Colors.black87,
                    ),
                    child: Slider(
                      value: _progress,
                      onChanged: (v) => setState(() => _progress = v),
                    ),
                  ),
                  Row(
                    children: [
                      Text('2:25', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                      const Spacer(),
                      Text('4:02', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Control buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.repeat, color: Colors.grey[400], size: 26),
                  Icon(Icons.skip_previous, color: Colors.black87, size: 36),
                  GestureDetector(
                    onTap: () => setState(() => _isPlaying = !_isPlaying),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  Icon(Icons.skip_next, color: Colors.black87, size: 36),
                  Icon(Icons.shuffle, color: Colors.grey[400], size: 26),
                ],
              ),
            ),

            const Spacer(),

            // Lyrics button
            GestureDetector(
              onTap: widget.onLyrics,
              child: Column(
                children: [
                  const Icon(Icons.keyboard_arrow_up, color: Colors.black54),
                  Text('Lyrics', style: TextStyle(color: Colors.black54, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
