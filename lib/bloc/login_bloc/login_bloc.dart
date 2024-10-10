import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../model/user_model.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginInitialState()) {
    on<LoginUserState>((event, emit) async {
      //User box initialization
      Box<UserModel> userBox = Hive.box<UserModel>('users');

      //Firebase collection initialization
      CollectionReference loginCollection = FirebaseFirestore.instance.collection('login_details');
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

      await loginCollection
          .where("enrollment",
          isEqualTo: event.enrollmentController.text.toString())
          .where("password", isEqualTo: event.passwordController.text.toString())
          .get()
          .then((value) async {
        debugPrint ("Login Success: ${value.docs}");
        var userId = await usersCollection
            .where("enrollment",
            isEqualTo: event.enrollmentController.text
                .toString())
            .get();
        debugPrint("user: ${userId.size}");
        var user = await usersCollection
            .doc(userId.docs[0].id)
            .get();

        var userDetails = UserModel.fromJson(
            user.data() as Map<String, dynamic>);
        await userBox.put('user', userDetails).then((value) {
          emit(const LoginSuccessState());
        });
      }).catchError((e) {
        emit(const LoginErrorState());
      });
    });
  }
}

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

abstract class LoginState {
  const LoginState();
}

class LoginUserState extends LoginEvent {
  final TextEditingController enrollmentController;
  final TextEditingController passwordController;
  const LoginUserState(this.enrollmentController, this.passwordController);

  @override
  List<Object> get props => [enrollmentController, passwordController];
}

class LoginInitialState extends LoginState {
  const LoginInitialState();
}

class LoginSuccessState extends LoginState {
  const LoginSuccessState();
}

class LoginErrorState extends LoginState {
  const LoginErrorState();
}
