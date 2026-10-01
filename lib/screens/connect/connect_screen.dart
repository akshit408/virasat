import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../features/chat/models/chat_message_model.dart';
import '../../widgets/shopping_bag_icon_button.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Set<String> _followedArtisans = {};
  final Set<String> _bookmarkedNgos = {};
  final Map<String, int> _communityLikes = {'post_1': 42, 'post_2': 89, 'post_3': 124};
  final Set<String> _likedPosts = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'VIRASAT Connect',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.primary,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: const [
          ShoppingBagIconButton(),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.people_alt_outlined, size: 20), text: 'Artisans'),
            Tab(icon: Icon(Icons.event_seat_outlined, size: 20), text: 'Workshops'),
            Tab(icon: Icon(Icons.account_balance_outlined, size: 20), text: 'NGOs'),
            Tab(icon: Icon(Icons.forum_outlined, size: 20), text: 'Community'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildArtisansTab(),
          _buildWorkshopsTab(),
          _buildNgosTab(),
          _buildCommunityTab(),
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 1: ARTISANS
  // =========================================================================
  Widget _buildArtisansTab() {
    final artisans = [
      {
        'id': 'art_1',
        'name': 'Ramji Vankar',
        'craft': 'Patola & Bandhani Weaving',
        'location': 'Patan, Gujarat',
        'experience': '32 Years Exp.',
        'rating': 4.9,
        'followers': 1240,
        'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80',
        'isGiVerified': true,
      },
      {
        'id': 'art_2',
        'name': 'Savitaben Rabari',
        'craft': 'Mirror Work Embroidery',
        'location': 'Kutch, Gujarat',
        'experience': '25 Years Exp.',
        'rating': 4.8,
        'followers': 980,
        'image': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80',
        'isGiVerified': true,
      },
      {
        'id': 'art_3',
        'name': 'Mohd. Yaseen Khatri',
        'craft': 'Ajrakh Natural Block Printing',
        'location': 'Dhamadka, Gujarat',
        'experience': '40 Years Exp.',
        'rating': 5.0,
        'followers': 2100,
        'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
        'isGiVerified': true,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: artisans.length,
      itemBuilder: (context, index) {
        final art = artisans[index];
        final isFollowing = _followedArtisans.contains(art['id']);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    (art['name'] as String)[0],
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            art['name'] as String,
                            style: const TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (art['isGiVerified'] == true) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified_rounded, color: AppColors.secondary, size: 18),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        art['craft'] as String,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${art['location']} • ${art['experience']}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                if (isFollowing) {
                                  _followedArtisans.remove(art['id']);
                                } else {
                                  _followedArtisans.add(art['id'] as String);
                                }
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: isFollowing ? Colors.grey : AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            ),
                            child: Text(
                              isFollowing ? 'Following' : '+ Follow',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isFollowing ? Colors.grey.shade700 : AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.push(
                                '/artisan-chat',
                                extra: ArtisanChatArgs(
                                  artisanId: art['id'] as String,
                                  name: art['name'] as String,
                                  avatar: art['image'] as String,
                                  craft: art['craft'] as String,
                                  location: art['location'] as String,
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                            label: const Text('Chat', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // TAB 2: WORKSHOPS
  // =========================================================================
  Widget _buildWorkshopsTab() {
    final workshops = [
      {
        'id': 'ws_1',
        'title': 'Masterclass: Natural Indigo Dyeing & Block Printing',
        'instructor': 'Mohd. Yaseen Khatri',
        'isLiveNow': true,
        'mode': 'Online Live Interactive',
        'duration': '2 Hours',
        'seatsLeft': 4,
        'language': 'Hindi & English',
        'date': 'Today, 4:00 PM IST',
        'hasCertificate': true,
      },
      {
        'id': 'ws_2',
        'title': 'Kutch Mirror Embroidery Hands-on Workshop',
        'instructor': 'Savitaben Rabari',
        'isLiveNow': false,
        'mode': 'Hybrid / Offline',
        'duration': '3 Hours',
        'seatsLeft': 12,
        'language': 'Gujarati & Hindi',
        'date': 'Tomorrow, 11:00 AM IST',
        'hasCertificate': true,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workshops.length,
      itemBuilder: (context, index) {
        final ws = workshops[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (ws['isLiveNow'] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.fiber_manual_record, color: Colors.white, size: 10),
                            SizedBox(width: 4),
                            Text('LIVE NOW', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ws['mode'] as String,
                          style: const TextStyle(color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 14),
                          SizedBox(width: 4),
                          Text('Digital Certificate Included', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  ws['title'] as String,
                  style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('By Master Artisan ${ws['instructor']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text('${ws['date']} (${ws['duration']})', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    const Icon(Icons.event_seat_rounded, size: 14, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Text('${ws['seatsLeft']} seats left!', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_month_outlined, color: AppColors.primary),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Workshop reminder added to calendar!'),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      tooltip: 'Add Calendar Reminder',
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Workshop Registration 🎉'),
                              content: Text('Confirm enrollment for "${ws['title']}"? Free for registered Virasat patrons.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Enrolled successfully! Meeting link & pass sent to your email.'),
                                        backgroundColor: AppColors.primary,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                  child: const Text('Confirm Join'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Register & Reserve Seat', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // TAB 3: NGOS & GOVERNMENT SCHEMES
  // =========================================================================
  Widget _buildNgosTab() {
    final ngos = [
      {
        'id': 'ngo_1',
        'name': 'Khamir Craft Resource Centre',
        'type': 'Verified NGO Partner',
        'focus': 'Kutch Artisan Cluster Training & Revival',
        'grantAmount': 'Up to ₹ 5,000,000 Support Fund',
        'location': 'Kukma, Kutch',
        'verified': true,
      },
      {
        'id': 'ngo_2',
        'name': 'PM Vishwakarma Kaushal Samman Scheme',
        'type': 'Government Scheme',
        'focus': 'Stipend ₹500/day + ₹15,000 Toolkit Incentive',
        'grantAmount': 'Collateral-free Credit up to ₹3 Lakh',
        'location': 'Ministry of MSME, Govt. of India',
        'verified': true,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ngos.length,
      itemBuilder: (context, index) {
        final ngo = ngos[index];
        final isBookmarked = _bookmarkedNgos.contains(ngo['id']);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Text(
                        ngo['type'] as String,
                        style: TextStyle(color: Colors.green.shade800, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: isBookmarked ? AppColors.primary : AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isBookmarked) {
                            _bookmarkedNgos.remove(ngo['id']);
                          } else {
                            _bookmarkedNgos.add(ngo['id'] as String);
                          }
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  ngo['name'] as String,
                  style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(ngo['focus'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.terracottaLight.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars_rounded, color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(ngo['grantAmount'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Application form opened. Please fill your Artisan ID & Aadhar verification.'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Apply for Support / Scheme', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // TAB 4: COMMUNITY DISCUSSION FEED
  // =========================================================================
  Widget _buildCommunityTab() {
    final posts = [
      {
        'id': 'post_1',
        'author': 'Ananya Sharma',
        'role': 'Patron / Collector',
        'time': '2 hours ago',
        'title': 'How to test authentic Patola silk vs machine print?',
        'content': 'I received a Patola Saree and noticed the vibrant geometric double ikat pattern on both sides. Is double ikat weaving visible on both sides equally?',
        'replies': 8,
      },
      {
        'id': 'post_2',
        'author': 'Ramji Vankar',
        'role': 'Master Weaver (Patan)',
        'time': '5 hours ago',
        'title': 'Craft Tip: Preserving Natural Dyes in Humid Monsoon',
        'content': 'Always air-dry natural vegetable dyed fabrics in shaded, ventilated rooms. Never expose direct noon sunlight immediately after wet washing.',
        'replies': 19,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final postId = post['id'] as String;
        final likes = _communityLikes[postId] ?? 10;
        final isLiked = _likedPosts.contains(postId);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text((post['author'] as String)[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['author'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('${post['role']} • ${post['time']}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  post['title'] as String,
                  style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(post['content'] as String, style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textSecondary)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isLiked ? Colors.redAccent : AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isLiked) {
                            _likedPosts.remove(postId);
                            _communityLikes[postId] = likes - 1;
                          } else {
                            _likedPosts.add(postId);
                            _communityLikes[postId] = likes + 1;
                          }
                        });
                      },
                    ),
                    Text('$likes', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    const Icon(Icons.mode_comment_outlined, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('${post['replies']} Comments', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, size: 18, color: AppColors.textSecondary),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Discussion post link copied!'), backgroundColor: AppColors.primary),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
