import '../models/property.dart';
import '../utils/api_client.dart';

class PropertyService {
  static Future<List<Property>> getProperties() async {
    try {
      final response = await ApiClient.get('/api/properties');
      if (response is List) {
        return response.map((json) => Property.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load properties: $e');
    }
  }

  static Future<Property> createProperty(String title, String address, double rentAmount) async {
    try {
      final response = await ApiClient.post('/api/properties', {
        'title': title,
        'address': address,
        'rentAmount': rentAmount,
      });
      return Property.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create property: $e');
    }
  }

  static Future<Property> updateProperty(int id, String title, String address, double rentAmount) async {
    try {
      final response = await ApiClient.put('/api/properties/$id', {
        'title': title,
        'address': address,
        'rentAmount': rentAmount,
      });
      return Property.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update property: $e');
    }
  }

  static Future<void> deleteProperty(int id) async {
    try {
      await ApiClient.delete('/api/properties/$id');
    } catch (e) {
      throw Exception('Failed to delete property: $e');
    }
  }
}
