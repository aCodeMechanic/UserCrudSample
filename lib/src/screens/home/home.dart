import 'package:flutter/material.dart';
import 'package:user_crud_sample/src/utils/theme.dart';

import 'widgets/not_found_widget.dart';

class Home extends StatefulWidget {
  final String title;

  const Home({super.key, required this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: greyBackgroundColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:
        const Stack(
          children: [
            Center(child: NotFoundWidget()),
            Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 30.0, top: 15, bottom: 40),
                      child: Text('Swipe left to delete'),
                    ),
                  ],
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Employee',
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
