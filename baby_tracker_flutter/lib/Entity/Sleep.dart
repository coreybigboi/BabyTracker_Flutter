
import 'package:baby_tracker_flutter/Entity/BabyEvent.dart';

class Sleep extends BabyEvent{

  String duration;

  Sleep({required super.startDate, required super.startTime, required super.note, required this.duration});

  Sleep.fromJson(Map<String, dynamic> json, String id)
      :
        duration = json['duration'],
        super.fromJson(json, id);

  Map<String, dynamic> toJson() =>
      {
        'startDate': startDate,
        'startTime': startTime,
        'note' : note,
        'duration' : duration,
        'eventType' : 'sleep'
      };
}