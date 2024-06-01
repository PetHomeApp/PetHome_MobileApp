import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_infor.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/screen_main_manager_product.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class ShopManagementScreen extends StatefulWidget {
  const ShopManagementScreen({super.key, required this.idShop});
  final String idShop;

  @override
  State<ShopManagementScreen> createState() => _ShopManagementScreenState();
}

class _ShopManagementScreenState extends State<ShopManagementScreen> {
  bool loading = false;
  late ShopInfor shopInfor;
  late String shopName;

  @override
  void initState() {
    super.initState();
    getShopInfo();
  }

  Future<void> getShopInfo() async {
    if (loading) {
      return;
    }

    loading = true;
    final dataResponse = await ShopApi().getShopInfor(widget.idShop);

    if (dataResponse['isSuccess'] == true) {
      setState(() {
        shopInfor = ShopInfor.fromJson(dataResponse['shopInfor']);
        shopName = shopInfor.name;
        loading = false;
      });
    } else {
      setState(() {
        shopInfor = ShopInfor(
          idShop: '',
          name: '',
          logo: '',
          areas: [],
        );
        shopName = '';
        loading = false;
      });
    }
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
          "Quản lý cửa hàng",
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
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: appColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      children: [
                        _buildManagementButton(
                          context,
                          title: 'Quản lý đơn hàng',
                          icon: Icons.receipt_long,
                          color: Colors.blue.shade400,
                          onTap: () {
                            // Điều hướng đến màn hình quản lý đơn hàng
                            //print('Navigate to Order Management');
                          },
                        ),
                        _buildManagementButton(
                          context,
                          title: 'Quản lý sản phẩm',
                          icon: Icons.inventory,
                          color: Colors.orange.shade400,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MainManagerProductScreen(
                                  initialIndex: 0,
                                  shopId: widget.idShop,
                                ),
                              ),
                            );
                          },
                        ),
                        _buildManagementButton(
                          context,
                          title: 'Quản lý doanh thu',
                          icon: Icons.bar_chart,
                          color: Colors.green.shade400,
                          onTap: () {
                            // Điều hướng đến màn hình quản lý doanh thu
                            //print('Navigate to Revenue Management');
                          },
                        ),
                        _buildManagementButton(
                          context,
                          title: 'Thông tin cửa hàng',
                          icon: Icons.store,
                          color: const Color.fromARGB(255, 207, 83, 98),
                          onTap: () {
                            // Điều hướng đến màn hình thông tin cửa hàng
                            //print('Navigate to Store Information');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 211, 245, 242),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(shopInfor.logo,
                width: 80.0,
                height: 80.0,
                fit: BoxFit.cover, errorBuilder: (BuildContext context,
                    Object exception, StackTrace? stackTrace) {
              return Image.asset('lib/assets/pictures/placeholder_image.png',
                  fit: BoxFit.cover);
            }),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào, $shopName!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: buttonBackgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Chúc một ngày làm việc hiệu quả!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.teal[900],
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60.0,
              color: color,
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: buttonBackgroundColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
