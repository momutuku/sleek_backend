import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek/model/property_model.dart';

abstract class PropertiesEvent {}

class FetchProperties extends PropertiesEvent {}

class AddProperty extends PropertiesEvent {
  final Map<String, dynamic> propertyData;

  AddProperty(this.propertyData);
}

class EditProperty extends PropertiesEvent {
  final int propertyId;
  final Map<String, dynamic> propertyData;

  EditProperty(this.propertyId, this.propertyData);
}

class DeleteProperty extends PropertiesEvent {
  final int propertyId;

  DeleteProperty(this.propertyId);
}

abstract class PropertiesState {}

class PropertiesInitial extends PropertiesState {}

class PropertiesLoading extends PropertiesState {}

class PropertiesLoaded extends PropertiesState {
  final List<Property> properties;

  PropertiesLoaded(this.properties);
}

class PropertiesError extends PropertiesState {
  final String error;

  PropertiesError(this.error);
}

class PropertiesBloc extends Bloc<PropertiesEvent, PropertiesState> {
  final Dio dio;

  PropertiesBloc({required this.dio}) : super(PropertiesInitial()) {
    on<FetchProperties>(_onFetchProperties);
    on<AddProperty>(_onAddProperty);
    on<EditProperty>(_onEditProperty);
    on<DeleteProperty>(_onDeleteProperty);
  }

  Future<void> _onFetchProperties(
      FetchProperties event, Emitter<PropertiesState> emit) async {
    emit(PropertiesLoading());
    try {
      final response = await dio.get('https://5f82-41-215-113-146.ngrok-free.app/api/properties');
      final List<Property> properties = (response.data as List)
          .map((propertyJson) => Property.fromJson(propertyJson))
          .toList();
      emit(PropertiesLoaded(properties));
    } catch (e) {
      emit(PropertiesError('Failed to load properties'));
    }
  }

  Future<void> _onAddProperty(
      AddProperty event, Emitter<PropertiesState> emit) async {
    try {
      await dio.post('https://5f82-41-215-113-146.ngrok-free.app/api/properties/add', data: event.propertyData);
      add(FetchProperties());
    } catch (e) {
      emit(PropertiesError('Failed to add property'));
    }
  }

  Future<void> _onEditProperty(
      EditProperty event, Emitter<PropertiesState> emit) async {
    try {
      await dio.put('https://5f82-41-215-113-146.ngrok-free.app/api/properties/${event.propertyId}', data: event.propertyData);
      add(FetchProperties());
    } catch (e) {
      emit(PropertiesError('Failed to edit property'));
    }
  }

 Future<void> _onDeleteProperty(
    DeleteProperty event, Emitter<PropertiesState> emit) async {
  try {
   
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');

    if (token == null || token.isEmpty) {
      emit(PropertiesError('User is not authenticated'));
      return;
    }

    final response = await dio.delete(
      'https://5f82-41-215-113-146.ngrok-free.app/api/properties/${event.propertyId}',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );


    if (response.statusCode == 200) {
      add(FetchProperties());
    } else {
      emit(PropertiesError('Failed to delete property: ${response.statusMessage}'));
    }
  } catch (e) {
    emit(PropertiesError('Failed to delete property: $e'));
  }
}

}
