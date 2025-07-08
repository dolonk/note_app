import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetManager {
  static final instance = InternetManager._();

  final _controller = StreamController<bool>.broadcast();
  bool _isConnected = false;

  InternetManager._() {
    Connectivity().onConnectivityChanged.listen((result) async {
      final isNowConnected = await _checkConnection();
      if (isNowConnected != _isConnected) {
        _isConnected = isNowConnected;
        _controller.add(_isConnected);
        debugPrint("📶 Internet status changed: $_isConnected");
      }
    });

    // Initialize
    _checkConnection().then((value) {
      _isConnected = value;
      _controller.add(_isConnected);
    });
  }

  Stream<bool> get isConnectedStream => _controller.stream;

  Future<bool> isConnected() => _checkConnection();

  Future<bool> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

class NoInternetWidget extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onRetry;
  final bool isLoading;

  const NoInternetWidget({
    super.key,
    required this.width,
    required this.height,
    required this.onRetry,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            "No Internet Connection",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          const Text(
            "Please check your connection or try again.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black45),
          ),
          const SizedBox(height: 24),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
        ],
      ),
    );
  }
}
