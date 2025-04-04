import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController service = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();

  Future<void> insertRecord() async {
    if (_formKey.currentState!.validate()) {
      try {
        String uri = "https://easybox.in/Dataentry/api/leads";
        var data = {
          "name": name.text.trim(),
          "contact": contact.text.trim(),
          "service": service.text.trim(),
          "address": address.text.trim(),
          "pincode": pincode.text.trim()
        };

        var res = await http.post(
          Uri.parse(uri),
          body: data,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        );

        var response = jsonDecode(res.body);
        print("Response Status: ${res.statusCode}");
        print("Response Body: ${res.body}");

        if (response["status"] == "success") {
          _showMessage("✅ Record inserted successfully!", Colors.green);
          _clearFields();
        } else {
          _showMessage(
              "❌ Failed to insert record: ${response['message']}", Colors.red);
        }
      } catch (e) {
        _showMessage("⚠️ Error: $e", Colors.red);
      }
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  void _clearFields() {
    name.clear();
    contact.clear();
    service.clear();
    address.clear();
    pincode.clear();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Name is required";
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
      return "Name must contain only letters";
    }
    if (value.length < 3) return "Name must be at least 3 characters";
    return null;
  }

  String? _validateContact(String? value) {
    if (value == null || value.trim().isEmpty) return "Contact is required";
    if (!RegExp(r"^[0-9]{10}$").hasMatch(value))
      return "Enter a valid 10-digit contact number";
    return null;
  }

  String? _validateService(String? value) {
    if (value == null || value.trim().isEmpty) return "Service is required";
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) return "Address is required";
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.trim().isEmpty) return "Pincode is required";
    if (!RegExp(r"^[0-9]{6}$").hasMatch(value))
      return "Enter a valid 6-digit pincode";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Service Form")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                  validator: _validateName,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: contact,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Contact",
                  ),
                  keyboardType: TextInputType.phone,
                  validator: _validateContact,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: service,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Service",
                  ),
                  validator: _validateService,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: address,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Address",
                  ),
                  validator: _validateAddress,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: pincode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Pincode",
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validatePincode,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: insertRecord,
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
