import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class WebPaymentScreen extends StatefulWidget {
  const WebPaymentScreen({super.key, required this.url});
  final String url;

  @override
  State<WebPaymentScreen> createState() => _WebPaymentScreenState();
}

class _WebPaymentScreenState extends State<WebPaymentScreen> {
  double _progress = 0;
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await _webViewController.canGoBack();
        if (isLastPage) {
          _webViewController.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
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
            "Thanh toán ví điện tử",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  gradientStartColor,
                  gradientMidColor,
                  gradientEndColor
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              onUpdateVisitedHistory: (InAppWebViewController controller,
                  WebUri? url, bool? androidIsReload) {
                if (url != null &&
                    url.toString().contains("vnp_ResponseCode=00")) {
                  Navigator.pop(context);
                  showTopSnackBar(
                    // ignore: use_build_context_synchronously
                    Overlay.of(context),
                    const CustomSnackBar.success(
                      message:
                          'Thanh toán thành công! Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi!',
                    ),
                    displayDuration: const Duration(seconds: 0),
                  );
                } else if (url != null &&
                    url.toString().contains("vnp_ResponseCode=24")) {
                  Navigator.pop(context);
                  showTopSnackBar(
                    // ignore: use_build_context_synchronously
                    Overlay.of(context),
                    const CustomSnackBar.error(
                      message:
                          'Thanh toán không thành công! Vui lòng thử lại sau!',
                    ),
                    displayDuration: const Duration(seconds: 0),
                  );
                }
              },
            ),
            _progress < 1
                ? LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        buttonBackgroundColor),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
