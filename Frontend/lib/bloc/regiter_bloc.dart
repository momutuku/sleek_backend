import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek/events/register_event.dart';
import 'package:sleek/state/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final Dio dio;

  RegisterBloc({required this.dio}) : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());

      // Validate passwords match
      if (event.password != event.confirmPassword) {
        emit(RegisterFailure('Passwords do not match.'));
        return;
      }

      try {
        final response = await dio.post(
          'https://5f82-41-215-113-146.ngrok-free.app/api/register',
          data: {
            'email': event.email,
            'first_name': event.firstName,
            'last_name': event.lastName,
            'address': event.address,
            'password': event.password,
            'password_confirmation': event.confirmPassword,
          },
        );

        final token = response.data['token'];

        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        

        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure('Registration failed. Please try again.'));
      }
    });
  }
}
