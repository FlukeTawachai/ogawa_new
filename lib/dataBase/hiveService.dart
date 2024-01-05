import 'package:hive/hive.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';

class HiveService {
  Future<void> addApiSettings(ApiSettings setting, int index) async {
    final apiBox = await Hive.openBox('apiSettings');

    await apiBox.put(index, setting);
  }

  Future<List<ApiSettings>> getVitals() async {
    Box<ApiSettings> box =  await Hive.openBox('apiSettings');
    List<ApiSettings> hiveVitals = box.values.toList();
    return hiveVitals;
  }
}
