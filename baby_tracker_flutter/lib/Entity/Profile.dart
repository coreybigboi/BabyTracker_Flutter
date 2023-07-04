class Profile{
  late String name;
  late String dob;
  late int height;
  late int weight;

  Profile({required this.name, required this.dob, required this.height, required this.weight});

  Profile.fromJson(Map<String, dynamic> json)
      :
        name = json['name'],
        dob = json['dob'],
        height = json['height'],
        weight = json['weight'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'dob': dob,
        'height' : height,
        'weight' : weight
      };

}