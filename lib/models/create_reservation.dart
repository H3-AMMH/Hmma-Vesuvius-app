class CreateReservation {
  final String name;
  final String tel;
  final String date;
  final String time;
  final int partySize;

  CreateReservation({
    required this.name,
    required this.tel,
    required this.date,
    required this.time,
    required this.partySize,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tel': tel,
      'date': date,
      'time': time,
      'party_size': partySize,
    };
  }
}