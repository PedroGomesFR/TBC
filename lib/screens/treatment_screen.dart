import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
      name: "Isoniazide",
      image: "../assets/Isoniazide100.jpg",
      description:
          "Antibiotique utilisé pour traiter la tuberculose. Effets secondaires : nausées, douleurs abdominales. 1 comprimé le matin à jeun."),
  Treatment(
      name: "Rifampicine",
      image: "../assets/rifampicine150.jpg",
      description:
          "Antibiotique puissant. Effets secondaires : troubles digestifs. 2 comprimés le matin à jeun."),
  Treatment(
      name: "Pyrazinamide",
      image: "../assets/pyrazinamide500.jpg",
      description:
          "Antituberculeux. Effets secondaires : fatigue, douleurs articulaires. 1 comprimé après le repas."),
  Treatment(
      name: "Ethambutol",
      image: "../assets/ethambutol100.jpg",
      description:
          "Traitement pour la tuberculose. Effets secondaires : troubles visuels. 1 comprimé avec un grand verre d'eau."),
  Treatment(
      name: "Vitamine B6",
      image: "../assets/vitamine_b6.jpg",
      description:
          "Supplément vitaminique. Effets secondaires rares. 1 comprimé par jour."),
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

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _addTreatmentToList(Treatment treatment) {
    setState(() {
      if (!myTreatments.contains(treatment)) {
        myTreatments.add(treatment);
      }
    });
  }

  void _setReminder(Treatment treatment, TimeOfDay time) {
    setState(() {
      treatment.reminders.add(time);
    });
  }

  void _removeTreatment(Treatment treatment) {
    setState(() {
      myTreatments.remove(treatment);
    });
  }

  void _removeReminder(Treatment treatment, TimeOfDay time) {
    setState(() {
      treatment.reminders.remove(time);
    });
  }

  void _showTimePicker(Treatment treatment, {TimeOfDay? timeToModify}) async {
    TimeOfDay? time = await showTimePicker(
        context: context, initialTime: timeToModify ?? TimeOfDay.now());
    if (time != null) {
      if (timeToModify != null) {
        _removeReminder(treatment, timeToModify);
      }
      _setReminder(treatment, time);
    }
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

  void _showZoomedImage(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: InteractiveViewer(
            panEnabled: true,
            boundaryMargin: EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.asset(image),
          ),
        );
      },
    );
  }

  void _showAddTreatmentDialog() {
    String name = '';
    String description = '';
    String image = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter un Traitement'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) => name = value,
                decoration:
                    const InputDecoration(labelText: 'Nom du traitement'),
              ),
              TextField(
                onChanged: (value) => description = value,
                decoration: const InputDecoration(
                    labelText: 'Description (facultatif)'),
              ),
              TextField(
                onChanged: (value) => image = value,
                decoration:
                    const InputDecoration(labelText: 'Image URL (facultatif)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  final newTreatment = Treatment(
                      name: name, image: image, description: description);
                  _addTreatmentToList(newTreatment);
                  Navigator.pop(context);
                }
              },
              child: const Text('Ajouter'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
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
                  ElevatedButton(
                    onPressed: _showAddTreatmentDialog,
                    child: const Text('Ajouter un Traitement'),
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
                            leading: GestureDetector(
                              onTap: () =>
                                  _showZoomedImage(context, treatment.image),
                              child: Image.asset(treatment.image,
                                  width: 50, height: 50),
                            ),
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
                                  onPressed: () =>
                                      _addTreatmentToList(treatment),
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
                                    onPressed: () =>
                                        _removeTreatment(treatment),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                ...treatment.reminders.map((time) => ListTile(
                                      title: Text(
                                          "${time.hour}:${time.minute.toString().padLeft(2, '0')}"),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () => _showTimePicker(
                                            treatment,
                                            timeToModify: time),
                                      ),
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
