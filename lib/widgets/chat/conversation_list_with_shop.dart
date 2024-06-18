import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ConversationListWithShop extends StatefulWidget {
  String idShop;
  String name;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;

  ConversationListWithShop(
      {super.key,
      required this.idShop,
      required this.name,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.isMessageRead});

  @override
  // ignore: library_private_types_in_public_api
  _ConversationListWithShopState createState() =>
      _ConversationListWithShopState();
}

class _ConversationListWithShopState extends State<ConversationListWithShop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 75.0,
                  height: 75.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60.0),
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                              'lib/assets/pictures/placeholder_image.png',
                              fit: BoxFit.cover);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.name,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          widget.messageText,
                          style: TextStyle(
                              fontSize: 14,
                              color: widget.isMessageRead
                                  ? Colors.grey.shade600
                                  : Colors.black,
                              fontWeight: widget.isMessageRead
                                  ? FontWeight.normal
                                  : FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.time.isEmpty ? '' : formatDateTime(widget.time),
            style: TextStyle(
                fontSize: 12,
                color:
                    widget.isMessageRead ? Colors.grey.shade600 : Colors.black,
                fontWeight:
                    widget.isMessageRead ? FontWeight.normal : FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime =
        DateTime.parse(dateTimeString).add(const Duration(hours: 7));
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return DateFormat('HH:mm').format(dateTime);
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }
}
