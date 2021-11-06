import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../movement.dart';
import 'dart:math';
import 'package:timer_count_down/timer_count_down.dart';
import 'level_select_screen.dart';
import '../data/level_select_data.dart';
import 'package:flutter/foundation.dart';
import '../widgets/stars.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/level_select_model.dart';
import '../widgets/circle_button.dart';
import '../widgets/results_display.dart';
import './loading_home_screen.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:toast/toast.dart';
import '../keyboard.dart';


class LevelScreen extends StatefulWidget {
  final level_data;
  final String title;
  final int id;
  LevelScreen({this.id,this.level_data,this.title});

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  //level_select
  final CountdownController _controller = new CountdownController();
  List<LevelSelectModel> level_select_data;
  bool is_locked_lv2;int rate_lv1;int rate_lv2;


  //powerups
  int hint_count;
  int time_restart_count;

  //level_screen
  int id;int first_index;int last_index_hor;int current_grid_size;Color random_color;
  int current_selected_index;double border_width ;double selected_border_width;
  var input_cell;var qa;String question = '';Map correct_answer_dict = new Map();
  Map current_answer_dict = new Map();bool is_hor=true; bool is_hint = false;
  bool is_game_done = false;
  bool is_crossword_checking = false;
  bool is_win = false;
  int score;
  int current_time = 0;
  int seconds;

  @override
  void initState(){
    ReadLevelSelectPrefsData();
    ReadScoreCount();
    ReadPowerupCount();
    id = widget.id;
    random_color = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.6);
    first_index = widget.level_data.first_index;
    last_index_hor = widget.level_data.last_index_hor;
    current_grid_size = widget.level_data.current_grid_size;
    current_selected_index = widget.level_data.first_index;
    input_cell = widget.level_data.input_cell;
    qa = widget.level_data.qa;
    correct_answer_dict = checkAnswer(qa);
    current_answer_dict = currentAnswer(qa);
    border_width = 1.0;
    selected_border_width= 1.0;
    seconds = widget.level_data.time;
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

  Future ReadScoreCount() async{
    final prefs = await SharedPreferences.getInstance();
    final _score = prefs.getInt('score') ?? 0;
    setState((){
      score = _score;
    });
  }

  Future ReadPowerupCount() async{
    final prefs = await SharedPreferences.getInstance();
    final int _hint_count = prefs.getInt('hint_count') ?? 3;
    final int _time_restart_count = prefs.getInt('time_restart_count') ?? 1;
    setState((){
      hint_count = _hint_count;
      time_restart_count = _time_restart_count;
    });
  }

  Future SavePowerupCount({cur_hint_count,hint_count_loss,cur_time_restart_count,time_restart_count_loss}) async{
    final prefs = await SharedPreferences.getInstance();
    if (hint_count > 0){
      prefs.setInt('hint_count',cur_hint_count - hint_count_loss);

      setState((){
        hint_count = cur_hint_count - hint_count_loss;
      });
    }
    if (time_restart_count > 0){
      prefs.setInt('time_restart_count',cur_time_restart_count - time_restart_count_loss);

      setState((){
        time_restart_count = cur_time_restart_count - time_restart_count_loss;
      });
    }
  }





  Map checkAnswer(qa){
    Map map = qa;
    Map map2 = new Map();
    Map map3 = new Map();
    map.forEach((k, v) {
      map2[k] = v.answer;
    } );
    map2.forEach((k,v) {
      for(var i=0;i < v.length;i++ ){
        map3[k[i]]=v[i].toUpperCase();
      }
    });
  return map3;
  }

  Map currentAnswer(qa){
    Map map = qa;
    Map map2 = new Map();
    Map map3 = new Map();
    map.forEach((k, v) {
      map2[k] = v.answer;
    } );
    map2.forEach((k,v) {
      for(var i=0;i < v.length;i++ ){
        map3[k[i]]='';
      }
    });
  return map3;
  }



