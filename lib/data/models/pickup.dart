class Pickup {
  late int id;
  late int currentLevel;
  late String userName;
  late String userContact;
  late double latitude;
  late double longitude;

  Pickup({
    required this.id,
    required this.currentLevel,
    required this.userName,
    required this.userContact,
    required this.latitude,
    required this.longitude,
  });

  Pickup.fromMap(obj) {
    this.id = obj['id'];
    this.currentLevel = obj['current_level'];
    this.userName = obj['user_name'];
    this.userContact = obj['user_contact'];
    this.latitude = obj['latitude'];
    this.longitude = obj['longitude'];
  }
}