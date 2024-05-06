import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/rate/model_rate.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:readmore/readmore.dart';

// ignore: must_be_immutable
class RateItem extends StatelessWidget {
  late Rate rate;

  RateItem({super.key, 
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(rate.createdAt!);
    String formattedDate = DateFormat('hh:mm - dd/MM/yyyy').format(parsedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rate.userName!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Row(
          children: List.generate(5, (index) {
            if (index < rate.rate!) {
              return const Icon(Icons.star, color: Colors.amber, size: 20);
            } else {
              return const Icon(Icons.star_border, color: Colors.amber, size: 20);
            }
          }),
        ),
        Text(
          formattedDate,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ReadMoreText(
          rate.comment!,
          trimLength: 120,
          trimCollapsedText: "Xem thêm",
          trimExpandedText: "Rút gọn",
          delimiter: "...",
          moreStyle: const TextStyle(
            color: buttonBackgroundColor,
          ),
          lessStyle: const TextStyle(
            color: buttonBackgroundColor,
          ),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }
}