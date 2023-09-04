import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show ByteData, rootBundle;

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final String apiUrl = "https://www251.ucdn.to/cgi-bin/upload.cgi";

  Future<void> uploadAssetFile() async {
    try {
      // Load the asset file from the "images" folder
      final ByteData data =
          await rootBundle.load('images/news-placeholder.png');

      // Convert the ByteData to a List of bytes
      final List<int> bytes = data.buffer.asUint8List();

      // Create a multipart request using the http.MultipartRequest class
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add the file to the request
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename:
              'news-placeholder.png', // Change to the desired filename on the server
        ),
      );
      // Add additional parameters
      request.fields['sess_id'] =
          'qbec5joi7r272pn4cz6tcgtqbbnzqsitkipkfmzdg6ylsjf7akhdgubarkrfkqfjwbmev6biju';
      request.fields['utype'] = 'prem';

      // Ignore SSL errors (not recommended for production)
      // Create an HTTP client
      final httpClient = http.Client();

      // Send the request
      // final response = await request.send();
      final response = await httpClient.send(request);

      if (response.statusCode == 200) {
        // Response was successful
        final responseJson = json.decode(await response.stream.bytesToString());
        print('File uploaded successfully. Response: $responseJson');
      } else {
        // Response had an error status code
        print('Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asset File Upload Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await uploadAssetFile();
          },
          child: Text('Upload Asset File'),
        ),
      ),
    );
  }
}
