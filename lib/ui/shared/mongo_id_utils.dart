class MongoIdUtils {
  static DateTime getTimeFromObjectId(String objectId) {
    String hexTimestamp = objectId.substring(0, 8);
    int timestamp = int.parse(hexTimestamp, radix: 16);
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }
}
