class Ride {
  final String startingLocation;
  final String destination;
  final String date;
  final String price;
  final String time;
  final String status;
  final int seats;
  // add other ride details as needed

  Ride({
    required this.startingLocation,
    required this.destination,
    required this.date,
    required this.price,
    required this.time,
    required this.status,
    required this.seats,
    // initialize other ride details
  });

  Ride.fromMap(Map<String, dynamic> map)
      : startingLocation = map['startingLocation'],
        destination = map['destination'],
        date = map['date'],
        price = map['price'],
        time = map['time'],
        status = map['status'],
        seats = map['seats'];
}