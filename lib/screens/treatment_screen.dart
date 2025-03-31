import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'database_helper.dart';

class Treatment {
  final String name;
  final String image;
  final String description;
  List<TimeOfDay> reminders = [];

  Treatment(
      {required this.name, required this.image, required this.description});
}

List<Treatment> predefinedTreatments = [
  Treatment(
      name: "Rifadine 300mg",
      image: "assets/rifadine_300mg.jpg",
      description:
          "Antibiotique utilisé pour traiter la tuberculose. Effets secondaires : nausées, douleurs abdominales. 1 comprimé le matin à jeun."),
  Treatment(
      name: "Rifater",
      image: "assets/rifater.jpg",
      description:
          "Combinaison d'antibiotiques. Effets secondaires : troubles digestifs. 2 comprimés le matin à jeun."),
  Treatment(
      name: "Rifinah 300mg / 150mg",
      image: "assets/rifinah_150mg300mg.jpg",
      description:
          "Antituberculeux. Effets secondaires : fatigue, douleurs articulaires. 1 comprimé après le repas."),
  Treatment(
      name: "DEXAMBUTOL 500mg",
      image: "assets/dexambutol_500mg.jpg",
      description:
          "Traitement pour la tuberculose. Effets secondaires : troubles visuels. 1 comprimé avec un grand verre d'eau."),
  Treatment(
      name: "Myambutol 400mg",
      image: "assets/myambutol_400mg.jpg",
      description:
          "Antituberculeux. Effets secondaires : troubles visuels. 1 comprimé avec un grand verre d'eau."),
  Treatment(
      name: "Pirilène 500mg",
      image: "assets/pirilene_500mg.jpg",
      description:
          "Anti-inflammatoire. Effets secondaires rares. 1 comprimé par jour."),
  Treatment(
      name: "Rimactan 300mg",
      image: "assets/rimactan_300mg.jpg",
      description:
          "Antibiotique puissant. Effets secondaires : troubles digestifs. 2 comprimés le matin à jeun."),
  Treatment(
      name: "RIMIFON 50mg",
      image: "assets/rimifon_50mg.jpg",
      description:
          "Antituberculeux. Effets secondaires : nausées, douleurs abdominales. 1 comprimé le matin à jeun."),
  Treatment(
      name: "RIMIFON 150mg",
      image: "assets/rimifon_150mg.jpg",
      description:
          "Antituberculeux. Effets secondaires : nausées, douleurs abdominales. 1 comprimé le matin à jeun."),
];

class TreatmentScreen extends StatefulWidget {
  const TreatmentScreen({super.key});

  @override
  _TreatmentScreenState createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  List<Treatment> myTreatments = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadTreatments();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _loadTreatments() async {
    List<Map<String, dynamic>> treatments =
        await _databaseHelper.getTreatments();
    setState(() {
      myTreatments = treatments.map((treatment) {
        Treatment t = Treatment(
          name: treatment['name'],
          image: treatment['image'],
          description: treatment['description'],
        );
        t.reminders.add(TimeOfDay(
          hour: int.parse(treatment['reminderTime'].split(':')[0]),
          minute: int.parse(treatment['reminderTime'].split(':')[1]),
        ));
        return t;
      }).toList();
    });
  }

  void _addTreatmentToList(Treatment treatment, TimeOfDay time) async {
    await _databaseHelper.insertTreatment(
        treatment, '${time.hour}:${time.minute}');
    _loadTreatments();
  }

  void _removeTreatment(int id) async {
    await _databaseHelper.deleteTreatment(id);
    _loadTreatments();
  }

  void _showTimePicker(Treatment treatment) async {
    TimeOfDay? time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      _addTreatmentToList(treatment, time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des Traitements")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text(
                    "Catalogue des Traitements",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: predefinedTreatments.length,
                      itemBuilder: (context, index) {
                        final treatment = predefinedTreatments[index];
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.asset(treatment.image,
                                width: 50, height: 50),
                            title: Text(treatment.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => _showTimePicker(treatment),
                            ),
                            onTap: () => _showTreatmentInfo(context, treatment),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: Column(
                children: [
                  const Text(
                    "Mes Traitements",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: myTreatments.length,
                      itemBuilder: (context, index) {
                        final treatment = myTreatments[index];
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Image.asset(treatment.image,
                                      width: 50, height: 50),
                                  title: Text(treatment.name),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _removeTreatment(index),
                                  ),
                                ),
                                ...treatment.reminders.map((time) => ListTile(
                                      title: Text(
                                          "${time.hour}:${time.minute.toString().padLeft(2, '0')}"),
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTreatmentInfo(BuildContext context, Treatment treatment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(treatment.name),
          content: Text(treatment.description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Fermer"),
            ),
          ],
        );
      },
    );
  }
}
