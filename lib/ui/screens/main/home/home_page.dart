import 'package:flutter/material.dart';
import 'package:mafcode/ui/auto_router_config.gr.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          "ACTIONS",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HomeCard(
              lable: "Report Found",
              icon: Icons.emoji_people_rounded,
              color: Colors.red,
              onTap: () {
                Navigator.of(context).pushNamed(Routes.reportScreen);
              },
            ),
            HomeCard(
              lable: "Report Missing",
              icon: Icons.search_rounded,
              color: Colors.purple,
              onTap: () {},
            ),
          ],
        ),
        SizedBox(height: 24),
        Text(
          "LAST REPORTS",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(height: 48),
        Center(
          child: Text(
            "Nothing here yet.\nFuture Reports will appear here.",
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

class HomeCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String lable;
  final Function onTap;
  const HomeCard({
    Key key,
    @required this.icon,
    @required this.color,
    @required this.lable,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 80,
                color: color,
              ),
              SizedBox(height: 24),
              Text(
                lable,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
