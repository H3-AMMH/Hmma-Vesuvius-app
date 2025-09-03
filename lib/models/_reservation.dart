class Reservation {
  final String name;
  final String tel;
  final String time;
  final int partySize;
  final int tablesNeeded;
  final String status;

  Reservation({
    required this.name,
    required this.tel,
    required this.time,
    required this.partySize,
    required this.tablesNeeded,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      name: json['name'],
      tel: json['tel'],
      time: json['time'],
      partySize: json['party_size'],
      tablesNeeded: json['tables_needed'],
      status: json['status'],
    );
  }
}
