import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobilegram/providers/auth_provider.dart';
import 'package:mobilegram/services/cloud_storage_service.dart';
import 'package:mobilegram/services/db_service.dart';
import 'package:mobilegram/services/media_service.dart';
import 'package:provider/provider.dart';

import '../services/snackbar_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var auth;
  late double width;
  late double height;

  XFile? image;

  String _name = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: registerPageUI(),
      ),
    );
  }

  registerPageUI() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * .1),
      height: height * .75,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headingWidget(),
          inputForm(),
          registerButton(),
          backToLoginButton()
        ],
      ),
    );
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
            "Lets get going!",
            style: TextStyle(
              fontSize: height * .033,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            "Please enter your details",
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
      height: height * .35,
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
            imageSelectorWidget(),
            nameTextField(),
            emailTextField(),
            passwordTextField(),
          ],
        ),
      ),
    );
  }

  imageSelectorWidget() {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          var imageFile = await MediaService.instance.getImageFromGallery();
          setState(() {
            image = imageFile;
          });
        },
        child: Container(
          height: height * .1,
          width: width * .2,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            image: DecorationImage(
              image: image != null
                  ? FileImage(File(image!.path)) as ImageProvider
                  : const NetworkImage('https://i.pravatar.cc/150?img=64'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  nameTextField() {
    return TextFormField(
      autocorrect: false,
      style: const TextStyle(
        color: Colors.white,
      ),
      validator: (input) {
        return input!.isNotEmpty ? null : 'Enter your name';
      },
      onSaved: (input) {
        setState(() {
          _name = input!;
        });
      },
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: 'Name',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
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
        return input!.isNotEmpty && input.contains('@')
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

  registerButton() {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return SizedBox(
      height: height * .06,
      width: width,
      child: MaterialButton(
          onPressed: () {
            if (_formKey.currentState!.validate() && image != null) {
              auth.registerUserWithEmailAndPassword(
                _email,
                _password,
                (String uid) async {
                  print('uploading user data creating user...');
                  print('uuid is $uid');
                   await CloudStorageService.instance
                      .uploadUserImage(uid, File(image!.path));
                  await DBService.instance
                      .createUser(uid, _name, _email, image!.path);
                },
              );
              Navigator.pushReplacementNamed(context, 'home');
            }
          },
          color: Colors.blue,
          child: const Text(
            'Register',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          )),
    );
  }

  backToLoginButton() {
    return SizedBox(
      height: height * .06,
      width: width,
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }
}
