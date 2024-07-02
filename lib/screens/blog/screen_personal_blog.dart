import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/blog/model_blog.dart';
import 'package:pethome_mobileapp/model/user/model_user_infor.dart';
import 'package:pethome_mobileapp/screens/blog/screen_add_blog.dart';
import 'package:pethome_mobileapp/services/api/blog_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/blog/personal_blog_card.dart';

class PersonalBlogScreen extends StatefulWidget {
  const PersonalBlogScreen({super.key, required this.userInfor});

  final UserInfor userInfor;

  @override
  State<PersonalBlogScreen> createState() => _PersonalBlogScreenState();
}

class _PersonalBlogScreenState extends State<PersonalBlogScreen> {
  List<Blog> blogs = List.empty(growable: true);

  final ScrollController _scrollController = ScrollController();

  int currentPage = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listenerScroll);
    getUserBlogs();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _listenerScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      getUserBlogs();
    }
  }

  Future<void> getUserBlogs() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<Blog> newBlogs =
        await BlogApi().getListUserBlog(10, currentPage * 10);

    if (newBlogs.isEmpty) {
      setState(() {
        loading = false;
      });
      return;
    }

    if (mounted) {
      setState(() {
        blogs.addAll(newBlogs);
        currentPage++;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Color.fromARGB(232, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Trang cá nhân",
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.post_add, color: iconButtonColor, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBlogScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 160.0,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Image.asset(
                        'lib/assets/pictures/bg_personal_blog.png',
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        left: 24.0,
                        bottom: 40.0,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100.0,
                              height: 100.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60.0),
                                  child: Image.network(
                                    widget.userInfor.avatar,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Image.asset(
                                        'lib/assets/pictures/placeholder_image.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 30.0),
                            Image.asset('lib/assets/pictures/logo_app.png',
                                width: 50, height: 50),
                            const SizedBox(width: 10.0),
                            Image.asset('lib/assets/pictures/name_app.png',
                                width: 100, height: 100),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 30.0,
                        bottom: 10.0,
                        child: Text(
                          widget.userInfor.name,
                          style: const TextStyle(
                            color: buttonBackgroundColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              buttonBackgroundColor),
                        ),
                      )
                    : blogs.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'lib/assets/pictures/icon_order.png'),
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Bạn chưa có bài viết nào',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: buttonBackgroundColor,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Hãy trở về trang chủ để thêm bài viết mới nhé!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: buttonBackgroundColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: blogs.length,
                            itemBuilder: (context, index) {
                              return PersonalBlogCard(blog: blogs[index]);
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
