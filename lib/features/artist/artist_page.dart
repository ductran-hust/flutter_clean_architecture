import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/app_colors.dart';
import 'package:flutter_clean_architecture/features/bottom_nav.dart';

@RoutePage()
class ArtistPage extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onPlayMusic;

  const ArtistPage({super.key, this.onBack, this.onPlayMusic});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  int _navIndex = 2; // favorites tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Artist hero image
          SliverAppBar(
            expandedHeight: 300,
            pinned: false,
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              onTap: widget.onBack ?? () => Navigator.maybePop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.transparent),
                child: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  color: Colors.grey[300],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: Container(
                        color: const Color(0xFF2A2A2A),
                        child: Center(
                          child: Icon(Icons.person, size: 160, color: Colors.grey[700]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Artist info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Billie Eilish',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      '2 Album , 67 Track',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Lorem Ipsum Dolor Sit Amet, Consectetur\nAdipiscing Elit. Turpis Adipiscing Vestibulum Orci\nEnim, Nascetur Vitae',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 13, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Albums section
                  const Text('Albums', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),

          // Albums horizontal list
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: const [
                  _AlbumCard(name: 'Lilbubblegum', isDark: true),
                  SizedBox(width: 16),
                  _AlbumCard(name: 'Happier Than Ever', isDark: false),
                  SizedBox(width: 16),
                  _AlbumCard(name: 'Dont Smile', isPartial: true),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),

          // Songs section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text('Songs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('See More', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              final songs = [
                ('Dont Smile At Me', 'Billie Eilish', '5:33'),
                ('Lilbubblegum', 'billie eilish', '5:33'),
              ];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: GestureDetector(
                  onTap: widget.onPlayMusic,
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                        child: const Icon(Icons.play_arrow, color: Colors.black54),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(songs[i].$1, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              songs[i].$2,
                              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Text(songs[i].$3, style: TextStyle(color: AppColors.textGrey)),
                      const SizedBox(width: 16),
                      Icon(Icons.favorite_border, color: Colors.grey[400], size: 20),
                    ],
                  ),
                ),
              );
            }, childCount: 2),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          // Green indicator
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      bottomNavigationBar: SpotifyBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

class _AlbumCard extends StatelessWidget {
  final String name;
  final bool isDark;
  final bool isPartial;

  const _AlbumCard({required this.name, this.isDark = false, this.isPartial = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: isDark ? Colors.black : const Color(0xFFD4B896),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Icon(Icons.person, size: 80, color: isDark ? Colors.white30 : Colors.brown[200]),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }
}
