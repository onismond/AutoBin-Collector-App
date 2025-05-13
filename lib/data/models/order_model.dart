import 'package:flutter/material.dart';

class Orders {
  late int requestID;
  late int requestType;
  var binID;
  var longitude;
  var latitude;

  Orders({
    required this.requestID,
    required this.requestType,
    required this.binID,
    required this.longitude,
    required this.latitude,
  });

  Orders.fromMap(obj) {
    this.requestID = obj['request_id'];
    this.requestType = obj['request_type'];
    this.binID = obj['bin_id'];
    this.longitude = obj['bin_loc_long'];
    this.latitude = obj['bin_loc_lat'];
  }
}
