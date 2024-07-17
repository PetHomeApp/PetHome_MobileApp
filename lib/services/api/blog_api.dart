import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pethome_mobileapp/model/blog/model_blog.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogApi {
  Future<List<Blog>> getListBlog(int limit, int start) async {
    var url = Uri.parse('${pethomeApiUrl}blogs?limit=$limit&start=$start');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<Blog> blogs = [];
      var data = json.decode(response.body);

      if (data == null) {
        return blogs;
      }

      if (data['data'] == null) {
        return blogs;
      }

      for (var item in data['data']) {
        blogs.add(Blog.fromJson(item));
      }

      return blogs;
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  Future<List<Blog>> getListUserBlog(int limit, int start) async {
    var url =
        Uri.parse('${pethomeApiUrl}api/user/blogs?limit=$limit&start=$start');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return [];
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    );

    if (response.statusCode == 200) {
      List<Blog> blogs = [];
      var data = json.decode(response.body);

      if (data == null) {
        return blogs;
      }

      if (data['data'] == null) {
        return blogs;
      }

      for (var item in data['data']) {
        blogs.add(Blog.fromJson(item));
      }

      return blogs;
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  Future<int> getNumberLike(String idBlog) async {
    var url = Uri.parse('${pethomeApiUrl}blogs/$idBlog');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['total_like'];
    } else {
      throw Exception('Failed to load numlike blog');
    }
  }

  Future<bool> checkLike(String idBlog) async {
    var url = Uri.parse('${pethomeApiUrl}api/blogs/$idBlog/like');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return false;
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['liked'];
    } else {
      throw Exception('Failed to load check like blog');
    }
  }

  Future<bool> postLike(String idBlog) async {
    var url = Uri.parse('${pethomeApiUrl}api/blogs/$idBlog/like');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return false;
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load check like blog');
    }
  }

  Future<Map<String, dynamic>> postBlog(
      String description, List<XFile> images, String status) async {
    var url = Uri.parse('${pethomeApiUrl}api/blogs');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'description': description,
      'status': status,
    });

    for (var image in images) {
      formData.files.add(MapEntry(
        'images',
        await MultipartFile.fromFile(image.path),
      ));
    }

    try {
      final response = await dio.post(
        url.toString(),
        data: formData,
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {'isSuccess': false, 'message': response.data};
      }
    } catch (e) {
      // ignore: deprecated_member_use
      if (e is DioError) {
        return {'isSuccess': false, 'message': e.response?.data};
      } else {
        return {'isSuccess': false, 'message': e.toString()};
      }
    }
  }

  Future<Map<String, dynamic>> updateBlog(
      String blogId, String description, String status) async {
    var url = Uri.parse('${pethomeApiUrl}api/user/blogs/$blogId');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'description': description,
      'status': status,
    });

    try {
      final response = await dio.put(
        url.toString(),
        data: formData,
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {'isSuccess': false, 'message': response.data};
      }
    } catch (e) {
      // ignore: deprecated_member_use
      if (e is DioError) {
        return {'isSuccess': false, 'message': e.response?.data};
      } else {
        return {'isSuccess': false, 'message': e.toString()};
      }
    }
  }

  Future<Map<String, dynamic>> deleteBlog(String blogId) async {
    var url = Uri.parse('${pethomeApiUrl}api/user/blogs/$blogId');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    try {
      final response = await dio.delete(
        url.toString(),
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {'isSuccess': false, 'message': response.data};
      }
    } catch (e) {
      // ignore: deprecated_member_use
      if (e is DioError) {
        return {'isSuccess': false, 'message': e.response?.data};
      } else {
        return {'isSuccess': false, 'message': e.toString()};
      }
    }
  }

  Future<Blog> getDetailBlog(String blogId) async {
    var url = Uri.parse('${pethomeApiUrl}blogs/detail/$blogId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data == null) {
        return Blog(
          blogId: '',
          description: '',
          createAt: '',
          idUser: '',
          status: '',
          images: [],
          nameAuthor: '',
          avatarAuthor: '',
        );
      }

      return Blog.fromJson(data);
    } else {
      throw Exception('Failed to load detail blog');
    }
  }
}
