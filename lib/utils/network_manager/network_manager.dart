import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetManager {
  InternetManager._internal();

  static final InternetManager _instance = InternetManager._internal();
  static InternetManager get instance => _instance;

  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityResult> _connectivityStreamController =
      StreamController<ConnectivityResult>.broadcast();

  /// Stream for listening to connectivity changes
  Stream<ConnectivityResult> get connectivityStream => _connectivityStreamController.stream;

  /// Initialize the network manager and set up a stream to continually check the connection status.
  void initialize() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Handle each result in the list
      final result = results.first;
      _connectivityStreamController.add(result);
    });
  }

  /// Check the internet connection status.
  Future<bool> isConnected() async {
    try {
      // Check basic connectivity
      final result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        return false;
      }

      // Verify actual internet access
      final lookup = await InternetAddress.lookup('google.com');
      if (lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty) {
        return true; // Internet is accessible
      } else {
        return false; // No internet access
      }
    } catch (e) {
      // If an exception occurs, assume no internet
      return false;
    }
  }

  ///auto-respond to online/offline
  Stream<bool> get isConnectedStream async* {
    await for (final result in connectivityStream) {
      yield result != ConnectivityResult.none;
    }
  }

  /// Dispose or close the active connectivity stream.
  void dispose() {
    _connectivityStreamController.close();
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
