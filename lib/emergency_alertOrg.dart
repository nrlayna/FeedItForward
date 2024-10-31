import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:na_hack/dashboardOrg.dart';
import 'package:na_hack/inbox_org.dart';
import 'package:na_hack/req_organization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'profileOrg.dart';

class EmergencyAlertOrgPage extends StatefulWidget {
  final String orgId;

  const EmergencyAlertOrgPage({super.key, required this.orgId});

  @override
  _EmergencyAlertOrgPage createState() => _EmergencyAlertOrgPage();
}

class _EmergencyAlertOrgPage extends State<EmergencyAlertOrgPage> {
  late GoogleMapController mapController;
  bool isLoading = true;

  CollectionReference organizations =
      FirebaseFirestore.instance.collection('organizations');

  // Map center
  final LatLng _center = const LatLng(2.9914684, 101.6992673);

  // List of places with details and coordinates
  List<Map<String, dynamic>> _places = [];

  Set<Marker> _markers = Set<Marker>();
  Marker? _selectedMarker;

  @override
  void initState() {
    super.initState();
    fetchEmergencyLocation();
  }

  Future<void> fetchEmergencyLocation() async {
    try {
      // Fetch only documents where status is 'needed'
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('emergency_alert')
          .where('status', isEqualTo: 'needed')
          .get();

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
    } catch (e) {
      print("Error fetching emergency location: $e");
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _launchMaps(place['position']);
                },
                child: const Text('Get Directions'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
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
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency Alert',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color.fromARGB(255, 17, 72, 84),
      ),
      body: isLoading
          ? const Center(
              child: SpinKitFadingCircle(
                color: Color.fromARGB(255, 17, 72, 84), // Customize color
                size: 50.0, // Customize size
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    title: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Emergency Alert\n',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text:
                                'These locations indictes donation needed due to\n'
                                'emergency incidents!',
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
                      mapController = controller;
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: ListView.builder(
                      itemCount: _places.length,
                      itemBuilder: (context, index) {
                        var place = _places[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 3.0),
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 216, 216, 216),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: ListTile(
                            trailing: const Icon(Icons.location_pin,
                                color: Color.fromARGB(255, 0, 0, 0)),
                            title: Text(
                              place['name'], // Display the place name
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                            subtitle: Text(
                              place['address'], // Display the place description
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 0, 0, 0)),
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
              builder: (context) => ReqOrg(organizationId: widget.orgId),
            ),
          );
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
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          DashboardOrg(organizationId: widget.orgId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.map, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EmergencyAlertOrgPage(
                        orgId: widget.orgId,
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
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InboxOrgPage(orgId: widget.orgId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  // Implement your action for the profile button here
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileOrgPage(
                        documentId: widget.orgId,
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
