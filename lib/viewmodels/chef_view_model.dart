import '../models/menu_item.dart';
import '../services/api_service.dart';

class ChefViewModel {
  Future<List<MenuItem>> fetchMenu() async {
    final data = await ApiService.fetchMenu();
    return data.map<MenuItem>((json) => MenuItem.fromJson(json)).toList();
  }
}
