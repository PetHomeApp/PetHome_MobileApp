import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/blog/model_blog.dart';
import 'package:pethome_mobileapp/services/api/blog_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UpdateBlogScreen extends StatefulWidget {
  final Blog blog;
  const UpdateBlogScreen({super.key, required this.blog});

  @override
  State<UpdateBlogScreen> createState() => _UpdateBlogScreenState();
}

enum Privacy { private, public }

class _UpdateBlogScreenState extends State<UpdateBlogScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final int maxLength = 500;

  Privacy privacy = Privacy.private;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.blog.description;
    privacy =
        widget.blog.status == 'private' ? Privacy.private : Privacy.public;
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
          "Chỉnh sửa bài đăng",
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
            icon: const Icon(Icons.save, color: iconButtonColor, size: 30),
            onPressed: () async {
              if (_descriptionController.text.isEmpty) {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: 'Vui lòng điền mô tả bài viết!',
                  ),
                  displayDuration: const Duration(seconds: 0),
                );
                return;
              }

              var result = await BlogApi().updateBlog(
                widget.blog.blogId,
                _descriptionController.text,
                privacy == Privacy.private ? 'private' : 'public',
              );

              if (result['isSuccess'] == true) {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.success(
                    message: 'Đăng bài viết thành công!',
                  ),
                  displayDuration: const Duration(seconds: 0),
                );
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              } else {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: 'Đăng bài viết thất bại! Vui lòng thử lại!',
                  ),
                  displayDuration: const Duration(seconds: 0),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
          child: Column(children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Chế độ bài đăng: (*)',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Radio<Privacy>(
                  value: Privacy.private,
                  activeColor: buttonBackgroundColor,
                  groupValue: privacy,
                  onChanged: (Privacy? value) {
                    setState(() {
                      privacy = value!;
                    });
                  },
                ),
                const Text('Chỉ mình tôi'),
                const SizedBox(width: 20.0),
                Radio<Privacy>(
                  value: Privacy.public,
                  activeColor: buttonBackgroundColor,
                  groupValue: privacy,
                  onChanged: (Privacy? value) {
                    setState(() {
                      privacy = value!;
                    });
                  },
                ),
                const Text('Công khai'),
              ],
            ),
            const SizedBox(height: 20.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mô tả bài viết: (*)',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _descriptionController,
              cursorColor: buttonBackgroundColor,
              maxLines: 6,
              maxLength: maxLength,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 0.75,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 0.75,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: buttonBackgroundColor,
                    width: 1.0,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 12.0),
              ),
            ),
            const SizedBox(height: 20.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Danh sách ảnh được chọn: (*)',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8.0),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: widget.blog.images.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
                  widget.blog.images[index],
                  fit: BoxFit.cover,
                );
              },
            ),
            const SizedBox(height: 10.0),
            const SizedBox(
              height: 20.0,
            ),
          ]),
        ),
      ),
    );
  }
}
