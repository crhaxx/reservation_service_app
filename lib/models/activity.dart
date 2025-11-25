import 'package:isar/isar.dart';

part 'activity.g.dart';

@Collection()
class Activity {
  Id id = Isar.autoIncrement;

  late String name;

  late String description;

  late DateTime date;
}
