import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/database/firebase_utils.dart';
import '../../../my_theme.dart';
import '../../../validation_utils.dart';
import '../../components/custom_form_field.dart';
import '../../dialog_utils.dart';
import '../../home/home_screen.dart';
import '../../home/providers/auth_provider.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

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
                      height: MediaQuery.of(context).
                      size.height * .3,
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.
                            symmetric(vertical: 14)),
                        onPressed: () {
                          login();
                        },
                        child:Text(
                          'Login',
                          style: Theme.of(context).
                          textTheme.titleLarge,
                        )
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).
                      size.height * .1,
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
                              RegisterScreen.routeName);
                        },
                          child:Text(
                            "SignUp",
                          style: Theme.of(context).
                          textTheme.titleMedium!.copyWith(
                              color: Theme.of(context).primaryColor
                          ),
                        ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void login() async{
    if(formKey.currentState?.validate() == true){
      // todo : login with firebase auth
      DialogUtils.showLoadingDialog(context,"Loading...");
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
        var user = await FirebaseUtils.
        getUserFromFireStore(credential.user?.uid??'');
        if(user==null){
          DialogUtils.hideDialog(context);
          return;
        }
        var authProvider =
        Provider.of<AuthenticationProvider>(context,listen: false);
        authProvider.updateUser(user);
        DialogUtils.hideDialog(context);
        DialogUtils.showMessage(context,
            "Login Successfully",
            title: "Success",
            postActionName: "OK",
          posAction: () {
            Navigator.of(context).
            pushReplacementNamed(HomeScreen.routeName);
          },);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          DialogUtils.hideDialog(context);
          DialogUtils.showMessage(context,
              "No user found for that email.",
              title: "Error",
              postActionName: "OK");
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          DialogUtils.hideDialog(context);
          DialogUtils.showMessage(context,
              "Wrong password provided for that user.",
              title: "Error",
              postActionName: "OK");
          print('Wrong password provided for that user.');
        }
      }catch (e){
        DialogUtils.hideDialog(context);
        DialogUtils.showMessage(context,
            "${e.toString()}",
            title: "Error",
            postActionName: "OK");
        print(e.toString());
      }
    }
  }
}
