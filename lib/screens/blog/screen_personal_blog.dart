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
                  height: 200.0,
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
                        bottom: 60.0,
                        child: Row(
                          children: [
                            SizedBox(
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
                                    'https://via.placeholder',
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
                            const SizedBox(width: 16.0),
                            Image.asset('lib/assets/pictures/logo_app.png',
                                width: 100, height: 100),
                            Image.asset('lib/assets/pictures/name_app.png',
                                width: 120, height: 120),
                          ],
                        ),
                      ),
                      const Positioned(
                        left: 30.0,
                        bottom: 20.0,
                        child: Text(
                          'Lê Xuân Huy',
                          style: TextStyle(
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
