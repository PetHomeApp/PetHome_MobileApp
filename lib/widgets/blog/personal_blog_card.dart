import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/blog/model_blog.dart';
import 'package:pethome_mobileapp/services/api/blog_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:readmore/readmore.dart';

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

  int favoriteCount = 0;

  @override
  void initState() {
    super.initState();
    getFavoriveInfor();
  }

  Future<void> getFavoriveInfor() async {
    if (loading) {
      return;
    }

    loading = true;
    int numberLike = await BlogApi().getNumberLike(widget.blog.blogId);
    bool isLiked = await BlogApi().checkLike(widget.blog.blogId);

    setState(() {
      favoriteCount = numberLike;
      isFavorite = isLiked;
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
                                  widget.blog.avatarAuthor,
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
                                widget.blog.nameAuthor,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(
                                    DateTime.parse(widget.blog.createAt)),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const Text(
                                "Công khai",
                                style: TextStyle(
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
                              // Handle edit action
                            } else if (value == 'delete') {
                              // Handle delete action
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
                    widget.blog.description,
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
                widget.blog.images.length == 1
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
                                      widget.blog.images[0],
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
                              widget.blog.images[0],
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
                    : widget.blog.images.length == 2
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
                                                widget.blog.images[0],
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
                                        widget.blog.images[0],
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
                                                widget.blog.images[1],
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
                                        widget.blog.images[1],
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
                        : widget.blog.images.length == 3
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
                                                      widget.blog.images[0],
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Image.network(
                                          widget.blog.images[0],
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
                                                            widget
                                                                .blog.images[1],
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Image.network(
                                                widget.blog.images[1],
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
                                                            widget
                                                                .blog.images[2],
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Image.network(
                                                widget.blog.images[2],
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
                                  itemCount: widget.blog.images.length,
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
                                                        widget
                                                            .blog.images[index],
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Image.network(
                                            widget.blog.images[index],
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
                                  await BlogApi().postLike(widget.blog.blogId);
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
