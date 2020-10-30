import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:firebase_crud_ap/src/bloc/validators.dart';

class LoginBloc with Validators {
  /*
  final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();
*/
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //get value of Stream

  Stream<String> get emailStream =>
      _emailController.stream.transform(emailValidator);

  Stream<String> get passwordStream =>
      _passwordController.stream.transform(passwordValidator);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  //add values to Stream
  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  //get the last value entered from streams

  String get email => _emailController.value;

  String get password => _passwordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
