import 'package:flutter/material.dart';

class BikeTrip {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  final String startLocation;
  final String endLocation;
  BikeTrip(
      {required this.startTime,
      required this.endTime,
      required this.startLocation,
      required this.endLocation});
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static List<BikeTrip> bikeRides = [
    BikeTrip(
      startTime: const TimeOfDay(hour: 15, minute: 35),
      endTime: const TimeOfDay(hour: 17, minute: 00),
      startLocation: "Gdańsk",
      endLocation: "Warszawa",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 10, minute: 20),
      endTime: const TimeOfDay(hour: 12, minute: 00),
      startLocation: "Kraków",
      endLocation: "Poznań",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 8, minute: 45),
      endTime: const TimeOfDay(hour: 10, minute: 15),
      startLocation: "Wrocław",
      endLocation: "Łódź",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 12, minute: 30),
      endTime: const TimeOfDay(hour: 14, minute: 00),
      startLocation: "Szczecin",
      endLocation: "Gdynia",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 14, minute: 50),
      endTime: const TimeOfDay(hour: 16, minute: 20),
      startLocation: "Katowice",
      endLocation: "Lublin",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 9, minute: 15),
      endTime: const TimeOfDay(hour: 10, minute: 45),
      startLocation: "Bydgoszcz",
      endLocation: "Białystok",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 11, minute: 10),
      endTime: const TimeOfDay(hour: 12, minute: 40),
      startLocation: "Rzeszów",
      endLocation: "Toruń",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 13, minute: 25),
      endTime: const TimeOfDay(hour: 14, minute: 55),
      startLocation: "Opole",
      endLocation: "Zielona Góra",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 16, minute: 40),
      endTime: const TimeOfDay(hour: 18, minute: 10),
      startLocation: "Olsztyn",
      endLocation: "Koszalin",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 7, minute: 55),
      endTime: const TimeOfDay(hour: 9, minute: 25),
      startLocation: "Radom",
      endLocation: "Kielce",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 18, minute: 20),
      endTime: const TimeOfDay(hour: 19, minute: 50),
      startLocation: "Gliwice",
      endLocation: "Zabrze",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 19, minute: 35),
      endTime: const TimeOfDay(hour: 21, minute: 05),
      startLocation: "Sosnowiec",
      endLocation: "Ruda Śląska",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 20, minute: 50),
      endTime: const TimeOfDay(hour: 22, minute: 20),
      startLocation: "Rybnik",
      endLocation: "Tychy",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 21, minute: 10),
      endTime: const TimeOfDay(hour: 22, minute: 40),
      startLocation: "Dąbrowa Górnicza",
      endLocation: "Elbląg",
    ),
    BikeTrip(
      startTime: const TimeOfDay(hour: 22, minute: 25),
      endTime: const TimeOfDay(hour: 23, minute: 55),
      startLocation: "Płock",
      endLocation: "Wałbrzych",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Text(
            "Statystyki",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("13,7",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor)),
                    const Text("km")
                  ],
                ),
                Column(
                  children: [
                    Text("6 832",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor)),
                    const Text("kcal")
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Dziennik",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.directions_bike),
                    title: Text(
                        "${bikeRides[index].startTime.hour}:${bikeRides[index].startTime.minute} - ${bikeRides[index].endTime.hour}:${bikeRides[index].endTime.minute}"),
                    subtitle: Text(
                        "${bikeRides[index].startLocation} - ${bikeRides[index].endLocation}"),
                  );
                },
                itemCount: bikeRides.length),
          )
        ],
      ),
    );
  }
}
