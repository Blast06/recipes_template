import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/BookMarkWidget.dart';
import 'package:recipe_app/main.dart';

class BookMarkScreen extends StatefulWidget {
  final bool isProfile;

  BookMarkScreen({this.isProfile = false});

  @override
  BookMarkScreenState createState() => BookMarkScreenState();
}

class BookMarkScreenState extends State<BookMarkScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isProfile ? appBarWidget(language!.bookmark, elevation: 0) : null,
      body: BookMarkWidget(),
    );
  }
}
