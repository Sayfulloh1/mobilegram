import 'package:flutter/material.dart';
import 'package:mobilegram/providers/auth_provider.dart';
import 'package:mobilegram/services/snackbar_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AuthProvider auth;

  late double width;
  late double height;

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Align(
        alignment: Alignment.center,
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: loginPageUI(),
        ),
      ),
    );
  }

  loginPageUI() {
    print(_email);
    print(_password);
    return Builder(builder: (context) {
      auth = Provider.of<AuthProvider>(context);

      return Container(
        padding: EdgeInsets.symmetric(horizontal: width * .1),
        height: height * .6,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headingWidget(),
            inputForm(),
            loginButton(),
            registerButton(),
          ],
        ),
      );
    });
  }

  headingWidget() {
    return Container(
      // height: height * .12,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome back!",
            style: TextStyle(
              fontSize: height * .033,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            "Please login to your account",
            style: TextStyle(
                fontSize: height * .022,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }

  inputForm() {
    return Container(
      height: height * .16,
      child: Form(
        onChanged: () {
          _formKey.currentState!.save();
        },
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            emailTextField(),
            passwordTextField(),
          ],
        ),
      ),
    );
  }

  emailTextField() {
    return TextFormField(
      autocorrect: false,
      style: const TextStyle(
        color: Colors.white,
      ),
      validator: (input) {
        return input!.length != 0 && input!.contains('@')
            ? null
            : 'Enter valid email';
      },
      onSaved: (input) {
        setState(() {
          _email = input!;
        });
      },
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: 'Email address',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  passwordTextField() {
    return TextFormField(
      autocorrect: false,
      obscureText: true,
      style: const TextStyle(
        color: Colors.white,
      ),
      validator: (input) {
        return input!.isNotEmpty ? null : 'Please enter a password';
      },
      onSaved: (input) {
        setState(() {
          _password = input!;
        });
      },
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: 'Password',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  loginButton() {
    return Container(
      height: height * .06,
      width: width,
      child: MaterialButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            auth.loginUserWithEmailAndPassword(_email, _password);
            print(auth.isAuthenticated);
            if(auth.isAuthenticated ==true){
              Navigator.pushReplacementNamed(context, 'home');
            }


          }
        },
        color: Colors.blue,
        child: const Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  registerButton() {
    return Container(
      width: width,
      height: height * .06,
      child: TextButton(
        onPressed: () {
          print('navigating to register');
         /* NavigationService.instance.navigateTo('register');*/
          Navigator.pushNamed(context, 'register');
        },
        child: const Text(
          'REGISTER',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white60),
        ),
      ),
    );
  }
}
