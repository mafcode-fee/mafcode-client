import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  Notifications({Key key}) : super(key: key);

  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool hasNotification = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        preferredSize: Size.fromHeight(0),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              title: PageTitle(title: 'Notifications'),
              backgroundColor: Colors.white,
              centerTitle: false,
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10),
                ),
              ]),
          SliverList(
            delegate: SliverChildListDelegate(_getNotifications()),
          )
        ],
      ),
    );
  }

  List<Widget> _getNotifications() {
    List<Widget> notifications = [];
    notifications.add(_getNotification('Jone Found! check', '3 hours ago', false));
    notifications.add(_getNotification('Jone Found! check', 'Yesterday at 11:22pm', false));
    notifications.add(_getNotification('Jone Found! check', 'Yesterday at 8:28pm', false));
    notifications.add(_getNotification('Jone Found! check', '10 hours ago', false));
    notifications.add(_getNotification('Jone Found! check', 'Yesterday at 8:28pm', false));
    notifications.add(_getNotification('Jone Found! check', 'Yesterday at 8:28pm', false));
    notifications.add(_getNotification('Jone Found! check', 'Yesterday at 8:28pm', false));
    notifications.add(_getNotification('Jone Found! check', 'Yesterday at 8:28pm', false));
    notifications.add(_getNotification('Jone Found! check', 'Yesterday at 8:28pm', false));
    return notifications;
  }

  Widget _getNotification(String notificaiton, String time, bool hasStory) {
    return Container(
      decoration: BoxDecoration(color: (hasStory == true) ? Theme.of(context).highlightColor : Colors.transparent),
      child: ListTile(
        title: Text(
          notificaiton,
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        leading: CircleAvatar(
          radius: 28.0,
        ),
        subtitle: Text(
          '\n' + time,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(Icons.more_horiz),
          disabledColor: Colors.black,
          onPressed: () {},
        ),
        onTap: () {
          setState(() {
            hasStory = (hasStory == true) ? false : true;
          });
        },
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  final String title;
  PageTitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
