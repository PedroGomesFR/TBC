import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();
    // TODO: Get the local timezone
    // tz.setLocalLocation(tz.getLocation('Europe/Paris')); // Example, get dynamically

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Default icon

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification, // Optional callback
    );

    // Linux initialization settings (optional)
    // const LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(
    //   defaultActionName: 'Open notification',
    // );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      // linux: initializationSettingsLinux,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveNotificationResponse: onDidReceiveNotificationResponse, // Optional callback for notification tap
    );

    // Request permissions for iOS and Android 13+
    await _requestPermissions();

    print("Notification Service Initialized");
  }

  Future<void> _requestPermissions() async {
    // Request permissions for Android 13+
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();

    // Request permissions for iOS (already done in init settings, but can be explicit)
    // final DarwinFlutterLocalNotificationsPlugin? iOSImplementation =
    //     flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    //         DarwinFlutterLocalNotificationsPlugin>();
    // await iOSImplementation?.requestPermissions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
  }

  // --- Placeholder Methods for Scheduling --- 

  // Example: Schedule a daily reminder for a medication
  Future<void> scheduleDailyMedicationReminder({
    required int id, // Unique ID for the notification
    required String title,
    required String body,
    required TimeOfDay time, // Time of day for the reminder
  }) async {
    try {
      final tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);
      
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'medication_reminders_channel', // Channel ID
        'Rappels Médicaments', // Channel Name
        channelDescription: 'Notifications pour les rappels de prise de médicaments',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        // TODO: Add sound, vibration options if needed
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        // TODO: Add sound options if needed
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at the specified time
      );
      print("Scheduled daily notification $id at $time");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  // Calculate the next instance of a specific time
  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    print("Cancelled notification $id");
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print("Cancelled all notifications");
  }

  // --- Optional Callbacks --- 

  // void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
  //   // Handle notification received while app is in foreground (iOS only)
  //   print('iOS foreground notification received: $title');
  // }

  // void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  //   final String? payload = notificationResponse.payload;
  //   if (notificationResponse.payload != null) {
  //     print('Notification payload: $payload');
  //   }
  //   // Handle notification tap action here
  //   // e.g., navigate to a specific screen
  // }
}

