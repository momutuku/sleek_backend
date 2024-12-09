import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek/bloc/properties_bloc.dart';
import 'package:sleek/model/property_model.dart';
import 'package:sleek/screens/add_property_screen.dart';
import 'package:sleek/screens/edit_property_screen.dart';

import 'package:sleek/screens/login_screen.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final Property property;

  const PropertyDetailsScreen({Key? key, required this.property})
      : super(key: key);

  Future<bool> _isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token'); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.name),
        actions: [
          FutureBuilder<bool>(
            future: _isUserLoggedIn(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink(); 
              }

              final isLoggedIn = snapshot.data!;

              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Edit') {
                    _navigateToEditProperty(context, property);
                  } else if (value == 'Delete') {
                    _deleteProperty(context);
                  }else if (value == 'Add') {
                    _navigateToAddProperty(context);
                  } else if (value == 'Login') {
                    _navigateToLoginScreen(context);
                  }
                },
                itemBuilder: (context) => isLoggedIn
                    ? [
                        PopupMenuItem(value: 'Add', child: Text('Add')),
                        PopupMenuItem(value: 'Edit', child: Text('Edit')),
                        PopupMenuItem(value: 'Delete', child: Text('Delete')),
                      ]
                    : [
                        PopupMenuItem(value: 'Login', child: Text('Login')),
                      ],
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                property.image != null
                    ? Image.network(property.image!, fit: BoxFit.cover)
                    : SizedBox(height: 200, child: Placeholder()),
                const SizedBox(height: 16),
                Text(
                  property.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Location: ${property.location}",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  "Cost: \$${property.cost.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  "Description",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(property.description),
                const SizedBox(height: 16),
                Text(
                  "Amenities",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(property.amenities),
                const SizedBox(height: 16),
                Text(
                  "Owner Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("Name: ${property.owner.firstName} ${property.owner.lastName}"),
                const SizedBox(height: 4),
                Text("Email: ${property.owner.email}"),
                const SizedBox(height: 16),
                Text(
                  "Images",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                property.images.isNotEmpty
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: property.images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.network(
                                property.images[index].imageUrl,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      )
                    : Text("No additional images available."),
                const SizedBox(height: 50),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.extended(
              onPressed: () => _contactOwner(context),
              icon: Icon(Icons.contact_mail),
              label: Text("Contact Owner"),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditProperty(BuildContext context, Property property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPropertyScreen(property: property),
      ),
    );
  }
  
    void _navigateToAddProperty(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPropertyScreen(),
      ),
    );
  }

  void _deleteProperty(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Delete Property'),
      content: Text('Are you sure you want to delete this property?'),
      actions: [
        TextButton(
           onPressed: () {
            
            context.read<PropertiesBloc>().add(DeleteProperty(property.id));

            
            Navigator.pop(context);
            Navigator.pop(context); 
          },
          
          
          child: Text('Delete'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
         child: Text('Cancel'),
        ),
      ],
    ),
  );
}


  void _contactOwner(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Contacting ${property.owner.email}...'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
