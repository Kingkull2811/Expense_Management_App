import 'package:flutter/material.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }
  DatabaseService._internal();
  GlobalKey? mainKey;

  GlobalKey? homeKey;
  GlobalKey? myWalletKey;
  GlobalKey? newCollectionKey;
  GlobalKey? planningKey;
  GlobalKey? accountKey;
}
