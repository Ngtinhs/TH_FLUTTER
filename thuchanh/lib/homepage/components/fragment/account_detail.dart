import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDetail extends StatefulWidget {
  const AccountDetail({Key? key}) : super(key: key);

  @override
  _AccountDetailState createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  late String username;
  late String password;
  late String fullname;
  late String image;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      password = prefs.getString('password') ?? '';
      fullname = prefs.getString('fullname') ?? '';
      image = prefs.getString('image') ?? '';
    });
  }

  Future<void> _editAccount(BuildContext context) async {
    TextEditingController fullnameController =
        TextEditingController(text: fullname);
    TextEditingController imageController = TextEditingController(text: image);
    TextEditingController usernameController =
        TextEditingController(text: username);
    TextEditingController passwordController =
        TextEditingController(text: password);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: fullnameController,
                decoration: const InputDecoration(
                  labelText: 'fullname',
                ),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: 'image',
                ),
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('username', usernameController.text);
                prefs.setString('password', passwordController.text);
                prefs.setString('fullname', fullnameController.text);
                prefs.setString('image', imageController.text);
                setState(() {
                  username = usernameController.text;
                  password = passwordController.text;
                  fullname = fullnameController.text;
                  image = imageController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Fullname'),
            subtitle: Text(fullname),
          ),
          ListTile(
            title: const Text('Image'),
            subtitle: Text(image),
          ),
          ListTile(
            title: const Text('Username'),
            subtitle: Text(username),
          ),
          ListTile(
            title: const Text('Password'),
            subtitle: Text(password),
          ),
          ElevatedButton(
            onPressed: () {
              _editAccount(context);
            },
            child: const Text('Edit Account'),
          ),
        ],
      ),
    );
  }
}
