import 'package:flutter/material.dart';

class CustomHero extends StatelessWidget {
  String tag;
  Widget child;
  CustomHero({Key? key, required this.tag, required this.child, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      flightShuttleBuilder: (BuildContext flightContext, Animation<double> animation, HeroFlightDirection flightDirection, BuildContext fromHeroContext, BuildContext toHeroContext) =>
          Material(type: MaterialType.transparency,child: toHeroContext.widget),
      tag: tag,
      child: child,
    );
  }
}
