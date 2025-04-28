import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'database_helper.dart';

class TreatmentScreen extends StatefulWidget {
  const TreatmentScreen({super.key});

  @override
  _TreatmentScreenState createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  Map<Treatment, List<TimeOfDay>> myTreatments = {};
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
    Map<Treatment, List<String>> treatments =
        await _databaseHelper.getTreatmentsWithReminders();
    setState(() {
      myTreatments = treatments.map((key, value) => MapEntry(
            key,
            value
                .map((time) => TimeOfDay(
                      hour: int.parse(time.split(':')[0]),
                      minute: int.parse(time.split(':')[1]),
                    ))
                .toList(),
          ));
    });
  }

  void _showTimePicker(Treatment treatment) async {
    TimeOfDay? time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        // Ajouter le rappel à la liste des rappels du traitement
        treatment.reminders.add(time);
      });
      // Sauvegarder le traitement avec le nouveau rappel
      _addTreatmentToList(treatment);
    }
  }

  void _addTreatmentToList(Treatment treatment) async {
    await _databaseHelper.insertTreatment(treatment);
    _loadTreatments();
  }

  void _removeTreatment(Treatment treatment) async {
    if (treatment.id != null) {
      await _databaseHelper.deleteTreatment(treatment.id!);
      _loadTreatments();
    }
  }

  void _showTreatmentInfo(BuildContext context, Treatment treatment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(treatment.name),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Image.asset(treatment.image, fit: BoxFit.contain),
                ),
                SizedBox(height: 10),
                Text(treatment.description),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _openDocxFile(treatment.name);
                  },
                  child: Text("Ouvrir le Document"),
                ),
              ],
            ),
          ),
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

  void _openDocxFile(String treatmentName) async {
    String filePath = 'assets/docx/$treatmentName.docx';
    OpenFile.open(filePath);
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () =>
                                      _showTreatmentInfo(context, treatment),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => _showTimePicker(treatment),
                                ),
                              ],
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
                        final treatment = myTreatments.keys.elementAt(index);
                        final reminders = myTreatments[treatment]!;
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
                                    onPressed: () =>
                                        _removeTreatment(treatment),
                                  ),
                                ),
                                ...reminders.map((time) => ListTile(
                                      title: Text(
                                          "${time.hour}:${time.minute.toString().padLeft(2, '0')}"),
                                    )),
                                TextButton.icon(
                                  icon: const Icon(Icons.add_alarm,
                                      color: Colors.green),
                                  label: const Text("Ajouter un rappel"),
                                  onPressed: () => _showTimePicker(treatment),
                                ),
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
}

class Treatment {
  int? id;
  final String name;
  final String image;
  final String description;
  List<TimeOfDay> reminders = [];

  Treatment({
    this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  // Optionally, you can add a method to map database rows to Treatment objects
  factory Treatment.fromMap(Map<String, dynamic> map) {
    return Treatment(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      description: map['description'],
    );
  }
}

List<Treatment> predefinedTreatments = [
  Treatment(
      name: "Rifadine 300mg",
      image: "assets/img/rifadine_300mg.jpg",
      description:
          "Antibiotique utilisé pour traiter la tuberculose. Effets secondaires : nausées, douleurs abdominales. 1 comprimé le matin à jeun."),
  Treatment(
      name: "Rifater",
      image: "assets/img/rifater.jpg",
      description:
          "Combinaison d'antibiotiques. Effets secondaires : troubles digestifs. 2 comprimés le matin à jeun."),
  Treatment(
      name: "Rifinah 300mg-150mg",
      image: "assets/img/rifinah_150mg300mg.jpg",
      description:
          "Antituberculeux. Effets secondaires : fatigue, douleurs articulaires. 1 comprimé après le repas."),
  Treatment(
      name: "DEXAMBUTOL 500mg",
      image: "assets/img/DEXAMBUTOL_500mg.jpg",
      description:
          "Traitement pour la tuberculose. Effets secondaires : troubles visuels. 1 comprimé avec un grand verre d'eau."),
  Treatment(
      name: "Myambutol 400mg",
      image: "assets/img/MYAMBUTOL_400mg.jpg",
      description:
          "Antituberculeux. Effets secondaires : troubles visuels. 1 comprimé avec un grand verre d'eau."),
  Treatment(
      name: "Pirilene 500mg",
      image: "assets/img/PIRILENE_500mg.jpg",
      description:
          "Anti-inflammatoire. Effets secondaires rares. 1 comprimé par jour."),
  Treatment(
      name: "Rimactan 300mg",
      image: "assets/img/RIMACTAN_300mg.jpg",
      description:
          "Antibiotique puissant. Effets secondaires : troubles digestifs. 2 comprimés le matin à jeun."),
  Treatment(
      name: "RIMIFON 50mg",
      image: "assets/img/RIMIFON_50mg.jpg",
      description:
          "Antituberculeux. Effets secondaires : nausées, douleurs abdominales. 1 comprimé le matin à jeun."),
  Treatment(
      name: "RIMIFON 150mg",
      image: "assets/img/RIMIFON_150mg.jpg",
      description:
          "Antituberculeux. Effets secondaires : nausées, douleurs abdominales. 1 comprimé le matin à jeun."),
];
