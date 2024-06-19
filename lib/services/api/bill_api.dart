import 'package:dio/dio.dart';
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
      String address, String area, int idMethod) async {
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
      print(e);
      return {'isSuccess': false};
    }
  }
}
