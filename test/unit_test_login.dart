// import 'package:flutter_test/flutter_test.dart';
// import 'package:food_delivery_h2d/data/authentication/auth_repository.dart';
// import 'package:food_delivery_h2d/utils/http/http_client.dart';
// import 'package:mockito/mockito.dart';

// // class MockHttpHelper extends Mock implements HttpHelper {}

// void main() {
//   late AuthRepository authRepository;
//   late HttpHelper mockHttpHelper;

//   setUp(() {
//     mockHttpHelper = HttpHelper();
//     authRepository = AuthRepository();
//   });

//   group('AuthRepository - login', () {
//     test('returns LoginResponse on successful login', () async {
//       final mockResponse = {
//         "data": {
//           "token": "fake_token",
//           "user": {"id": "123", "email": "test@example.com"}
//         }
//       };

//       when(HttpHelper.post(any, any)).thenAnswer((_) async => mockResponse);

//       final result =
//           await authRepository.login("test@example.com", "password", "user");

//       expect(result.token, equals("fake_token"));
//       expect(result.user.email, equals("123"));
//       verify(HttpHelper.post(any, any)).called(1);
//     });

//     test('throws Exception on login error', () async {
//       when(mockHttpHelper.post(any, any)).thenThrow(Exception("Login failed"));

//       expect(
//         () async => await authRepository.login(
//             "wrong@example.com", "wrong_password", "user"),
//         throwsA(isA<Exception>()),
//       );
//       verify(mockHttpHelper.post(any, any)).called(1);
//     });
//   });
// }
