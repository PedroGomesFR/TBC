import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();
    // TODO: Get the local timezone dynamically if possible
    try {
      // Attempt to get the local timezone name
      // Note: This might not be perfectly reliable on all platforms or configurations.
      // tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
      // Fallback to a common timezone if needed
      tz.setLocalLocation(tz.getLocation('Europe/Paris')); // Example fallback
    } catch (e) {
      tz.setLocalLocation(tz.UTC); // Absolute fallback
    }

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Default icon

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification, // Optional callback
    );

    // Linux initialization settings (optional)
    // const LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(
    //   defaultActionName: 'Open notification',
    // );

    final InitializationSettings initializationSettings =
        InitializationSettings(
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

  // --- Notification Details --- (Define common details)

  NotificationDetails _getPlatformDetails(String channelId, String channelName,
      {String? channelDescription}) {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId, // Channel ID
      channelName, // Channel Name
      channelDescription:
          channelDescription ?? 'Notifications pour $channelName',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      // TODO: Add sound, vibration options if needed
    );

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      // TODO: Add sound options if needed
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  // --- Scheduling Methods ---

  // Schedule a daily reminder for a medication
  Future<void> scheduleDailyMedicationReminder({
    required int id, // Unique ID for the notification
    required String title,
    required String body,
    required TimeOfDay time, // Time of day for the reminder
    String? payload,
  }) async {
    try {
      final tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);
      final platformDetails = _getPlatformDetails(
          'medication_reminders_channel', 'Rappels Médicaments',
          channelDescription:
              'Notifications pour les rappels de prise de médicaments');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        platformDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents:
            DateTimeComponents.time, // Répète chaque jour à la même heure
      );
    } catch (e) {}
  }

  // Schedule a one-time notification for a specific date and time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      final tz.TZDateTime tzScheduledDate =
          tz.TZDateTime.from(scheduledDate, tz.local);
      final platformDetails = _getPlatformDetails(
          'general_notifications_channel', 'Notifications Générales');

      // Ensure the scheduled date is in the future
      if (tzScheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        return; // Don't schedule notifications for the past
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledDate,
        platformDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {}
  }

  // Show an immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      final platformDetails = _getPlatformDetails(
          'alert_notifications_channel', // Use a different channel for alerts?
          'Alertes Immédiates');
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        platformDetails,
        payload: payload,
      );
    } catch (e) {}
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
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // --- Optional Callbacks ---

  // void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
  //   // Handle notification received while app is in foreground (iOS only)
  // }

  // void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  //   final String? payload = notificationResponse.payload;
  //   if (notificationResponse.payload != null) {
  //   }
  //   // Handle notification tap action here
  //   // e.g., navigate to a specific screen
  // }
}
