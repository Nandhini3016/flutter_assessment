import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../data/local_db.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<UserModel> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Try remote first
    try {
      final res = await http.get(Uri.parse('https://reqres.in/api/users?per_page=12'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final List<UserModel> fetched = (data['data'] as List).map((e) => UserModel.fromJson(e)).toList();
        setState(() { users = fetched; loading = false; });
        await LocalDb.saveUsers(fetched);
        return;
      }
    } catch (e) {
      // ignore network errors to fall back to cache
    }
    // fallback to cache
    final cached = await LocalDb.getCachedUsers();
    setState(() { users = cached; loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users'), actions: [
        IconButton(icon: Icon(Icons.videocam), onPressed: ()=> Navigator.pushNamed(context, '/video')),
      ]),
      body: loading ? Center(child:CircularProgressIndicator()) :
      users.isEmpty ? Center(child:Text('No users found')) :
      RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (c,i){
            final u = users[i];
            return ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(u.avatar)),
              title: Text('${u.firstName} ${u.lastName}'),
              subtitle: Text('ID: ${u.id}'),
            );
          },
        ),
      ),
    );
  }
}
