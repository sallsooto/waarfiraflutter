import 'package:waarfira/core/util/MyAppColors.dart';
import 'package:waarfira/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppDrawer extends StatelessWidget {
  final storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _drawerHeader(),
          _createDrawerItem(
              icon: Icons.home,
              text: 'Accueil',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.home)),
          _createDrawerItem(
              icon: Icons.logout,
              text: 'Déconnexion',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.logout)),
          /*ListTile(
              title: Row(
                children: <Widget>[
                  FlatButton(
                    child: Text('Logout'),
                    onPressed: () async {
                      storage.delete(key: 'token');
                      storage.delete(key: 'userDetails');
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MyApp()
                      ));
                    },
                  ),
                ],
              ),
            )*/
        ],
      ),
    );
  }

  Widget _drawerHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/logo.png'),
            alignment: Alignment.center,
          ),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
