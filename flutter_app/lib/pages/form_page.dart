import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';

import 'package:booking/data/app_database.dart';

class FormPage extends StatefulWidget {
  final AppDatabase appDatabase;

  const FormPage({Key key, this.appDatabase}) : super(key: key);

  @override
  _FormPage createState() => _FormPage();
}

class _FormPage extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordSecureController =
      TextEditingController();
  bool state = false;
  List<Widget> form;

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: Colors.blue,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  @override
  void initState() {
    super.initState();
    initForm();
  }

  void initForm() {
    form = [
      Card(
        child: ListTile(
          title: Text(
            'Email',
            style: TextStyle(color: Colors.blue),
          ),
          subtitle: TextFormField(
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else {
                if (checkEmail(value)) {
                  return 'Invalid email';
                }
              }
              return null;
            },
          ),
          isThreeLine: true,
        ),
      ),
      Card(
        child: ListTile(
          title: Text(
            'Password',
            style: TextStyle(color: Colors.blue),
          ),
          subtitle: TextFormField(
            obscureText: true,
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          isThreeLine: true,
        ),
      )
    ];
  }

  updateForm() {
    state = !state;
    if (form.length == 2) {
      form.add(
        Card(
          child: ListTile(
            title: Text(
              'Password',
              style: TextStyle(color: Colors.blue),
            ),
            subtitle: TextFormField(
              obscureText: true,
              controller: passwordSecureController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else {
                  if (value != passwordController.text) {
                    return 'The password doesn\'t match!';
                  }
                }
                return null;
              },
            ),
            isThreeLine: true,
          ),
        ),
      );
    } else {
      form.removeAt(2);
    }
  }

  bool checkEmail(String email) {
    return !RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@itiszuccante.edu.it")
        .hasMatch(email);
  }

  void validateLogin(String email, String plainPassowrd) {
    final cryptedPassword = Crypt.sha256(plainPassowrd);
    //TODO
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: viewportConstraints.maxHeight,
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  height: 150,
                  child: Center(
                      child: Container(
                          child: Text(
                    "Benvenuto",
                    style: TextStyle(fontSize: 30, color: Colors.blue),
                  )))),
              ClipRRect(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: form,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ClipRRect(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            //false -> LOGIN
                            if (state) {
                              validateLogin(emailController.text,
                                  passwordController.text);
                            } else {
                              //checkAndSaveUser();
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Loading..")));
                          }
                        },
                        child: Text("SUBMIT")),
                    Divider(
                      indent: 130,
                      endIndent: 130,
                    ),
                    ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () {
                          setState(() {
                            _formKey.currentState.reset();
                            updateForm();
                          });
                        },
                        child: Text(state ? "LOGIN" : "SIGNUP")),
                    Text(
                      state
                          ? "Clicca qui per accedere"
                          : "Clicca qui per registrare un nuovo account",
                      style: TextStyle(color: Colors.grey[800], fontSize: 13),
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ));
    });
  }
}
