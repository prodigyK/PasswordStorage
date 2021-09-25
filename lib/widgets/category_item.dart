import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final int id;
  final String title;
  final String route;
  final Color color;
  final IconData icon;

  CategoryItem({
    @required this.id,
    @required this.title,
    @required this.route,
    this.color = Colors.orange,
    @required this.icon,
  });

  void _selectCategory(BuildContext context) {
    Navigator.pushNamed(
      context,
      route,
      arguments: {'id': id, 'title': title},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 100,
      child: InkWell(
        onTap: () => _selectCategory(context),
        splashColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(15),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.left,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 2),
                    color: Colors.black26,
                  ),
//                BoxShadow(spreadRadius: 2),
                ],
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.3),
                    color.withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(15),
              child: Align(
                child: Icon(icon, size: 35),
                alignment: Alignment.bottomRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
