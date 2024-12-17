import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // For reverse geocoding
import 'package:connectivity_plus/connectivity_plus.dart'; // To check connectivity
import 'sync_manager.dart'; // Import SyncManager
import 'scan_page.dart';
import 'send_page.dart';
import 'transactions_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String _currentAddress = "Fetching location...";
  bool isSyncing = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _checkConnectivityAndSync(); // Check for connectivity and sync transactions
  }

  // Method to fetch the current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        _currentAddress = "Unable to fetch location";
      });
    }
  }

  // Method to check connectivity and trigger syncing if connected
  Future<void> _checkConnectivityAndSync() async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      // There's internet, so sync transactions
      await _syncTransactions();
    } else {
      // No internet connection, show a message if necessary
      print("No internet connection. Transactions will sync later.");
    }
  }

  // Sync transactions by calling SyncManager's syncTransactions method
  Future<void> _syncTransactions() async {
    setState(() {
      isSyncing = true;
    });
    try {
      await SyncManager.syncTransactions(); // Sync unsynced transactions
      print("Transactions synced successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transactions synchronized!')),
      );
    } catch (e) {
      print("Error syncing transactions: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sync transactions.')),
      );
    }
    setState(() {
      isSyncing = false;
    });
  }

  void _navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Pages for bottom navigation
  final List pages = [
    SendPage(),
    ScanPage(),
    TransactionsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(_currentAddress),
        title: const Text("Please Turn Off internet connection"),
        backgroundColor: Colors.blue,
        actions: [
          if (isSyncing) CircularProgressIndicator(),
        ],
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Send'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Scan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Transactions'),
        ],
      ),
    );
  }
}
