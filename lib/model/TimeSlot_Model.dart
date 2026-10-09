class Timeslot {
  Timeslot({
    required this.dateDay,
    required this.time,
  });

  String dateDay;
  List<Time> time;

  factory Timeslot.fromJson(Map<String, dynamic> json) {
    final timeList = json["time"];
    List<Time> times = [];
    if (timeList != null && timeList is List) {
      times = List<Time>.from(
        timeList.where((x) => x != null).map((x) => Time.fromJson(x as Map<String, dynamic>)),
      );
    }
    return Timeslot(
      dateDay: json["dateDay"]?.toString() ?? '',
      time: times,
    );
  }

  Map<String, dynamic> toJson() => {
        "dateDay": dateDay,
        "time": List<dynamic>.from(time.map((x) => x.toJson())),
      };
}

class Time {
  Time({
    required this.morningTime,
    required this.eveningTime,
  });

  String? morningTime;
  String? eveningTime;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        morningTime: json["morningTime"] as String?,
        eveningTime: json["eveningTime"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "morningTime": morningTime,
        "eveningTime": eveningTime,
      };
}
