import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/app_colors.dart';

@RoutePage()
class GetStartedPage extends StatelessWidget {
  final VoidCallback? onGetStarted;
  const GetStartedPage({super.key, this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image (placeholder with gradient)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
              ),
            ),
          ),
          // Colorful overlay on face
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.purple.withOpacity(0.4),
                    Colors.green.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
          // Face silhouette
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            height: 420,
            child: Center(
              child: Container(
                width: 260,
                height: 380,
                decoration: BoxDecoration(color: Colors.transparent),
                child: CustomPaint(painter: _FacePortraitPainter()),
              ),
            ),
          ),
          // Spotify logo
          Positioned(top: 50, left: 0, right: 0, child: _SpotifyLogo()),
          // Bottom content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Enjoy Listening To Music',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit. Sagittis enim\npurus sed phasellus. Cursus ornare id\nscelerisque aliquam.',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14, height: 1.6),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: onGetStarted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FacePortraitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey[800]!;
    // Simple face oval
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.1, size.width * 0.6, size.height * 0.75),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpotifyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
          style: TextStyle(color: AppColors.green, fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