  letterCell(context,{int grid_size,int index,int selected_index}){
    Color border_color;
    Color primary_color = Colors.white;
    bool is_disabled = true;
    String qid = '';
    String temp_question = '';
    String current_letter = '';

    for(var cell in input_cell){
      if(cell.contains(index)){
        try{
          is_disabled = false;
          if (index == qa[cell].qid){
            qid = (qa[cell].id).toString();
            temp_question = (qa[cell].question);
            break;
          }
        }catch(e){
          print(e);
        }
      }
    }
    if(selected_index == index){
      border_color = Colors.orange;
      primary_color = Color(0xFAFAD2.toInt()).withOpacity(1);
      border_width = selected_border_width;
      setState((){
        question = temp_question;
      });
    }
    else{
      border_color = Colors.black;
    }
    if(mapEquals(current_answer_dict,correct_answer_dict)){
      is_game_done = true;
      is_win = true;
    }
    if (is_crossword_checking){
      if(!is_disabled){
            if (current_answer_dict[index].toUpperCase() == correct_answer_dict[index].toUpperCase() && correct_answer_dict[index] != ''){
              border_color = Colors.green;
              primary_color = Color(0xC4F1BC.toInt()).withOpacity(1);
              border_width = selected_border_width;
            }
            else if(current_answer_dict[index].toUpperCase() != correct_answer_dict[index].toUpperCase() && correct_answer_dict[index] != ''){
              border_color = Colors.red;
              primary_color = Color(0xF09595.toInt()).withOpacity(1);
              border_width = selected_border_width;
            }
      }
    }
    current_answer_dict.forEach((k,v){
      if(index == k){
          current_letter = v.toUpperCase();
      }
    });

    if(is_hint){
      print('is_hint');
      print(selected_index);
      print(correct_answer_dict[selected_index]);
      current_answer_dict[selected_index] = correct_answer_dict[selected_index];
      is_hint = false;
    }



    return GestureDetector(
    onDoubleTap:(){
      setState((){
        is_hor=!is_hor;
        Toast.show(is_hor?"HORIZONTAL":"VERTICAL", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      });
    },
    onTap:(){
      setState((){
        is_crossword_checking = false;
        if(checkInputCell(input_cell,index)){
          current_selected_index = index;
        }
      });
    },
    child: Container(
          height: (MediaQuery.of(context).size.width-10) / grid_size,
          width: (MediaQuery.of(context).size.width-10) / grid_size,
          decoration:
              BoxDecoration(
                color: !is_disabled ? primary_color : random_color,
                border: Border.all(
                  color: border_color,
                  width: border_width,
                  )
              ),
          child:Stack(
            children: [
            Padding(
              padding:EdgeInsets.symmetric(horizontal:1),
              child: Text('$qid',
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0
              )
              ),
            ),
            Container(
              width:(MediaQuery.of(context).size.width-10) / grid_size,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text(!is_disabled ?'$current_letter' : '',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0
                )
              )],)
            )

            ],)
          // child: Text('$index')
        ),
      );
  }

  generateMatrix(context,grid_size,{selected_index}){
    List<Widget> rows = [];
    int adder = 0;
    for (int i = 1; i <= grid_size; i++){
      rows.add(Row(children: generateRow(context,grid_size,adder:adder,selected_index:selected_index)));
      adder += grid_size;
    }
    return rows;
  }
  generateRow(context,grid_size,{adder:0,selected_index}){

    List<Widget> cells = [];
    for (int i = 1; i <= grid_size;i++){
      cells.add(letterCell(context,grid_size:grid_size,index:i + adder,selected_index:selected_index));
    }
    return cells;
  }
  
  
  Function onTextInput(String text){
    if(text != ''){
    setState((){
      if(is_hor){
        current_answer_dict[current_selected_index] = text.toUpperCase();
        if(current_selected_index < last_index_hor ){
          current_selected_index = moveRightCondition(current_selected_index,input_cell);
        }
        else{
          current_selected_index = first_index;
        }
      }else{
        current_answer_dict[current_selected_index] = text.toUpperCase();
        int last_index = current_grid_size * current_grid_size;
        current_selected_index = moveDownCondition(current_selected_index,input_cell,last_index,current_grid_size);
      }
      });
    }
  }
  



  @override
  Widget build(BuildContext context) {
    
    level_select_data = GenerateLevelSelectData(
    rate_lv1:rate_lv1,rate_lv2:rate_lv2,is_locked_lv2:is_locked_lv2,);

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [


                    Text(widget.title.toUpperCase(),
                    style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3
                    )
                    ),
                  ],
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleButton(
                      onTap: (){
                        setState((){
                          is_hor = !is_hor;
                          Toast.show(is_hor?"HORIZONTAL":"VERTICAL", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                        });
                      },
                      child: is_hor ?Icon(Icons.arrow_forward,color:Colors.black):Icon(Icons.arrow_downward,color:Colors.black)
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    CircleButton(
                      onTap: (){
                        setState((){
                          is_crossword_checking = true;
                        });
                      },
                      child: Icon(Icons.check,color:Colors.black)
                    ),
                    SizedBox(
                      width: 8.0,
                    ),

                  ],
                ),
              ],
            ),),
        body:!is_game_done ? Column(
              children: [
              RawKeyboardListener(
              focusNode: FocusNode(),
              autofocus: true,
              onKey:(RawKeyEvent event){
                setState((){
                if(is_hor){
                  if (event.isKeyPressed(LogicalKeyboardKey.backspace)){
                    current_answer_dict[current_selected_index]='';
                    if(current_selected_index > first_index){
                      current_selected_index= moveLeftCondition(current_selected_index,input_cell);
                    }
                  }
                  else if(event.runtimeType == RawKeyDownEvent){
                    current_answer_dict[current_selected_index] = event.logicalKey.keyLabel.toString().toUpperCase();
                    if(current_selected_index < last_index_hor ){
                      current_selected_index = moveRightCondition(current_selected_index,input_cell);
                    }
                    else{
                      current_selected_index = first_index;
                    }
                  }
                }else{
                  if (event.isKeyPressed(LogicalKeyboardKey.backspace)){
                    current_answer_dict[current_selected_index]='';
                    int last_index = current_grid_size * current_grid_size;
                    current_selected_index = moveUpCondition(current_selected_index,input_cell,last_index,current_grid_size);
                  }
                  else  if(event.runtimeType == RawKeyDownEvent){
                    current_answer_dict[current_selected_index] = event.logicalKey.keyLabel.toString().toUpperCase();
                    int last_index = current_grid_size * current_grid_size;
                    current_selected_index = moveDownCondition(current_selected_index,input_cell,last_index,current_grid_size);
                  }
                }
                });

              },
              child: Container(

              child: Column(
                children: generateMatrix(context,current_grid_size,selected_index: current_selected_index),
              )
            ),
          ),
          Expanded(
              flex:1,
              child: Container(
              decoration: BoxDecoration(
                color: Colors.white,


              ),
              alignment:Alignment.center,
              padding:EdgeInsets.symmetric(horizontal:2.0),
              height: 15.0,
              width: MediaQuery.of(context).size.width/1.3,
              child:Text(question.toUpperCase(),
                  textAlign:TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,

                  )
                  ),
            ),
          ),

          CustomKeyboard(
            onTextInput:(String text){onTextInput(text);},
            )

        ],
        )
        :!is_win ? ResultsDisplay(
          init:(){},
          level_select_data:level_select_data,
          level_data: widget.level_data,
          title:widget.title,

          home_button_on_tap:(){
             Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LevelSelectScreen(level_select_data: level_select_data),),
            );
          },
          child: Text('game over'.toUpperCase(),
            textAlign:TextAlign.center,
            style: TextStyle(

              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2
            )
        ),)
        :ResultsDisplay(

          level_select_data:level_select_data,
          level_data: widget.level_data,
          title:widget.title,

          home_button_on_tap:(){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>LevelSelectScreen(level_select_data: level_select_data),),
            );
          },
          child: Column(
            children: [Text('You Win!',
              textAlign:TextAlign.center,
              style: TextStyle(

                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2
              )
        ),

        ]
          ),)


        )
        
        
        ;
  }
}

