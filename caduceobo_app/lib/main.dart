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
  bool canGoBack = false;

  // Función para abrir URLs en navegador del sistema
  Future<void> _launchExternalUrl(String urlString) async {
    try {
      final uri = Uri.parse(urlString);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('No se pudo abrir: $urlString');
      }
    } catch (e) {
      debugPrint('Error al abrir URL: $e');
    }
  }

  // Verificar si se puede ir hacia atrás
  Future<void> _checkCanGoBack() async {
    final canBack = await webViewController?.canGoBack() ?? false;
    setState(() {
      canGoBack = canBack;
    });
  }

  // Ir hacia atrás
  Future<void> _goBack() async {
    if (await webViewController?.canGoBack() ?? false) {
      await webViewController?.goBack();
      await _checkCanGoBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Intercepta el botón back del dispositivo
      onWillPop: () async {
        if (canGoBack) {
          await _goBack();
          return false; // No cierre la app, solo ve atrás
        }
        return true; // Cierra la app si no hay páginas anteriores
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Caduceo - Mi Recorrido en Salud'),
          elevation: 0,
          // Botón "Atrás" solo visible si se puede navegar hacia atrás
          leading: canGoBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goBack,
                )
              : null,
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
              onLoadStop: (controller, url) async {
                setState(() {
                  isLoading = false;
                });
                // Verifica si se puede ir hacia atrás después de cargar
                await _checkCanGoBack();
              },
              // INTERCEPTA TODOS LOS ENLACES ANTES DE CARGAR
              shouldOverrideUrlLoading:
                  (controller, navigationAction) async {
                final uri = navigationAction.request.url;

                if (uri == null) {
                  return NavigationActionPolicy.ALLOW;
                }

                final scheme = uri.scheme;

                // Si es http o https, carga normalmente en WebView
                if (scheme == 'http' || scheme == 'https') {
                  return NavigationActionPolicy.ALLOW;
                }

                // Si es otro esquema (fb://, tel://, mailto://, etc)
                // Abre en navegador/app del sistema
                await _launchExternalUrl(uri.toString());
                return NavigationActionPolicy.CANCEL;
              },
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  // ← ESTO ES CRÍTICO: Activa el interceptor
                  useShouldOverrideUrlLoading: true,
                ),
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                  mixedContentMode:
                      AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                ),
              ),
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}