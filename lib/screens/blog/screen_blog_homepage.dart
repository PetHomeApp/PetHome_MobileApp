import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pethome_mobileapp/model/blog/model_blog.dart';
import 'package:pethome_mobileapp/model/user/model_user_infor.dart';
import 'package:pethome_mobileapp/screens/blog/screen_personal_blog.dart';
import 'package:pethome_mobileapp/services/api/blog_api.dart';
import 'package:pethome_mobileapp/services/api/user_api.dart';
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
  List<Blog> blogs = List.empty(growable: true);

  final ScrollController _scrollController = ScrollController();
  bool _isBottomBarVisible = true;

  int currentPage = 0;
  bool firstLoad = false;
  bool loading = false;

  late UserInfor userInfor;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scrollController.addListener(_listenerScroll);
    getUserInforAndBlogs();
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

  void _listenerScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        getBlogs();
      }
    }
  }

  Future<void> getUserInforAndBlogs() async {
    if (firstLoad) {
      return;
    }

    firstLoad = true;
    final dataResponse = await UserApi().getUser();
    final List<Blog> newBlogs =
        await BlogApi().getListBlog(10, currentPage * 10);

    if (newBlogs.isEmpty) {
      firstLoad = false;
      return;
    }

    if (mounted) {
      setState(() {
        userInfor = dataResponse['userInfor'];
        blogs.addAll(newBlogs);
        currentPage++;
        firstLoad = false;
      });
    }
  }

  Future<void> getBlogs() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<Blog> blogs = await BlogApi().getListBlog(10, currentPage * 10);

    if (blogs.isEmpty) {
      loading = false;
      return;
    }

    if (mounted) {
      setState(() {
        blogs.addAll(blogs);
        currentPage++;
        loading = false;
      });
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
      body: firstLoad
          ? const Center(
              child: CircularProgressIndicator(
                color: appColor,
              ),
            )
          : CustomScrollView(
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PersonalBlogScreen(),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60.0),
                                      child: Image.network(
                                        userInfor.avatar,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return Image.asset(
                                              'lib/assets/pictures/placeholder_image.png',
                                              fit: BoxFit.cover);
                                        },
                                      ),
                                    ),
                                  ),
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
