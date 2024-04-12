import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class SendRateWidget extends StatefulWidget {
  const SendRateWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SendRateWidgetState createState() => _SendRateWidgetState();
}

class _SendRateWidgetState extends State<SendRateWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final int maxLength = 200;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(8), 
  ),
  height: 5 * 24.0, 
  padding: const EdgeInsets.symmetric(horizontal: 12), 
  child: Column(
    children: [
      Expanded(
        child: TextField(
          controller: _textEditingController,
          cursorColor: buttonBackgroundColor,
          maxLines: 4,
          maxLength: maxLength,
          decoration: const InputDecoration(
            hintText: 'Nhập đánh giá của bạn',
            border: InputBorder.none, 
          ),
        ),
      ),
      const SizedBox(height: 5),
    ],
  ),
),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Xếp hạng: ', style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: buttonBackgroundColor
              )),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 25,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: buttonBackgroundColor,
            ),
            child: InkWell(
              onTap: () {
                //TO-DO
                Navigator.of(context).pop();
              },
              child: const Center(
                child: Text(
                  'Gửi đánh giá',
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
    );
  }
}
