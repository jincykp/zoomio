// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<List<dynamic>> getPlaces(String searchQuery, String accessToken) async {
//   String encodedQuery = Uri.encodeFull(searchQuery);

//   // Adding headers as required
//   final headers = {
//     'Authorization': 'Bearer $accessToken',
//     'Content-Type': 'application/json',
//   };

//   // Sending the GET request with the headers
//   final response = await http.get(
//     Uri.parse(
//         'https://api.mapbox.com/geocoding/v5/mapbox.places/$encodedQuery.json?access_token=$accessToken'),
//     headers: headers,
//   );

//   if (response.statusCode == 200) {
//     // Parse the JSON response body
//     final data = jsonDecode(response.body);

//     // Extract the features array from the response data
//     List<dynamic> places = data['features'];

//     return places;
//   } else {
//     // If the request was not successful, throw an exception
//     throw Exception('Failed to load places');
//   }
// }
