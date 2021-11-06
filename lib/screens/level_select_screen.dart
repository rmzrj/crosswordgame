import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../models/level_select_model.dart';
import '../widgets/stars.dart';
import 'package:geopattern_flutter/geopattern_flutter.dart';
import 'package:geopattern_flutter/patterns/squares.dart';
import '../screens/level_screen.dart';
import '../screens/shop_screen.dart';

class LevelSelectScreen extends StatefulWidget {

  final level_select_data;
  LevelSelectScreen({this.level_select_data});

  @override
  _LevelSelectScreenState createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen>  {

  _buildLevelCards(BuildContext context,int id,String title,String description,var level_data,int rate,bool is_locked){

    return Card(
      margin: EdgeInsets.all(10.0),
      color:Colors.red,
      clipBehavior: Clip.antiAlias,
      child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    description,
                    style: TextStyle(
                      color: Colors.white,

                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    !is_locked ? MaterialButton(
                      color:Colors.blueGrey,
                      textColor: Colors.white,
                      onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LevelScreen(id:id,level_data:level_data,title:'$description')),
                        );
                      },
                      child: const Text('PLAY'),
                    ):
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color:Colors.grey,
                        shape:BoxShape.circle
                      ),
                      child:Icon(Icons.lock,color: Colors.white)
                      ),
                  ],
                ),

              ],
            ),

    );
  }




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Level Select'.toUpperCase(),
                style: TextStyle(
                        // fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3
                )
                ),

              ],
            ), ),
            body: Container(

            width:MediaQuery.of(context).size.width,
            height:MediaQuery.of(context).size.height,
              child:GridView.count(
                padding:EdgeInsets.all(10.0),
                crossAxisCount: 2,
                children:List.generate(widget.level_select_data.length, (index) {
                LevelSelectModel level = widget.level_select_data[index];
                String title = level.title;
                String description = level.description;
                int id = level.id;
                var level_data = level.level_data;
                int rate = level.rate;
                bool is_locked = level.is_locked;
                return _buildLevelCards(context,id, title,description,level_data,rate,is_locked);
              })
              )

              )

      );
        
}
}