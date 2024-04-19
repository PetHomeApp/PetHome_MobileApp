import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/blog/model_blog.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:readmore/readmore.dart';

// ignore: must_be_immutable
class BlogCard extends StatefulWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  // ignore: library_private_types_in_public_api
  _BlogCardState createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  bool isFavorite = false;
  int favoriteCount = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.blog.avatarAuthor),
                  radius: 25.0, 
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
                    const SizedBox(height: 4.0), 
                    Text(
                      widget.blog.createAt,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ReadMoreText(
              widget.blog.description,
              trimLength: 80,
              trimCollapsedText: "Xem thêm",
              trimExpandedText: "Rút gọn",
              delimiter: "...",
              moreStyle: const TextStyle(
                color: buttonBackgroundColor,
                fontWeight: FontWeight.bold,
              ),
              lessStyle: const TextStyle(
                color: buttonBackgroundColor,
                fontWeight: FontWeight.bold,
              ),
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              widget.blog.imageUrl,
              width: 200, 
              height: 300, 
              fit: BoxFit.cover,
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
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black, 
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                          if (isFavorite) {
                            favoriteCount++;
                          } else {
                            favoriteCount--;
                          }
                        });
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
            
              
                

