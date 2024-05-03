import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pethome_mobileapp/model/blog/model_blog.dart';
import 'package:pethome_mobileapp/screens/blog/screen_personal_blog.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/blog/blog_card.dart';

class BlogHomeScreen extends StatefulWidget {
  final Function(bool) updateBottomBarVisibility;

  const BlogHomeScreen({super.key, required this.updateBottomBarVisibility});

  @override
  // ignore: library_private_types_in_public_api
  _BlogHomeScreenState createState() => _BlogHomeScreenState();
}

class _BlogHomeScreenState extends State<BlogHomeScreen> {
  List<Blog> blogs = [
    Blog(
      blogId: '1',
      description:
          'Nội dung bài viết 1. Đây là nội dung bài viết 1. Hình ảnh một chú chó xinh đẹp. Đây là nội dung bài viết 1. Hình ảnh một chú chó xinh đẹp. Đây là nội dung bài viết 1. Hình ảnh một chú chó xinh đẹp.',
      imageUrl: 'https://via.placeholder.com/150',
      createAt: '2021-09-01',
      isFavorite: false,
      favoriteCount: 0,
      nameAuthor: 'Người đăng 1',
      avatarAuthor: 'https://via.placeholder.com/150',
    ),
    Blog(
      blogId: '1',
      description: 'Nội dung bài viết 1',
      imageUrl: 'https://via.placeholder.com/150',
      createAt: '2021-09-01',
      isFavorite: false,
      favoriteCount: 0,
      nameAuthor: 'Người đăng 1',
      avatarAuthor: 'https://via.placeholder.com/150',
    ),
    Blog(
      blogId: '1',
      description: 'Nội dung bài viết 1',
      imageUrl: 'https://via.placeholder.com/150',
      createAt: '2021-09-01',
      isFavorite: false,
      favoriteCount: 0,
      nameAuthor: 'Người đăng 1',
      avatarAuthor: 'https://via.placeholder.com/150',
    ),
  ];

  final ScrollController _scrollController = ScrollController();
  bool _isBottomBarVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isBottomBarVisible) {
        setState(() {
          _isBottomBarVisible = false;
          widget.updateBottomBarVisibility(false);
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isBottomBarVisible) {
        setState(() {
          _isBottomBarVisible = true;
          widget.updateBottomBarVisibility(true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kết nối cộng đồng PetHome",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gradientStartColor, gradientMidColor, gradientEndColor],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue, 
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.person),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const PersonalBlogScreen(),
                              ));
                            },
                          ),
                        ),
                        const SizedBox(width: 30),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                            ),
                            child: const Text(
                              'Bạn đang nghĩ gì?',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: blogs.length,
                  itemBuilder: (context, index) {
                    return BlogCard(blog: blogs[index]);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
