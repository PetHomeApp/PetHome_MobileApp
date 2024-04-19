import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/widgets/rate/sent_rate_sheet.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/rate/model_rate.dart';
import 'package:pethome_mobileapp/widgets/rate/list_rate.dart';
import 'package:pethome_mobileapp/model/pet/model_pet_detail.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class PetDetailScreen extends StatefulWidget {
  const PetDetailScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PetDetailScreenState createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  final PetDetail petDetail = PetDetail(
    idPet: "id_pet",
    name: "Chú cún Pon Pon xinh xắn, dễ thương, dễ chăm sóc",
    idPetSpecie: "id_pet_specie",
    price: 2000000,
    inStock: false,
    description:
        // ignore: prefer_interpolation_to_compose_strings
        "Chú chó là một loài động vật thuộc họ Canidae, có nguồn gốc từ chó hoang dã.\n"
            // ignore: prefer_adjacent_string_concatenation
            +
            "Chúng được coi là loài động vật cảnh và loài động vật nuôi phổ biến trên toàn thế giới.\n" +
            "Chú chó là một đồng loài thông minh, trung thành và trung tính, được nhiều người yêu thích vì tính cách đáng yêu và sự trung thành với con người.\n" +
            "Chúng thường được nuôi làm thú cưng hoặc làm việc trong nhiều vai trò khác nhau như giữ nhà, săn bắn, cứu hộ, và hướng dẫn.\n" +
            "Một số giống chó nổi tiếng bao gồm Labrador Retriever, German Shepherd, Golden Retriever và Beagle.\n",
    imageUrl: "https://via.placeholder.com/150",
    idShop: "id_shop",
    rates: [
      Rate(
        idRate: "id_rate_1",
        idUser: "id_user_1",
        userName: "Nguyễn Văn A",
        idProduct: "id_product",
        rate: 4,
        comment:
            "Chú cún rất dễ thương, ngoan ngoãn, dễ chăm sóc. Tôi rất hài lòng với sản phẩm này. Tôi sẽ tiếp tục ủng hộ cửa hàng. Cảm ơn cửa hàng rất nhiều!\n"
                // ignore: prefer_adjacent_string_concatenation
                +
                "Chú cún rất dễ thương, ngoan ngoãn, dễ chăm sóc. Tôi rất hài lòng với sản phẩm này. Tôi sẽ tiếp tục ủng hộ cửa hàng. Cảm ơn cửa hàng rất nhiều!\n",
        createdAt: "2021-10-10",
      ),
      Rate(
        idRate: "id_rate_1",
        idUser: "id_user_1",
        userName: "Nguyễn Văn A",
        idProduct: "id_product",
        rate: 5,
        comment: "Chú cún rất dễ thương, ngoan ngoãn.",
        createdAt: "2021-10-10",
      ),
      Rate(
        idRate: "id_rate_1",
        idUser: "id_user_1",
        userName: "Nguyễn Văn A",
        idProduct: "id_product",
        rate: 5,
        comment: "Chú cún rất dễ thương, ngoan ngoãn, dễ chăm sóc.",
        createdAt: "2021-10-10",
      ),
    ],
    averageRate: 4.9,
    totalRate: 53,
  );

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
          "Thông tin sản phẩm",
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
            icon: const Icon(Icons.shopping_cart,
                color: buttonBackgroundColor, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                      child: Image.network(
                        petDetail.imageUrl.toString(),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            petDetail.name!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            petDetail.idShop!,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${NumberFormat('#,##0', 'vi').format(petDetail.price)} VNĐ',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: priceColor,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: petDetail.inStock!
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  petDetail.inStock!
                                      ? '  Còn hàng  '
                                      : '  Hết hàng  ',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [gradientStartColor, gradientEndColor],
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: const Row(
                        children: [
                          Icon(Icons.description, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Mô tả',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ReadMoreText(
                        petDetail.description!,
                        trimLength: 250,
                        trimCollapsedText: "Xem thêm",
                        trimExpandedText: "Rút gọn",
                        delimiter: "...\n",
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
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [gradientStartColor, gradientEndColor],
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: const Row(
                        children: [
                          Icon(Icons.comment, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Khách hàng đánh giá',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // ignore: prefer_interpolation_to_compose_strings
                              Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                petDetail.averageRate!.toStringAsFixed(1) +
                                    "/5.0",
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: buttonBackgroundColor),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "(${petDetail.totalRate} đánh giá)",
                                style: const TextStyle(
                                    color: buttonBackgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                          RateList(rates: petDetail.rates),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Tất cả đánh giá (${petDetail.totalRate})',
                              style: const TextStyle(
                                color: buttonBackgroundColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: buttonBackgroundColor,
                            ),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: const SendRateWidget(),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Center(
                                child: Text(
                                  'Viết đánh giá',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
