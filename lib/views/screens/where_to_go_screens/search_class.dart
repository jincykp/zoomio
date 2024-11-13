// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class PlacesService {
//   final String googleMapKey;

//   PlacesService(this.googleMapKey);

//   Future<List<PlaceSuggestion>> getAutocompleteSuggestions(String query) async {
//     final String url =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleMapKey&language=en';
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == 'OK') {
//         return (data['predictions'] as List)
//             .map((place) => PlaceSuggestion.fromJson(place))
//             .toList();
//       }
//     }
//     return [];
//   }
// }

// class PlaceSuggestion {
//   final String placeId;
//   final String description;

//   PlaceSuggestion({required this.placeId, required this.description});

//   factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
//     return PlaceSuggestion(
//       placeId: json['place_id'],
//       description: json['description'],
//     );
//   }
// }
