import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class ShopManagementScreen extends StatelessWidget {
  const ShopManagementScreen({super.key});

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
      body: Padding(
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
                      // Điều hướng đến màn hình quản lý sản phẩm
                      //print('Navigate to Product Management');
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
            child: Image.network(
              'https://via.placeholder.com/150', // Đường dẫn đến hình ảnh đại diện
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PetHome xin chào!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: buttonBackgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Chúc bạn một ngày làm việc hiệu quả!',
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