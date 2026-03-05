import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/app_colors.dart';
import 'package:flutter_clean_architecture/features/bottom_nav.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onArtist, this.onMusic, this.onProfile});
  final VoidCallback? onArtist;
  final VoidCallback? onMusic;
  final VoidCallback? onProfile;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;
  int _tabIndex = 0;
  final _tabs = ['News', 'Video', 'Artists', 'Podcasts'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 26, color: Colors.black54),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                          child: const Icon(Icons.music_note, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Spotify®',
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.more_vert, size: 26, color: Colors.black54),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),

            // Featured banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: widget.onArtist,
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -10,
                          bottom: 0,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white10,
                            ),
                            child: Icon(Icons.person, size: 110, color: Colors.white30),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New Album',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Happier Than\nEver',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Billie Eilish',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 20)),

            // Tab bar
            SliverToBoxAdapter(
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _tabs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 24),
                  itemBuilder: (context, i) {
                    final isSelected = i == _tabIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _tabIndex = i),
                      child: Column(
                        children: [
                          Text(
                            _tabs[i],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.black : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (isSelected)
                            Container(
                              width: 24,
                              height: 3,
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),

            // Horizontal music cards
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, i) {
                    final items = [
                      ('Bad Guy', 'Billie Eilish'),
                      ('Scorpion', 'Drake'),
                      ('WHEN...', 'Billie Eilish'),
                    ];
                    return GestureDetector(
                      onTap: widget.onMusic,
                      child: _MusicCard(title: items[i].$1, artist: items[i].$2, isDark: i == 0),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 24)),

            // Playlist section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'Playlist',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Text('See More', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                final songs = [
                  ('As It Was', 'Harry Styles', '5:33'),
                  ('God Did', 'DJ Khaled', '3:43'),
                  ('Lift Me Up', 'Rihanna', '3:59'),
                ];
                return _SongListTile(
                  title: songs[i].$1,
                  artist: songs[i].$2,
                  duration: songs[i].$3,
                  onTap: widget.onMusic,
                );
              }, childCount: 3),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      bottomNavigationBar: SpotifyBottomNav(
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
          if (i == 3) widget.onProfile?.call();
        },
      ),
    );
  }
}

class _MusicCard extends StatelessWidget {
  const _MusicCard({required this.title, required this.artist, this.isDark = false});
  final String title;
  final String artist;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.person,
              size: 80,
              color: isDark ? Colors.green.withOpacity(0.5) : Colors.grey[400],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, isDark ? Colors.black54 : Colors.white54],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          artist,
                          style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow, size: 18, color: Colors.black54),
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

class _SongListTile extends StatelessWidget {
  const _SongListTile({
    required this.title,
    required this.artist,
    required this.duration,
    this.onTap,
  });
  final String title;
  final String artist;
  final String duration;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow, color: Colors.black54),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(artist, style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),
            Text(duration, style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
            const SizedBox(width: 16),
            Icon(Icons.favorite_border, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}
