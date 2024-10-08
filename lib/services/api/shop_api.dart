import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_in_card.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_request.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_request.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_image_gallery.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_in_card.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_request.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_detail_infor.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_register.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopApi {
  Future<Map<String, dynamic>> checkIsRegisterShop() async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/check');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        if (data['message'] == 'User is shop owner') {
          return {
            'isSuccess': true,
          };
        } else {
          return {'isSuccess': false};
        }
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> checkIsActiveShop() async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/status');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        if (data['status'] == 'active') {
          return {
            'isSuccess': true,
            'shopId': data['id_shop'],
          };
        } else {
          return {'isSuccess': false};
        }
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> registerShop(
      ShopInforRegister shopInforRegister) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/submit');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = accessToken;

    request.fields['name'] = shopInforRegister.shopName;
    request.fields['address'] = shopInforRegister.shopAddress;
    request.fields['area'] = shopInforRegister.area;
    request.fields['tax_code'] = shopInforRegister.taxCode;
    request.fields['business_type'] = shopInforRegister.businessType;
    request.fields['owner_name'] = shopInforRegister.ownerName;
    request.fields['id_card'] = shopInforRegister.idCard;

    request.files.add(
      await http.MultipartFile.fromPath('logo', shopInforRegister.logo.path),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
          'front_id_card', shopInforRegister.idCardFront.path),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
          'back_id_card', shopInforRegister.idCardBack.path),
    );

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        // Handle error
        json.decode(responseBody);
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> getShopInfor(String shopId) async {
    var url = Uri.parse('${pethomeApiUrl}shops/$shopId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        return {
          'isSuccess': true,
          'shopInfor': data,
        };
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> getShopDetailInfor() async {
    var url = Uri.parse('${pethomeApiUrl}api/shop');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        return {
          'isSuccess': true,
          'shopInfor': ShopDetailInfor.fromJson(data),
        };
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> getListPetActiveInShop(
      String shopId, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}shops/$shopId/pets?limit=$limit&start=$start&status=active');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<PetInCard> pets = [];
      var data = json.decode(response.body);

      if (data == null) {
        return {'isSuccess': false, 'data': pets, 'count': 0};
      }

      if (data['data'] == null) {
        return {'isSuccess': false, 'data': pets, 'count': 0};
      }

      for (var item in data['data']) {
        pets.add(PetInCard.fromJson(item));
      }
      int count = data['count'];

      return {'isSuccess': true, 'data': pets, 'count': count};
    } else {
      throw Exception('Failed to load pets');
    }
  }

  Future<Map<String, dynamic>> getListPetRequestInShop(
      String shopId, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}shops/$shopId/pets?limit=$limit&start=$start&status=requested');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<PetInCard> pets = [];
      var data = json.decode(response.body);

      if (data == null) {
        return {'isSuccess': false, 'data': pets, 'count': 0};
      }

      if (data['data'] == null) {
        return {'isSuccess': false, 'data': pets, 'count': 0};
      }

      for (var item in data['data']) {
        pets.add(PetInCard.fromJson(item));
      }
      int count = data['count'];

      return {'isSuccess': true, 'data': pets, 'count': count};
    } else {
      throw Exception('Failed to load pets');
    }
  }

  Future<Map<String, dynamic>> searchPetsActiveInShop(
      String shopId, String searchKey, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}shops/$shopId/pets?limit=$limit&start=$start&status=active&name=$searchKey');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<PetInCard> pets = [];
      var data = json.decode(response.body);

      if (data == null) {
        return {'isSuccess': false, 'data': pets, 'count': 0};
      }

      if (data['data'] == null) {
        return {'isSuccess': false, 'data': pets, 'count': 0};
      }

      for (var item in data['data']) {
        pets.add(PetInCard.fromJson(item));
      }
      int count = data['count'];

      return {'isSuccess': true, 'data': pets, 'count': count};
    } else {
      throw Exception('Failed to load pets');
    }
  }

  Future<Map<String, dynamic>> searchPetsRequestInShop(
      String shopId, String searchKey, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}shops/$shopId/pets?limit=$limit&start=$start&status=requested&name=$searchKey');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<PetInCard> pets = [];
      var data = json.decode(response.body);

      if (data == null) {
        return {'isSuccess': false, 'data': pets, 'count': 0};
      }

      if (data['data'] == null) {
        return {'isSuccess': false, 'data': pets, 'count': 0};
      }

      for (var item in data['data']) {
        pets.add(PetInCard.fromJson(item));
      }
      int count = data['count'];

      return {'isSuccess': true, 'data': pets, 'count': count};
    } else {
      throw Exception('Failed to load pets');
    }
  }

  Future<Map<String, dynamic>> getListItemActiveInShop(
      String shopId, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}shops/$shopId/items?limit=$limit&start=$start&status=active');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ItemInCard> items = [];
      var data = json.decode(response.body);

      if (data == null) {
        return {'isSuccess': false, 'data': items, 'count': 0};
      }

      if (data['data'] == null) {
        return {'isSuccess': false, 'data': items, 'count': 0};
      }

      for (var item in data['data']) {
        items.add(ItemInCard.fromJson(item));
      }
      int count = data['count'];

      return {'isSuccess': true, 'data': items, 'count': count};
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Map<String, dynamic>> getListItemRequestInShop(
      String shopId, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}shops/$shopId/items?limit=$limit&start=$start&status=requested');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ItemInCard> items = [];
      var data = json.decode(response.body);

      if (data == null) {
        return {'isSuccess': false, 'data': items, 'count': 0};
      }

      if (data['data'] == null) {
        return {'isSuccess': false, 'data': items, 'count': 0};
      }

      for (var item in data['data']) {
        items.add(ItemInCard.fromJson(item));
      }
      int count = data['count'];

      return {'isSuccess': true, 'data': items, 'count': count};
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Map<String, dynamic>> searchItemsActiveInShop(
      String shopId, String searchKey, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}shops/$shopId/items?limit=$limit&start=$start&status=active&name=$searchKey');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ItemInCard> items = [];
      var data = json.decode(response.body);

      if (data == null) {
        return {'isSuccess': false, 'data': items, 'count': 0};
      }

      if (data['data'] == null) {
        return {'isSuccess': false, 'data': items, 'count': 0};
      }

      for (var item in data['data']) {
        items.add(ItemInCard.fromJson(item));
      }
      int count = data['count'];

      return {'isSuccess': true, 'data': items, 'count': count};
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Map<String, dynamic>> searchItemsRequestInShop(
      String shopId, String searchKey, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}shops/$shopId/items?limit=$limit&start=$start&status=requested&name=$searchKey');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ItemInCard> items = [];
      var data = json.decode(response.body);

      if (data == null) {
        return {'isSuccess': false, 'data': items, 'count': 0};
      }

      if (data['data'] == null) {
        return {'isSuccess': false, 'data': items, 'count': 0};
      }

      for (var item in data['data']) {
        items.add(ItemInCard.fromJson(item));
      }
      int count = data['count'];

      return {'isSuccess': true, 'data': items, 'count': count};
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Map<String, dynamic>> getListServiceActiveInShop(
      int serviceTypeDetailID, String shopId, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}shops/$shopId/services?limit=$limit&start=$start&status=active&serviceTypeDetailID=$serviceTypeDetailID');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ServiceInCard> services = [];
      var data = json.decode(response.body);

      if (data == null) {
        return {'isSuccess': false, 'data': services, 'count': 0};
      }

      if (data['data'] == null) {
        return {'isSuccess': false, 'data': services, 'count': 0};
      }

      for (var service in data['data']) {
        services.add(ServiceInCard.fromJson(service));
      }
      int count = data['count'];

      return {'isSuccess': true, 'data': services, 'count': count};
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<Map<String, dynamic>> getListServiceRequestInShop(
      int serviceTypeDetailID, String shopId, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}shops/$shopId/services?limit=$limit&start=$start&status=requested&serviceTypeDetailID=$serviceTypeDetailID');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ServiceInCard> services = [];
      var data = json.decode(response.body);

      if (data == null) {
        return {'isSuccess': false, 'data': services, 'count': 0};
      }

      if (data['data'] == null) {
        return {'isSuccess': false, 'data': services, 'count': 0};
      }

      for (var service in data['data']) {
        services.add(ServiceInCard.fromJson(service));
      }
      int count = data['count'];

      return {'isSuccess': true, 'data': services, 'count': count};
    } else {
      throw Exception('Failed to load services');
    }
  }

  // Insert product
  Future<Map<String, dynamic>> insertPet(PetIsRequest pet) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/pets');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'name': pet.name,
      'id_pet_specie': pet.idPetSpecie,
      'id_pet_age': pet.idPetAge,
      'weight': pet.weight,
      'price': pet.price,
      'description': pet.description,
      'header_image': await MultipartFile.fromFile(pet.headerImage!.path),
    });

    for (var image in pet.images) {
      formData.files.add(MapEntry(
        'images',
        await MultipartFile.fromFile(image!.path),
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

  Future<Map<String, dynamic>> insertItem(ItemIsRequest item) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/items');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'name': item.name,
      'id_item_type_detail': item.idItemTypeDetail,
      'unit': item.unit,
      'description': item.description,
      'header_image': await MultipartFile.fromFile(item.headerImage!.path),
    });

    for (var image in item.images) {
      formData.files.add(MapEntry(
        'images',
        await MultipartFile.fromFile(image!.path),
      ));
    }

    for (var detail in item.itemDetail) {
      formData.fields.add(MapEntry('item_detail', detail));
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

  Future<Map<String, dynamic>> insertService(ServiceIsRequest service) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/services');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'name': service.name,
      'id_service_type_detail': service.idServiceDetail,
      'min_price': service.minPrice,
      'max_price': service.maxPrice,
      'description': service.description,
      'header_image': await MultipartFile.fromFile(service.headerImage!.path),
    });

    for (var image in service.images) {
      formData.files.add(MapEntry(
        'images',
        await MultipartFile.fromFile(image!.path),
      ));
    }

    for (var address in service.idAddress) {
      formData.fields.add(MapEntry('id_address', address));
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

  // Delete product
  Future<Map<String, dynamic>> deletePet(String petId) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/pets/$petId/remove');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> deleteItem(String itemId) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/items/$itemId/remove');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> deleteService(String serviceId) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/services/$serviceId/remove');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  // Update product
  Future<Map<String, dynamic>> updatePet(
      String idPet, int price, bool isInStock) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/pets/$idPet');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'price': price,
      'instock': isInStock,
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

  Future<Map<String, dynamic>> addItemDetail(
      String idItem, int price, String size, int quantity) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/items/$idItem/detail/add');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'item_detail': '$price^$size^$quantity',
    });

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

  Future<Map<String, dynamic>> deleteItemDetail(
      String idItem, String idItemDetail) async {
    var url = Uri.parse(
        '${pethomeApiUrl}api/shop/items/$idItem/detail/$idItemDetail');

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

  Future<Map<String, dynamic>> updateItemDetail(
      String idItem, String idItemDetail, int price, int quantity) async {
    var url = Uri.parse(
        '${pethomeApiUrl}api/shop/items/$idItem/detail/$idItemDetail');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'price': price,
      'quantity': quantity,
      'instock': quantity > 0 ? 'true' : 'false',
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

  Future<Map<String, dynamic>> updatePriceService(
      String idService, int minPrice, int maxPrice) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/services/$idService');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'min_price': minPrice,
      'max_price': maxPrice,
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

  Future<Map<String, dynamic>> updateAddressService(String idService,
      List<String> newAddressid, List<String> deleteAddressId) async {
    var url =
        Uri.parse('${pethomeApiUrl}api/shop/services/$idService/addresses');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    FormData formData = FormData.fromMap({});

    if (newAddressid.isNotEmpty) {
      for (var address in newAddressid) {
        formData.fields.add(MapEntry('new_id_address', address));
      }
    }

    if (deleteAddressId.isNotEmpty) {
      for (var address in deleteAddressId) {
        formData.fields.add(MapEntry('removed_id_address', address));
      }
    }

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

  // Shop Address
  Future<Map<String, dynamic>> addAddress(String address, String area) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/address');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
        body: json.encode({
          'address': address,
          'area': area,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> deleteAddress(String idAddress) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/address/$idAddress');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> updateLogo(XFile? avatar) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/logo');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    var request = http.MultipartRequest('PUT', url);

    request.headers['Authorization'] = accessToken;

    request.files.add(
      await http.MultipartFile.fromPath('file', avatar!.path),
    );

    try {
      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> getListImageGallery(String idService) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/services/$idService/gallery');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
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
      List<ServiceImageGallry> images = [];
      var data = json.decode(response.body);

      if (data == null) {
        return {'isSuccess': false, 'data': images, 'count': 0};
      }

      for (var service in data) {
        images.add(ServiceImageGallry.fromJson(service));
      }
      return {'isSuccess': true, 'data': images};
    } else {
      throw Exception('Failed to load images gallery');
    }
  }

  Future<Map<String, dynamic>> addImageGallery(
      String idService, List<XFile> images) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/services/$idService/gallery');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    FormData formData = FormData.fromMap({});

    formData.fields.add(MapEntry('id_service', idService));

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

  Future<Map<String, dynamic>> deleteImageGallery(
      String idService, String idImage) async {
    var url = Uri.parse(
        '${pethomeApiUrl}api/shop/services/$idService/gallery/$idImage?status=inactive');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }
}
