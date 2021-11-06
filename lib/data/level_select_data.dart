import '../models/level_select_model.dart';
import 'levels_data.dart';
import 'package:shared_preferences/shared_preferences.dart';


List<LevelSelectModel> GenerateLevelSelectData({
  rate_lv1,rate_lv2,rate_lv3,rate_lv4,rate_lv5,rate_lv6,rate_lv7,rate_lv8,
  is_locked_lv2,is_locked_lv3,is_locked_lv4,is_locked_lv5,is_locked_lv6,is_locked_lv7,is_locked_lv8,

}){
  List<LevelSelectModel> level_select_data;

  return level_select_data = [
          LevelSelectModel(
            id: 1,
            title:'Level one',
            description:'space',
            level_data:level_data[7],
            rate:rate_lv1,
            is_locked:false,
          ),
          LevelSelectModel(
            id: 2,
            title:'Level two',
            description:'english',
            level_data:level_data[6],
            rate:rate_lv2,
            is_locked:false,
          ),

    ];
}



