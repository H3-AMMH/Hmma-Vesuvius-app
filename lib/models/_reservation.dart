class Reservation {
  final int? id;
  final String name;
  final String tel;
  final String date;
  final String time;
  final int partySize;
  final int tablesNeeded;
  final String status;
  final String? tableNumbers; // comma-separated table numbers

  Reservation({
    this.id,
    required this.name,
    required this.tel,
    required this.date,
    required this.time,
    required this.partySize,
    required this.tablesNeeded,
    required this.status,
    this.tableNumbers,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      name: json['name'],
      tel: json['tel'],
      date: json['date'],
      time: json['time'],
      partySize: json['party_size'],
      tablesNeeded: json['tables_needed'],
      status: json['status'],
      tableNumbers: json['table_numbers'],
    );
  }
}
