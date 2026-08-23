import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiveChatView extends StatefulWidget {
  const LiveChatView({Key? key}) : super(key: key);

  @override
  State<LiveChatView> createState() => _LiveChatViewState();
}

class _LiveChatViewState extends State<LiveChatView> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Get.theme.hintColor),
        title: Text(
          "Chat with Support".tr,
          style: Get.textTheme.titleLarge?.merge(
              TextStyle(letterSpacing: 1.3, color: Get.theme.hintColor)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'https://tawk.to/chat/6a8aa3f3b56df5344af1cfd6/1k0mp0ruj',
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (_) => setState(() => _loading = false),
          ),
          if (_loading)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Get.theme.colorScheme.secondary),
                  SizedBox(height: 16),
                  Text('Connecting...', style: Get.textTheme.bodySmall),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
