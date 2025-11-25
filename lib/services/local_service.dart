import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reservation_service_app/models/activity.dart';

class LocalService {
  static late final Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.openSync([ActivitySchema], directory: dir.path);
  }

  static Future<void> createNewActivity(String name) async {
    final activity = Activity()
      ..name = name
      ..date = DateTime.now();

    await isar.writeTxn(() async {
      await isar.activitys.put(activity); // insert & update
    });
  }

  static Future<void> deleteActivity(int id) async {
    await isar.writeTxn(() async {
      await isar.activitys.delete(id);
    });
  }

  Stream<List<Activity>> getAllActivities() {
    return isar.activitys.where().watch(fireImmediately: true);
  }
}
