import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:geopattern_flutter/geopattern_flutter.dart';
import 'package:geopattern_flutter/patterns/squares.dart';
import 'package:bordered_text/bordered_text.dart';
import 'level_select_screen.dart';
import '../data/levels_data.dart';
import '../data/level_select_data.dart';
import '../models/level_select_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool is_locked_lv2;int rate_lv1;int rate_lv2;

  @override
  void initState() {
    ReadLevelSelectPrefsData();
  }


  Future ReadLevelSelectPrefsData() async{
  final prefs = await SharedPreferences.getInstance();
  final bool _is_locked_lv2 = prefs.getBool('is_locked_lv2') ?? true;

  final int _rate_lv1 = prefs.getInt('rate_lv1') ?? 0;
  final int _rate_lv2 = prefs.getInt('rate_lv2') ?? 0;

  setState((){
    is_locked_lv2 = _is_locked_lv2;rate_lv1=_rate_lv1;rate_lv2=_rate_lv2;
  });
}


  @override
  Widget build(BuildContext context) {
    // final hash = sha1.convert(utf8.encode("flutter")).toString();
    List<LevelSelectModel> level_select_data = GenerateLevelSelectData(
    rate_lv1:rate_lv1,rate_lv2:rate_lv2,is_locked_lv2:is_locked_lv2,);

    return  RaisedButton(
      color: Colors.red,
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LevelSelectScreen(level_select_data: level_select_data),),
        );
      },

      child: Text("Play",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
    );

  }
}









