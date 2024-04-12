import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/rate/model_rate.dart';
import 'rate_item.dart';

class RateList extends StatelessWidget {
  final List<Rate> rates;

  const RateList({
    super.key,
    required this.rates,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rates.length,
      itemBuilder: (context, index) {
        return RateItem(rate: rates[index]);
      },
    );
  }
}