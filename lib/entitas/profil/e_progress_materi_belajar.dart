class EProgressMateriBelajar {
  Map<int, bool> status; 

  EProgressMateriBelajar({required this.status});

  factory EProgressMateriBelajar.fromJson(Map<String, dynamic> json) {
    final map = <int, bool>{};

    json.forEach((key, value) {
      map[int.parse(key)] = value as bool;
    });
    
    return EProgressMateriBelajar(status: map);
  }

  Map<String, dynamic> toJson() {
    return status.map((key, value) => MapEntry(key.toString(), value));
  }
}