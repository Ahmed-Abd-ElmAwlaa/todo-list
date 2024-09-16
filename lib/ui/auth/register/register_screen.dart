import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/database/model/my_user.dart';
import 'package:todo_list/firebase_utils.dart';
import 'package:todo_list/my_theme.dart';
import 'package:todo_list/ui/dialog_utils.dart';
import '../../../validation_utils.dart';
import '../../components/custom_form_field.dart';
import '../../home/home_screen.dart';
import '../login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'Register';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();

  var nameController =
  TextEditingController();
  //TextEditingController(text: 'Ahmed');

  var emailController =
  TextEditingController();
  //TextEditingController(text: 'ahmed@route.com');

  var passwordController =
  TextEditingController();
  //TextEditingController(text: '123456');

  var passwordConfirmationController =
  TextEditingController();
  //TextEditingController(text: '123456');

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:BoxDecoration(
          color:MyTheme.backgroundLight,
          image: const DecorationImage(
              image: AssetImage('assets/images/auth_pattern.png'),
              fit: BoxFit.fill),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height:
                      MediaQuery.of(context).
                      size.height * .3,
                    ),
                    CustomFormField(
                      controller: nameController,
                      label: 'Full Name',
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'please enter full name';
                        }
                      },
                    ),
                    CustomFormField(
                      controller: emailController,
                      label: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'please enter email';
                        }
                        if(!ValidationUtils.isValidEmail(text)){
                          return 'please enter a valid email';
                        }
                      },
                    ),
                    CustomFormField(
                      controller: passwordController,
                      label: 'Password',
                      keyboardType: TextInputType.text,
                      isPassword: true,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'please enter password';
                        }
                        if (text.length < 6) {
                          return 'password should at least 6 chars';
                        }
                      },
                    ),
                    CustomFormField(
                        controller: passwordConfirmationController,
                        label: 'Password Confirmation',
                        keyboardType: TextInputType.text,
                        isPassword: true,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter password-confirmation';
                          }
                          if (passwordController.text != text) {
                            return "password doesn't match";
                          }
                        }),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const
                            EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          register();
                        },
                        child:Text(
                          'Register',
                          style:Theme.of(context).
                          textTheme.titleLarge,
                        ),
                    ),
                    const SizedBox(
                      height:12
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "Don't Have Account?",
                            style: Theme.of(context).
                            textTheme.titleMedium
                        ),
                        const SizedBox(width: 8,),
                        TextButton(
                          onPressed: (){
                            Navigator.pushReplacementNamed(context,
                                LoginScreen.routeName);
                          },
                          child:Text(
                            "Login",
                            style: Theme.of(context).
                            textTheme.titleMedium!.copyWith(
                                color: Theme.of(context).primaryColor
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  void register() async{
    if(formKey.currentState?.validate() == true){
      // todo :register with firebase auth
      DialogUtils.showLoadingDialog(context,"Loading...");
      try {
        final credential = await FirebaseAuth.instance.
        createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        MyUser myUser =MyUser(id:credential.user?.uid??'',
            name: nameController.text,
            email: emailController.text);
       await FirebaseUtils.addUserToFireStore(myUser);

        DialogUtils.hideDialog(context);
        DialogUtils.showMessage(context,
            "Register Successfully",
            title: "Success",
        postActionName: "OK",
          posAction: () {
            Navigator.of(context).
            pushReplacementNamed(LoginScreen.routeName);
          },);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          DialogUtils.hideDialog(context);
          DialogUtils.showMessage(context,
              "The password provided is too weak.",
              title: "Error",
              postActionName: "OK");
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideDialog(context);
          DialogUtils.showMessage(context,
              "The account already exists for that email.",
              title: "Error",
              postActionName: "OK");
          print('The account already exists for that email.');
        }
      } catch (e) {
        DialogUtils.hideDialog(context);
        DialogUtils.showMessage(context,
            "${e.toString()}",
            title: "Error",
            postActionName: "OK");
        print(e);
      }
    }
  }
}
