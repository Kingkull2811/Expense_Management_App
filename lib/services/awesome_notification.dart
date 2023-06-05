import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AwesomeNotification {
  // init Local Notification
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'wallet_app',
          channelName: 'wallet_app',
          channelDescription: 'Notification tests as alerts',
          playSound: true,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
          defaultColor: const Color.fromARGB(255, 107, 154, 107),
          ledColor: Colors.white,
        )
      ],
      debug: true,
    );
  }

  // init Push Notification.
  static Future<void> initializeRemoteNotifications() async {
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
      onFcmSilentDataHandle: AwesomeNotification.mySilentDataHandle,
      onFcmTokenHandle: AwesomeNotification.myFcmTokenHandle,
      onNativeTokenHandle: AwesomeNotification.myNativeTokenHandle,
      licenseKeys: null,
      debug: true,
    );
  }

  //get device FCM Token
  Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        final token = await AwesomeNotificationsFcm().requestFirebaseAppToken();
        if (kDebugMode) {
          print('==================FCM Token==================');
          print(token);
        }

        return token;
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return '';
  }

  Future<void> checkPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> localNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'wallet_app',
        title: 'Title Notification',
        body: 'Content Notification',
        notificationLayout: NotificationLayout.Messaging,
      ),
    );
  }

  /// Use this method to execute on background when a silent data arrives
  /// (even while terminated)
  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    if (kDebugMode) {
      print('"SilentData": ${silentData.toString()}');
    }

    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      if (kDebugMode) {
        print("bg");
      }
    } else {
      if (kDebugMode) {
        print("FOREGROUND");
      }
    }
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    // debugPrint('FCM Token:"$token"');
  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    // debugPrint('Native Token:"$token"');
  }
}
