
import 'package:baby_tracker_flutter/Entity/BabyEvent.dart';

class Nappy extends BabyEvent{

  String nappyType;

  Nappy({required super.startDate, required super.startTime, required super.note, required this.nappyType});

  Nappy.fromJson(Map<String, dynamic> json, String id)
      :
        nappyType = json['nappyType'],
        super.fromJson(json, id);

  Map<String, dynamic> toJson() =>
      {
        'startDate': startDate,
        'startTime': startTime,
        'note' : note,
        'nappyType' : nappyType,
        'eventType' : 'nappy'
      };

}