import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caduceo BO',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CaduceoWebView(),
    );
  }
}

class CaduceoWebView extends StatefulWidget {
  const CaduceoWebView({Key? key}) : super(key: key);

  @override
  State<CaduceoWebView> createState() => _CaduceoWebViewState();
}

class _CaduceoWebViewState extends State<CaduceoWebView> {
  late WebViewController _webViewController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        )
      )
        ..loadRequest(Uri.parse('https://caduceo.bo/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caduceo - Mi Recorrido en Salud'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      )
    );
  }
}