import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/blog/model_blog.dart';
import 'package:pethome_mobileapp/screens/blog/screen_update_blog.dart';
import 'package:pethome_mobileapp/services/api/blog_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:readmore/readmore.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// ignore: must_be_immutable
class PersonalBlogCard extends StatefulWidget {
  final Blog blog;
  const PersonalBlogCard({super.key, required this.blog});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalBlogCardState createState() => _PersonalBlogCardState();
}

class _PersonalBlogCardState extends State<PersonalBlogCard> {
  bool loading = false;
  bool isFavorite = false;
  late Blog myBlog;

  int favoriteCount = 0;

  @override
  void initState() {
    super.initState();
    myBlog = widget.blog;
    getFavoriveInfor();
  }

  Future<void> getFavoriveInfor() async {
    if (loading) {
      return;
    }

    loading = true;
    int numberLike = await BlogApi().getNumberLike(myBlog.blogId);
    bool isLiked = await BlogApi().checkLike(myBlog.blogId);

    setState(() {
      favoriteCount = numberLike;
      isFavorite = isLiked;
      loading = false;
    });
  }

  Future<void> resetBlog() async {
    if (loading) {
      return;
    }

    setState(() {
      loading = true;
    });
    myBlog = await BlogApi().getDetailBlog(myBlog.blogId);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const SizedBox(
            height: 300,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(
                color: buttonBackgroundColor,
              ),
            ),
          )
        : Container(
            color: Colors.grey[100],
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60.0),
                                child: Image.network(
                                  myBlog.avatarAuthor,
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
                          const SizedBox(width: 12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                myBlog.nameAuthor,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(
                                    DateTime.parse(myBlog.createAt)
                                        .add(const Duration(hours: 7))),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                myBlog.status == 'public'
                                    ? 'Công khai'
                                    : 'Chỉ mình tôi',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: buttonBackgroundColor,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_horiz),
                          onSelected: (value) {
                            if (value == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateBlogScreen(blog: myBlog),
                                ),
                              ).then((value) {
                                resetBlog();
                              });
                            } else if (value == 'delete') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Xác nhận'),
                                    content: const Text(
                                        'Bạn có chắc chắn muốn xóa bài viết này không?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Hủy',
                                            style: TextStyle(
                                                color: buttonBackgroundColor)),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          var callDeleteApi = await BlogApi()
                                              .deleteBlog(myBlog.blogId);
                                          if (callDeleteApi['isSuccess']) {
                                            showTopSnackBar(
                                              // ignore: use_build_context_synchronously
                                              Overlay.of(context),
                                              const CustomSnackBar.error(
                                                message:
                                                    'Xóa bài viết thành công!',
                                              ),
                                              displayDuration:
                                                  const Duration(seconds: 0),
                                            );
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          } else {
                                            showDialog(
                                              // ignore: use_build_context_synchronously
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Lỗi'),
                                                  content: Text(
                                                      callDeleteApi['message']),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: const Text('Xác nhận',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Sửa bài viết'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Xóa bài viết'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 8.0, bottom: 10.0),
                  child: ReadMoreText(
                    myBlog.description,
                    trimLength: 80,
                    trimCollapsedText: "Xem thêm",
                    trimExpandedText: "Rút gọn",
                    delimiter: "...",
                    moreStyle: const TextStyle(
                      color: buttonBackgroundColor,
                    ),
                    lessStyle: const TextStyle(
                      color: buttonBackgroundColor,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).hintColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                myBlog.images.length == 1
                    ? GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                insetPadding: EdgeInsets.zero,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image.network(
                                      myBlog.images[0],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          height: 300.0,
                          child: ClipRRect(
                            child: Image.network(
                              myBlog.images[0],
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                    'lib/assets/pictures/placeholder_image.png',
                                    fit: BoxFit.cover);
                              },
                            ),
                          ),
                        ),
                      )
                    : myBlog.images.length == 2
                        ? Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          insetPadding: EdgeInsets.zero,
                                          child: GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: Image.network(
                                                myBlog.images[0],
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 300.0,
                                    child: ClipRRect(
                                      child: Image.network(
                                        myBlog.images[0],
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
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          insetPadding: EdgeInsets.zero,
                                          child: GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: Image.network(
                                                myBlog.images[1],
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 300.0,
                                    child: ClipRRect(
                                      child: Image.network(
                                        myBlog.images[1],
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
                            ],
                          )
                        : myBlog.images.length == 3
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                                insetPadding: EdgeInsets.zero,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    child: Image.network(
                                                      myBlog.images[0],
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Image.network(
                                          myBlog.images[0],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                            'lib/assets/pictures/placeholder_image.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      elevation: 0,
                                                      insetPadding:
                                                          EdgeInsets.zero,
                                                      child: GestureDetector(
                                                        onTap: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          child: Image.network(
                                                            myBlog.images[1],
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Image.network(
                                                myBlog.images[1],
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Image.asset(
                                                  'lib/assets/pictures/placeholder_image.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      elevation: 0,
                                                      insetPadding:
                                                          EdgeInsets.zero,
                                                      child: GestureDetector(
                                                        onTap: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          child: Image.network(
                                                            myBlog.images[2],
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Image.network(
                                                myBlog.images[2],
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Image.asset(
                                                  'lib/assets/pictures/placeholder_image.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 300.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: myBlog.images.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: ClipRRect(
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  elevation: 0,
                                                  insetPadding: EdgeInsets.zero,
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        Navigator.pop(context),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      child: Image.network(
                                                        myBlog.images[index],
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Image.network(
                                            myBlog.images[index],
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Image.asset(
                                              'lib/assets/pictures/placeholder_image.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black,
                            ),
                            onPressed: () async {
                              bool callLikeApi =
                                  await BlogApi().postLike(myBlog.blogId);
                              if (callLikeApi) {
                                setState(() {
                                  isFavorite = !isFavorite;
                                  if (isFavorite) {
                                    favoriteCount++;
                                  } else {
                                    favoriteCount--;
                                  }
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            favoriteCount.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
