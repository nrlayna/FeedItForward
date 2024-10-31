import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:na_hack/dashboardRec.dart';
import 'package:na_hack/inbox.dart';
import 'package:na_hack/profileRec.dart';
import 'package:na_hack/req_recepient.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FoodbankPage extends StatefulWidget {
  final String recId;

  const FoodbankPage({super.key, required this.recId});

  @override
  _FoodbankPage createState() => _FoodbankPage();
}

class _FoodbankPage extends State<FoodbankPage> {
  late GoogleMapController mapController;
  bool isLoading = true;

  CollectionReference rec = FirebaseFirestore.instance.collection('recepients');

  // Map center
  final LatLng _center = const LatLng(3.2795279, 102.0407285);

  // List of places with details and coordinates
  List<Map<String, dynamic>> _places = [];

  Set<Marker> _markers = Set<Marker>();
  Marker? _selectedMarker;

  @override
  void initState() {
    super.initState();
    fetchFoodbank(); // Fetch foodbank from Firestore on initialization
  }

  // Fetch foodbank from Firestore
  Future<void> fetchFoodbank() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('foodbank').get();

      // Map the documents to the places list
      setState(() {
        _places = snapshot.docs.map((doc) {
          return {
            'name': doc['name'],
            'description': doc['description'],
            'address': doc['address'],
            'position': LatLng(doc['latitude'], doc['longitude']),
          };
        }).toList();
        isLoading = false;
      });

      _setMarkers(); // Set markers after fetching places
    } on PlatformException catch (e) {
      print("PlatformException while fetching foodbanks: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching foodbanks: ${e.message}")),
      );
    } catch (e) {
      print("General error while fetching foodbanks: $e");
    }
  }

  // Set markers for each place
  void _setMarkers() {
    for (var place in _places) {
      _markers.add(
        Marker(
          markerId: MarkerId(place['name']),
          position: place['position'],
          onTap: () {
            _moveCameraToPlace(place['position']);
          },
          infoWindow: InfoWindow(
              title: place['name'],
              snippet: place['description'],
              onTap: () {
                _showPlaceDetails(place);
              }),
        ),
      );
    }
  }

  // Move camera to the specific marker with zoom and show its info window
  void _moveCameraToPlace(LatLng position) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 18.0, // Adjust the zoom level as needed
        ),
      ),
    );
    setState(() {
      _selectedMarker =
          _markers.firstWhere((marker) => marker.position == position);
    });
  }

  // Show details of the place in a dialog
  void _showPlaceDetails(Map<String, dynamic> place) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(place['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(place['description']),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _launchMaps(place['position']);
                },
                child: Text('Get Directions'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Open Google Maps to get directions to the selected place
  Future<void> _launchMaps(LatLng position) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${position.latitude},${position.longitude}';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } on PlatformException catch (e) {
      print("PlatformException while launching maps: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening maps: ${e.message}")),
      );
    } catch (e) {
      print("General error while launching maps: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Foodbank Location',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 17, 72, 84),
      ),
      body: isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: const Color.fromARGB(255, 17, 72, 84), // Customize color
                size: 50.0, // Customize size
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: ListTile(
                    title: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Foodbanks\n',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text:
                                'Check out foodbanks location in your area. Click on your\n'
                                'desired place to get your daily essential.',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      try {
                        mapController = controller;
                      } catch (e) {
                        print("Error creating map controller: $e");
                      }
                    },
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 5.0,
                    ),
                    markers: _markers,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: ListView.builder(
                      itemCount: _places.length,
                      itemBuilder: (context, index) {
                        var place = _places[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 3.0),
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 216, 216, 216),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: ListTile(
                            trailing: const Icon(Icons.location_pin,
                                color: Color.fromARGB(255, 0, 0, 0)),
                            title: Text(
                              place['name'], // Display the place name
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 0, 0, 0)),
                            ),
                            subtitle: Text(
                              place['address'], // Display the place description
                              style: TextStyle(
                                  fontSize: 16,
                                  color: const Color.fromARGB(255, 0, 0, 0)),
                            ),
                            onTap: () {
                              _moveCameraToPlace(place['position']);
                              _showPlaceDetails(place);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReqRcp(
                recId: widget.recId,
              ),
            ),
          );
          // Add action for the Floating Action Button
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 104, 144, 166),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: Color.fromARGB(255, 17, 72, 84),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DashboardRec(recId: widget.recId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.map, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FoodbankPage(
                        recId: widget.recId,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InboxPage(
                        recId: widget.recId,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        recId: widget.recId,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
