// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const CaduceoWebView({super.key});

  @override
  State<CaduceoWebView> createState() => _CaduceoWebViewState();
}

class _CaduceoWebViewState extends State<CaduceoWebView> {
  InAppWebViewController? webViewController;
  bool isLoading = true;

  // Función para abrir URLs en navegador del sistema
  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: 'No se puede abrir la URL: $url',
            library: 'CaduceoWebView',
            context: ErrorDescription(
              'Se intentó abrir una URL externa desde la WebView.',
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: stackTrace,
          library: 'CaduceoWebView',
          context: ErrorDescription(
            'Error al abrir una URL externa desde la WebView.',
          ),
        ),
      );
    }
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
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri('https://caduceo.bo/'),
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url;
              if (!["http", "https", "file", "blob"].contains(uri?.scheme) && uri != null) {
                await _launchUrl(uri.toString());
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
              ),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
              ),
            ),
          ), // ← SOLO UN PARÉNTESIS AQUÍ
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}