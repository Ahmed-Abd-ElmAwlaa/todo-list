import 'package:flutter/material.dart';
import 'package:todo_list/database/model/my_user.dart';

class AuthenticationProvider extends ChangeNotifier{
  MyUser? currentUser;
    void updateUser(MyUser newUser){
    currentUser=newUser;
    notifyListeners();
  }
}