import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek/bloc/properties_bloc.dart';
import 'package:sleek/model/property_model.dart';
import 'package:sleek/screens/property_details_screen.dart';


class PropertiesScreen extends StatefulWidget {
  @override
  _PropertiesScreenState createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PropertiesBloc(dio: Dio())..add(FetchProperties()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Properties'),
          actions: [
            IconButton(
              icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
              onPressed: () {
                setState(() {
                  isGridView = !isGridView;
                });
              },
            ),
          ],
        ),
        body: BlocBuilder<PropertiesBloc, PropertiesState>(
          builder: (context, state) {
            if (state is PropertiesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PropertiesLoaded) {
              final properties = state.properties;
              return isGridView
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 2,
                      ),
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        return _buildPropertyCard(context, properties[index]);
                      },
                    )
                  : ListView.builder(
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        return _buildPropertyCard(context, properties[index]);
                      },
                    );
            } else if (state is PropertiesError) {
              return Center(child: Text(state.error));
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildPropertyCard(BuildContext context, Property property) {
    return GestureDetector(
      onTap: () {
       Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => PropertyDetailsScreen( property: property,)),
                      );
      },
      child: Card(
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            property.image != null
                ? Image.network(property.image!, height: 100, fit: BoxFit.cover)
                : SizedBox(height: 70, child: Placeholder()),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(property.name, style: TextStyle(fontSize: 13)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text('\$${property.cost.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
