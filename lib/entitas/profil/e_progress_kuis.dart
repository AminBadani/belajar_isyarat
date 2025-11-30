class EProgressKuis {
  Map<int, bool> status; 

  EProgressKuis({required this.status});

  factory EProgressKuis.fromJson(Map<String, dynamic> json) {
    final map = <int, bool>{};

    json.forEach((key, value) {
      map[int.parse(key)] = value as bool;
    });
    
    return EProgressKuis(status: map);
  }

  Map<String, dynamic> toJson() {
    return status.map((key, value) => MapEntry(key.toString(), value));
  }
}
