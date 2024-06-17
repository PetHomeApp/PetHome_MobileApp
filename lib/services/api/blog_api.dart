import 'dart:convert';

import 'package:http/http.dart' as http;
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
      throw Exception('Failed to load pets');
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
      throw Exception('Failed to load pets');
    }
  }

  Future<bool> checkLike(String idBlog) async {
    var url = Uri.parse('${pethomeApiUrl}api/blogs/$idBlog/like');

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

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

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

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

}