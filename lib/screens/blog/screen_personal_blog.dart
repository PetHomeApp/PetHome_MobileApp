import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/blog/model_blog.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/blog/personal_blog_card.dart';

class PersonalBlogScreen extends StatefulWidget {
  const PersonalBlogScreen({super.key});

  @override
  State<PersonalBlogScreen> createState() => _PersonalBlogScreenState();
}

class _PersonalBlogScreenState extends State<PersonalBlogScreen> {
  final ScrollController _scrollController = ScrollController();
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
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 250.0,
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
                        left: 32.0,
                        bottom: 60.0,
                        child: SizedBox(
                          width: 120.0,
                          height: 120.0,
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
                                'https://via.placeholder.com/150',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 32.0,
                        bottom: 20.0,
                        child: Text(
                              'Nguyễn Văn Aaaaa',
                              style: TextStyle(
                                color: buttonBackgroundColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                      ),
                      ),],
                  ),
                ),
        
                const SizedBox(height: 8.0),
                ListView.builder(
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
