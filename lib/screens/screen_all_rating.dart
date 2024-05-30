import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/rate/model_rate.dart';
import 'package:pethome_mobileapp/services/api/item_api.dart';
import 'package:pethome_mobileapp/services/api/pet_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/rate/rate_item.dart';

class AllRatingScreen extends StatefulWidget {
  const AllRatingScreen(
      {super.key,
      required this.name,
      required this.imageUrl,
      required this.productType,
      required this.averageRate,
      required this.totalRate,
      required this.id});

  final String id;
  final String name;
  final String imageUrl;
  final String productType;
  final double averageRate;
  final int totalRate;

  @override
  State<AllRatingScreen> createState() => _AllRatingScreenState();
}

class _AllRatingScreenState extends State<AllRatingScreen> {
  final ScrollController _scrollController = ScrollController();

  int currentPage = 0;
  bool loading = false;

  late List<Rate> listRate = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listenerScroll);
    getListRating();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _listenerScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        getListRating();
      }
    }
  }

  Future<void> getListRating() async {
    if (loading) {
      return;
    }
    loading = true;

    if (widget.productType == 'pet') {
      final List<Rate> rates =
          await PetApi().getPetRates(widget.id, 5, currentPage * 5);

      if (rates.isEmpty) {
        loading = false;
        return;
      }
      setState(() {
        listRate.addAll(rates);
        currentPage++;
        loading = false;
      });
    } else if (widget.productType == 'item') {
      ItemApi itemApi = ItemApi();
      final List<Rate> rates =
          await itemApi.getItemRates(widget.id, 5, currentPage * 5);

      if (rates.isEmpty) {
        loading = false;
        return;
      }
      setState(() {
        listRate.addAll(rates);
        currentPage++;
        loading = false;
      });
    } else {}
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
          "Tất cả đánh giá",
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(
                            widget.imageUrl,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                              fontSize: 24.0,
                              color: buttonBackgroundColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text(
                        "Trung bình: ",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${widget.averageRate.toStringAsFixed(1)}/5.0",
                        style: const TextStyle(
                          fontSize: 25.0,
                          color: buttonBackgroundColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        "(${widget.totalRate} đánh giá)",
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listRate.length,
                    itemBuilder: (context, index) {
                      return RateItem(rate: listRate[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
