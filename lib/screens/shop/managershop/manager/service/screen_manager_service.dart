import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_type.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/manager/service/screen_manager_service_type.dart';
import 'package:pethome_mobileapp/services/api/service_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ManagerServiceScreen extends StatefulWidget {
  final String shopId;
  final Function(bool) updateBottomBarVisibility;
  const ManagerServiceScreen(
      {super.key,
      required this.shopId,
      required this.updateBottomBarVisibility});

  @override
  State<ManagerServiceScreen> createState() => _ManagerServiceScreenState();
}

class _ManagerServiceScreenState extends State<ManagerServiceScreen>
    with SingleTickerProviderStateMixin {
  List<ServiceType> serviceTypes = List.empty(growable: true);

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();
  bool _isBottomBarVisible = true;

  bool loading = false;

  @override
  void initState() {
    _scrollController.addListener(_onScrollActive);
    getServiceType();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScrollActive() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isBottomBarVisible) {
        setState(() {
          _isBottomBarVisible = false;
          widget.updateBottomBarVisibility(false);
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isBottomBarVisible) {
        setState(() {
          _isBottomBarVisible = true;
          widget.updateBottomBarVisibility(true);
        });
      }
    }
  }

  Future<void> getServiceType() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<ServiceType> serviceType = await ServiceApi().getServiceType();
    serviceType.sort((a, b) => a.idServiceType.compareTo(b.idServiceType));

    setState(() {
      serviceTypes = serviceType;
      loading = false;
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
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
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Nhập để tìm kiếm...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              onPressed: () {
                String searchKey = _searchController.text;
                if (searchKey.isEmpty) {
                  showTopSnackBar(
                    // ignore: use_build_context_synchronously
                    Overlay.of(context),
                    const CustomSnackBar.error(
                      message: 'Vui lòng nhập thông tin tìm kiếm!',
                    ),
                    displayDuration: const Duration(seconds: 0),
                  );
                  return;
                }
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) =>
                //       PetSearchAndFilterScreen(title: searchKey),
                // ));
                _searchController.clear();
              },
              icon: const Icon(
                Icons.search,
                size: 30,
                color: iconButtonColor,
              ),
            ),
            // Insert icon button
            IconButton(
              onPressed: () {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(
                //   builder: (context) => const AddPetScreen(),
                // ))
                //     .then((value) {
                //   listPetRequestInCards.clear();
                //   currentPageRequest = 0;
                //   getListPetRequiredInShop();
                // });
              },
              icon: const Icon(
                Icons.add,
                size: 30,
                color: iconButtonColor,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientStartColor, gradientEndColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: serviceTypes.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          ServiceType serviceType = serviceTypes[index];
          List<Widget> serviceTypeWidgets = [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(serviceType.name,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: buttonBackgroundColor)),
            ),
          ];
          serviceTypeWidgets.addAll(serviceType.details.map((detail) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ManagerServiceByTypeScreen(
                      shopId: widget.shopId,
                      title: detail.name,
                      serviceTypeDetailId: detail.idServiceTypeDetail),
                ));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 8.0),
                child: Text(detail.name, style: const TextStyle(fontSize: 16)),
              ),
            );
          }).toList());

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: serviceTypeWidgets,
          );
        },
      ),
    );
  }
}
