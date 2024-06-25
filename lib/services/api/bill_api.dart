import 'package:dio/dio.dart';
import 'package:pethome_mobileapp/model/bill/model_bill.dart';
import 'package:pethome_mobileapp/model/payment/model_payment_method.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_sent_bill.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillApi {
  Future<List<PaymentMethod>> getPaymentMethod() async {
    var url = Uri.parse('${pethomeApiUrl}payment/methods');

    final response = await Dio().get(url.toString());

    if (response.statusCode == 200) {
      List<PaymentMethod> paymentMethods = [];
      var data = response.data;

      if (data == null) {
        return paymentMethods;
      }

      for (var item in data) {
        paymentMethods.add(PaymentMethod.fromJson(item));
      }

      return paymentMethods;
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> sentBill(List<ItemSentBill> listItemSenBill,
      String phoneNumber, String address, String area, int idMethod) async {
    var url = Uri.parse('${pethomeApiUrl}api/user/bills/create');

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'phone_number': phoneNumber,
      'address': address,
      'area': area,
      'id_method': idMethod,
    });

    for (var item in listItemSenBill) {
      formData.fields.add(MapEntry(
          'cart', '${item.itemId}^${item.itemDetailId}^${item.quantity}'));
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
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<List<BillItem>> getListBillAll(int start, int limit) async {
    var url = Uri.parse(
        "${pethomeApiUrl}api/user/bills?start=$start&limit=$limit&status='pending','preparing','delivering','delivered'&payment_status='pending','paid'");

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

    if (authRes['isSuccess'] == false) {
      return [];
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await Dio().get(
        url.toString(),
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );
      if (response.statusCode == 200) {
        List<BillItem> listBillItem = [];
        var data = response.data;

        if (data == null) {
          return listBillItem;
        }

        for (var item in data) {
          listBillItem.add(BillItem.fromJson(item));
        }

        return listBillItem;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<BillItem>> getListBillSuccess(int start, int limit) async {
    var url = Uri.parse(
        "${pethomeApiUrl}api/user/bills?start=$start&limit=$limit&status='done'&payment_status='pending','paid'");

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

    if (authRes['isSuccess'] == false) {
      return [];
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    final response = await Dio().get(
      url.toString(),
      options: Options(
        headers: {
          'Authorization': accessToken,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<BillItem> listBillItem = [];
      var data = response.data;

      if (data == null) {
        return listBillItem;
      }

      for (var item in data) {
        listBillItem.add(BillItem.fromJson(item));
      }

      return listBillItem;
    } else {
      return [];
    }
  }

  Future<List<BillItem>> getListBillCancel(int start, int limit) async {
    var url = Uri.parse(
        "${pethomeApiUrl}api/user/bills?start=$start&limit=$limit&status='canceled'&payment_status='pending'");

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

    if (authRes['isSuccess'] == false) {
      return [];
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    final response = await Dio().get(
      url.toString(),
      options: Options(
        headers: {
          'Authorization': accessToken,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<BillItem> listBillItem = [];
      var data = response.data;

      if (data == null) {
        return listBillItem;
      }

      for (var item in data) {
        listBillItem.add(BillItem.fromJson(item));
      }

      return listBillItem;
    } else {
      return [];
    }
  }

  Future<bool> updateStatusBillByUser(String idBill, String status) async {
    var url = Uri.parse('${pethomeApiUrl}api/user/bills/$idBill');

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

    if (authRes['isSuccess'] == false) {
      return false;
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    Map<String, dynamic> data = {
      'status': status,
    };

    try {
      final response = await dio.put(
        url.toString(),
        data: data,
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<BillItem>> getListOtherBillForShop(int start, int limit) async {
    var url = Uri.parse(
        "${pethomeApiUrl}api/shop/bills?start=$start&limit=$limit&status='preparing','delivering','delivered'");

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

    if (authRes['isSuccess'] == false) {
      return [];
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    final response = await Dio().get(
      url.toString(),
      options: Options(
        headers: {
          'Authorization': accessToken,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<BillItem> listBillItem = [];
      var data = response.data;

      if (data == null) {
        return listBillItem;
      }

      for (var item in data) {
        listBillItem.add(BillItem.fromJson(item));
      }

      return listBillItem;
    } else {
      return [];
    }
  }

  Future<List<BillItem>> getListStatusBillForShop(
      int start, int limit, String status) async {
    var url = Uri.parse(
        "${pethomeApiUrl}api/shop/bills?start=$start&limit=$limit&status='$status'");

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

    if (authRes['isSuccess'] == false) {
      return [];
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    final response = await Dio().get(
      url.toString(),
      options: Options(
        headers: {
          'Authorization': accessToken,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<BillItem> listBillItem = [];
      var data = response.data;

      if (data == null) {
        return listBillItem;
      }

      for (var item in data) {
        listBillItem.add(BillItem.fromJson(item));
      }

      return listBillItem;
    } else {
      return [];
    }
  }

  Future<bool> updateStatusBillByShop(String idBill, String status) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/bills/$idBill');

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

    if (authRes['isSuccess'] == false) {
      return false;
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    Dio dio = Dio();

    Map<String, dynamic> data = {
      'status': status,
    };

    try {
      final response = await dio.put(
        url.toString(),
        data: data,
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
