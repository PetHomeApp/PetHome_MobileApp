import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/item/model_item_cart.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class ItemCartWidget extends StatefulWidget {
  final ItemCart itemCart;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const ItemCartWidget(
      {super.key,
      required this.itemCart,
      required this.onRemove,
      required this.onChanged});

  @override
  State<ItemCartWidget> createState() => _ItemCartWidgetState();
}

class _ItemCartWidgetState extends State<ItemCartWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.itemCart.quantity}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      widget.itemCart.quantity++;
      widget.onChanged();
      _controller.text = '${widget.itemCart.quantity}';
    });
  }

  void _decrementCounter() {
    setState(() {
      if (widget.itemCart.quantity > 1) {
        widget.itemCart.quantity--;
        widget.onChanged();
        _controller.text = '${widget.itemCart.quantity}';
      }
    });
  }

  void resetQuantity() {
    setState(() {
      _controller.text = '${widget.itemCart.quantity}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
            onPressed: (context) {
              widget.onRemove();
            },
            icon: Icons.delete,
            label: "Xóa",
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: widget.itemCart.isCheckBox,
                  checkColor: Colors.white,
                  onChanged: (bool? value) {
                    setState(() {
                      widget.itemCart.isCheckBox = value ?? false;
                      widget.onChanged();
                    });
                  },
                  activeColor: buttonBackgroundColor,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    widget.itemCart.picture.toString(),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        'lib/assets/pictures/placeholder_image.png',
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemCart.name.toString().length > 30
                            ? '${widget.itemCart.name.toString().substring(0, 30)}...'
                            : widget.itemCart.name.toString(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.itemCart.size} ${widget.itemCart.unit}',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 84, 84, 84)),
                      ),
                      Text(
                        widget.itemCart.shopName.toString().length > 20
                            ? '${widget.itemCart.shopName.toString().substring(0, 20)}...'
                            : widget.itemCart.shopName.toString(),
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 84, 84, 84)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${NumberFormat('#,##0', 'vi').format(widget.itemCart.price)} đ',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: priceColor,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.itemCart.inStock
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.itemCart.inStock
                                    ? '  Còn hàng  '
                                    : '  Hết hàng  ',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _buildSquareButton('-', _decrementCounter),
                  _buildSquareTextField(),
                  _buildSquareButton('+', _incrementCounter),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareButton(String label, VoidCallback onPressed) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(label, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildSquareTextField() {
    return Container(
      width: 50,
      height: 30,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black),
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      alignment: Alignment.center,
      child: Center(
        child: TextField(
          controller: _controller,
          cursorColor: buttonBackgroundColor,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 6.0),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.itemCart.quantity = int.tryParse(value) ?? 1;
              _controller.text = '${widget.itemCart.quantity}';
              widget.onChanged();
            });
          },
        ),
      ),
    );
  }
}
