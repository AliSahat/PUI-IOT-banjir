import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0xFF303030))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {},
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse('https://banjirai.vercel.app'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF303030),
        body: Column(
          children: [
            Container(
              height: 56, // AppBar manual tinggi
              color: const Color(0xFF303030),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Chat AI",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      _controller.reload();
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white24),
            Expanded(child: WebViewWidget(controller: _controller)),
          ],
        ),
      ),
    );
  }
}
