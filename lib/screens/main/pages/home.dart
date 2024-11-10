import 'package:flutter/material.dart';
import 'package:hackathon_rower/components/stats_section.dart';

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
    return SingleChildScrollView(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Text(
              "Twoje statystyki",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const StatsSection(),
            const SizedBox(height: 16),
            const Row(
              children: [
                Text(
                  "Dziennik",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            ...bikeRides.map((trip) => SizedBox(
                width: double.infinity,
                child: Card.outlined(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    const Row(
                      children: [
                        Icon(Icons.local_fire_department_outlined),
                        SizedBox(width: 6),
                        Text("0 kcal")
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.schedule),
                        const SizedBox(width: 6),
                        Text(
                            '${trip.startTime.hour.toString()}:${trip.startTime.minute.toString().padLeft(2, '0')} - ${trip.endTime.hour.toString()}:${trip.endTime.minute.toString().padLeft(2, '0')}')
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(width: 6),
                        Text("${trip.startLocation} - ${trip.endLocation}")
                      ],
                    )
                  ]),
                ))))
          ],
        ),
      ),
    ));
  }
}
