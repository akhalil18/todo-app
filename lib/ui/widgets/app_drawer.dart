import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/providers/theme_provider.dart';

import '../../core/models/user.dart';
import '../../core/providers/auth_provier.dart';
import '../../core/providers/tasks_provider.dart';
import '../../core/routes/routing_constants.dart';

class AppDrawer extends StatelessWidget {
  final User currentUser;
  AppDrawer(this.currentUser);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            buildHeader(context),
            buildBody(context),
            buildFooter(context),
          ],
        ),
      ),
    );
  }

  DrawerHeader buildHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(currentUser.photoUrl),
            radius: 30,
          ),
          SizedBox(width: 15.0),
          Flexible(
            child: Text(
              currentUser.displayName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Container buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
            },
            leading: Icon(Icons.calendar_today, color: Colors.green),
            title: Text('Task'),
            trailing: Consumer<TasksProvider>(
                builder: (context, provider, ch) =>
                    Text(provider.finishedTasks)),
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, ch) => ExpansionTile(
              leading: Icon(Icons.color_lens, color: Colors.red[300]),
              title: Text('Theme'),
              children: <Widget>[
                buildItemTile(
                  selected: !themeProvider.isDark,
                  title: 'Light Theme',
                  trailing: !themeProvider.isDark ? Icon(Icons.check) : null,
                  icon: Icons.brightness_high,
                  onTab: () => themeProvider.changeTheme(AppTheme.LightTheme),
                ),
                buildItemTile(
                  title: 'Dark Theme',
                  icon: Icons.brightness_3,
                  onTab: () => themeProvider.changeTheme(AppTheme.DarkTheme),
                  selected: themeProvider.isDark,
                  trailing: themeProvider.isDark ? Icon(Icons.check) : null,
                ),
              ],
            ),
          ),
          Divider(height: 0),
        ],
      ),
    );
  }

  ListTile buildItemTile({
    IconData icon,
    Widget trailing,
    String title,
    Function onTab,
    bool selected,
  }) {
    return ListTile(
      selected: selected,
      onTap: onTab,
      title: Text(title),
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      dense: true,
      leading: Icon(icon, size: 20),
      trailing: trailing,
    );
  }

  ListTile buildFooter(BuildContext context) {
    return ListTile(
      onTap: () async {
        bool isOut = await context.read<AuthProvider>().signOut();
        if (isOut) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(LoginScreenRoute, (_) => false);
        }
      },
      leading: Icon(Icons.exit_to_app),
      title: Text('Log Out'),
      subtitle: Text('abdo187@gmail.com'),
    );
  }
}
