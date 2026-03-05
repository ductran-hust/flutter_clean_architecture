import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/app_colors.dart';

@RoutePage()
class LyricsPage extends StatelessWidget {
  final VoidCallback? onBack;

  const LyricsPage({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final lyrics = [
      ('( Verse 1 )', true),
      ('Sleepin\', You\'re On Your Tippy Toes', false),
      ('Creepin\' Around Like No One Knows', false),
      ('Think You\'re So Criminal', false),
      ('Bruises On Both My Knees For You', false),
      ('Don\'t Say Thank You Or Please', false),
      ('I Do What I Want When I\'m Wanting To', false),
      ('My Soul? So Cynical', false), // highlighted
      ('( Verse 2)', true),
      ('Sleepin\', You\'re On Your Tippy Toes', false),
      ('Creepin\' Around Like No One Knows', false),
      ('Think You\'re So Criminal', false),
      ('Bruises On Both My Knees For You', false),
    ];
    final highlightedIndex = 7; // "My Soul? So Cynical"

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dark green background with face
          Container(color: const Color(0xFF0A1F10)),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                colors: [Colors.green.withOpacity(0.3), Colors.transparent],
                radius: 0.7,
              ),
            ),
          ),
          // Face overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black45, Colors.transparent, Colors.black45],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: onBack ?? () => Navigator.maybePop(context),
                        child: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                      ),
                      const Expanded(
                        child: Text(
                          'Bad Guy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(Icons.more_vert, color: Colors.white),
                    ],
                  ),
                ),

                // Lyrics
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: lyrics.length,
                    itemBuilder: (context, i) {
                      final isSection = lyrics[i].$2;
                      final isHighlighted = i == highlightedIndex;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            if (isHighlighted)
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(right: 12, top: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  shape: BoxShape.circle,
                                ),
                              )
                            else
                              const SizedBox(width: 20),
                            Text(
                              lyrics[i].$1,
                              style: TextStyle(
                                color: isHighlighted
                                    ? Colors.white
                                    : isSection
                                    ? Colors.white70
                                    : Colors.white38,
                                fontSize: isHighlighted
                                    ? 18
                                    : isSection
                                    ? 15
                                    : 16,
                                fontWeight: isHighlighted || isSection
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Mini player
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A3020),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person, color: Colors.green[300], size: 28),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bad Guy',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  'Billie Eilish',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.favorite_border, color: Colors.grey[400]),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Progress
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                          activeTrackColor: Colors.black87,
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: Colors.grey[700],
                        ),
                        child: Slider(value: 0.6, onChanged: (_) {}),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('2:25', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text('4:02', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.repeat, color: Colors.grey[400], size: 22),
                          Icon(Icons.skip_previous, color: Colors.black87, size: 30),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.pause, color: Colors.white, size: 26),
                          ),
                          Icon(Icons.skip_next, color: Colors.black87, size: 30),
                          Icon(Icons.shuffle, color: Colors.grey[400], size: 22),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
