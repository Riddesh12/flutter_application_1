import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LogStatus{
  File? jsonFile;
  void enterDetails(String words) {
    //////here do json work
    /////change the response to details and enter them in json
    Map<String,dynamic> userDetail=parseDetails(words);
    writeJson(userDetail, "profile.json");

  }

  Map<String, dynamic> parseDetails(String input) {
    // Split the input string by newlines to process each line
    List<String> lines = input.trim().split('\n');

    // Extract individual details from the lines
    String name = lines[0].split(':')[1].trim();
    String upiId = lines[1].split(':')[1].trim();
    String bankDetails = lines[2].split(':')[1].trim();

    // Extracting bank name and the last 4 digits of the account
    List<String> bankInfo = bankDetails.split(' ');
    String bankName = bankInfo.sublist(0, bankInfo.length - 1).join(' ');
    String accountLastDigits = bankInfo.last.substring(3); // "4537"

    // Check if UPI PIN is set from the last line
    bool upiPinSet = lines[3].trim() == "UPI PIN SET";

    // Return the parsed details as a Map
    return {
      'name': name,
      'upi_id': upiId,
      'bank_name': bankName,
      'account_last_digit': accountLastDigits,
      'upi_pin_set': upiPinSet,
    };
  }

    Future<String> _loadJsonFile(String file) async {
      try {
        Directory dir = await getApplicationDocumentsDirectory();
        String filePath = '${dir.path}/$file';

        jsonFile = File(filePath);

        if (await jsonFile!.exists()) {
          String fileContent = await jsonFile!.readAsString();
          String json = jsonDecode(fileContent);
          return json;
        } else {
          print("JSON file does not exist");
          return "";
        }
      } catch (e) {
        print("Error reading JSON file: $e");
        return e.toString();
      }
    }
  Future<String> getFilePath(String file) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$file';
  }

  // Write data to the JSON file
  Future<void> writeJson(Map<String, dynamic> newJsonData,String fileName) async {
    final filePath = await getFilePath(fileName);
    File file = File(filePath);

    // Check if the file exists, create it if not
    if (!await file.exists()) {
      await file.create();
      await file.writeAsString(jsonEncode([])); // Initialize with an empty array
    }

    // Read existing data
    String fileContent = await file.readAsString();
    List<dynamic> jsonData = jsonDecode(fileContent);
    print(jsonData);

    // Add the new JSON data
    jsonData.add(newJsonData);

    // Write updated data back to the file
    await file.writeAsString(jsonEncode(jsonData));
    print('JSON data added successfully!');
  }

  // Read the JSON file
  Future<List> readJson(String fileName) async {
    final filePath = await getFilePath(fileName);
    File file = File(filePath);

    if (!await file.exists()) {
      print("File does not exist.");
      return [];
    }

    // Read and print the content
    String fileContent = await file.readAsString();
    List<dynamic> jsonData = jsonDecode(fileContent);
    print('File content: $jsonData');
    return jsonData;
  }
  Future<bool> fileIsEmpty(String fileName) async{
    final filePath = await getFilePath(fileName);
    final file= File(filePath);
    if (!await file.exists()) {
      await file.create();
      return true;// Initialize with an empty array
    }
    final fileBytes = await file.readAsBytes();

    // Check if the file is empty
    return fileBytes.isEmpty;
  }
}