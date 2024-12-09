import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek/events/login_event.dart';
import 'package:sleek/state/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Dio dio;

  LoginBloc({required this.dio}) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        final response = await dio.post(
          'https://5f82-41-215-113-146.ngrok-free.app/api/login',
          data: {
            'email': event.email,
            'password': event.password,
          },
        );
        

        final token = response.data['token'];
        final name = response.data['user']['first_name']; 

    
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          print(response);
       

        emit(LoginSuccess(token, name));
      } catch (e) {
        emit(LoginFailure(
            'Failed to login. Please try again....' + e.toString()));
      }
    });
  }
}
