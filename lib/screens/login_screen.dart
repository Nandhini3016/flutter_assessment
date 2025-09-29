import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool loading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    // Mock authentication: accept email "test@reqres.in" and password "password"
    await Future.delayed(Duration(seconds: 1));
    if (_emailController.text.trim() == 'test@reqres.in' &&
        _passController.text == 'password') {
      Navigator.pushReplacementNamed(context, '/users');
    } else {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials. Use test@reqres.in / password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v==null || v.isEmpty) return 'Please enter email';
                  if (!v.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _passController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => v==null || v.isEmpty ? 'Please enter password' : null,
              ),
              SizedBox(height: 20),
              loading ? CircularProgressIndicator() :
              ElevatedButton(onPressed: _login, child: Text('Login')),
              SizedBox(height: 12),
              Text('Use: test@reqres.in / password', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
