import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo/service/user_service.dart';
import 'package:todo/models/userdata.dart';

// Generate mocks
@GenerateMocks([http.Client])
import 'image_upload_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late UserService userService;
  
  setUp(() {
    mockClient = MockClient();
    userService = UserService(client: mockClient);
  });

  test('updatePost sends correct multipart request with image', () async {
    // Arrange
    final userItem = UserItem(
      id: '1',
      username: 'testuser',
      petName: 'Fluffy',
      address: '123 Test St',
    );
    
    final imageBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
    const imageName = 'test.jpg';
    
    // Mock the HTTP client to verify the request
    when(mockClient.send(any)).thenAnswer((_) async {
      final request = _.positionalArguments[0] as http.MultipartRequest;
      
      // Verify the request was made to the correct URL
      expect(request.url.toString(), 'https://todo.hemex.ai/api/user');
      
      // Verify the method is PATCH
      expect(request.method, 'PATCH');
      
      // Verify the content type is multipart
      expect(request.headers['Content-Type']?.contains('multipart/form-data'), isTrue);
      
      // Verify the file was attached
      expect(request.files.length, 1);
      expect(request.files.first.filename, imageName);
      
      // Return a successful response
      return http.StreamedResponse(
        Stream.value(utf8.encode('{"status":"success"}')),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    
    // Act & Assert
    await userService.updatePost(
      userItem,
      imageBytes: imageBytes,
      imageName: imageName,
    );
    
    // Verify the request was made
    verify(mockClient.send(any)).called(1);
  });
  
  test('updatePost handles network error', () async {
    // Arrange
    final userItem = UserItem(
      id: '1',
      username: 'testuser',
    );
    
    // Mock a network error
    when(mockClient.send(any)).thenThrow(http.ClientException('Network error'));
    
    // Act & Assert
    expect(
      () => userService.updatePost(userItem),
      throwsA(isA<Exception>()),
    );
  });
  
  test('updatePost handles server error', () async {
    // Arrange
    final userItem = UserItem(
      id: '1',
      username: 'testuser',
    );
    
    // Mock a server error response
    when(mockClient.send(any)).thenAnswer((_) async {
      return http.StreamedResponse(
        Stream.value(utf8.encode('{"error":"Invalid data"}')),
        400,
        headers: {'content-type': 'application/json'},
      );
    });
    
    // Act & Assert
    expect(
      () => userService.updatePost(userItem),
      throwsA(isA<Exception>()),
    );
  });
}
