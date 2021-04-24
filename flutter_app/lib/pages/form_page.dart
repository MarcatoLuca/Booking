import 'package:booking/cubit/user/user_cubit.dart';
import 'package:flutter/material.dart';

import 'package:booking/data/server_socket.dart';

import 'package:booking/data/db/app_database.dart';

import 'package:booking/data/model/user.dart';

class FormPage extends StatefulWidget {
  final AppDatabase appDatabase;
  final ServerSocket socket;
  final UserCubit userCubit;

  const FormPage({Key key, this.appDatabase, this.socket, this.userCubit})
      : super(key: key);

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
  User user = new User(id: 1);

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
                user.email = value;
                if (user.isValid()) {
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
              } else {
                user.crypt(value);
              }
              return null;
            },
          ),
          isThreeLine: true,
        ),
      )
    ];
  }

  void updateForm() {
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: viewportConstraints.maxHeight,
        ),
        child: IntrinsicHeight(child: buildBody()),
      ));
    });
  }

  Widget buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [buildTitle(), buildForm(), buildFormButtons()],
    );
  }

  Widget buildTitle() {
    return Container(
        height: 150,
        child: Center(
            child: Container(
                child: Text(
          "Benvenuto",
          style: TextStyle(fontSize: 30, color: Colors.blue),
        ))));
  }

  Widget buildForm() {
    return ClipRRect(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }

  Widget buildFormButtons() {
    return Expanded(
        child: ClipRRect(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  if (state) {
                    //SIGNUP
                    user.save(
                        widget.socket, widget.appDatabase, widget.userCubit);
                  } else {
                    //LOGIN
                    user.login(
                        widget.socket, widget.appDatabase, widget.userCubit);
                  }
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
    ));
  }
}
