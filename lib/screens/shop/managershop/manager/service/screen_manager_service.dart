import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_type.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/manager/service/screen_add_service.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/manager/service/screen_manager_service_type.dart';
import 'package:pethome_mobileapp/services/api/product/service_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

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

    for (int i = 0; i < serviceType.length; i++) {
      serviceType[i].details.sort(
          (a, b) => a.idServiceTypeDetail.compareTo(b.idServiceTypeDetail));
    }

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
        title: const Text(
          'Quản lý dịch vụ',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddServiceScreen(shopId: widget.shopId),
              ));
            },
            icon: const Icon(
              Icons.add,
              size: 30,
              color: iconButtonColor,
            ),
          ),
        ],
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
