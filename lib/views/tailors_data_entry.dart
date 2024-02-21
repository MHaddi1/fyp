import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Add this import
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TailorDataEntry extends StatefulWidget {
  const TailorDataEntry({Key? key}) : super(key: key);

  @override
  State<TailorDataEntry> createState() => _TailorDataEntryState();
}

class _TailorDataEntryState extends State<TailorDataEntry> {
  final _titleController = TextEditingController();

  Map<String, int> myPriceList = {"basic": 0, "standard": 0, "premium": 0};
  Map<String, List<File>> _images = {
    "basic": [],
    "standard": [],
    "premium": []
  };

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _uploading = false; // Track whether uploading is in progress

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Add WillPopScope widget
      onWillPop: () async {
        if (_uploading) {
          // Show confirmation dialog if uploading is in progress
          return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Data Uploading'),
                  content: Text(
                      'Data is being uploaded. Are you sure you want to leave?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // Stay on the page
                      },
                      child: Text('Stay'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // Leave the page
                      },
                      child: Text('Leave'),
                    ),
                  ],
                ),
              ) ??
              false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back,
              color: textWhite,
            ),
          ),
          title: Text(
            'Tailor Data Entry',
            style: TextStyle(color: textWhite),
          ),
          backgroundColor: mainColor,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.0),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title Project',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _uploading
                    ? null
                    : _pickImages, // Disable button during upload
                child: Text('Pick Images'),
              ),
              SizedBox(height: 20.0),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: _images.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = myPriceList.keys.elementAt(index);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(key, style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images[key]!.length,
                          itemBuilder: (context, idx) {
                            return Image.file(_images[key]![idx]);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20.0),
              Column(
                children: myPriceList.entries.map((entry) {
                  String key = entry.key;
                  return ListTile(
                    title: Text(key),
                    trailing: SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            myPriceList[key] = int.tryParse(value) ?? 0;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Price'),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _uploading
                    ? null
                    : _saveData, // Disable button during upload
                child: Text('Save Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    setState(() {
      _uploading = true; // Set uploading to true when picking images
    });
    EasyLoading.show(status: 'Loading...');
    for (var entry in _images.entries) {
      _images[entry.key] = await _pickImagesForCategory(entry.key);
    }
    EasyLoading.dismiss();
    setState(() {
      _uploading = false; // Set uploading to false when done picking images
    });
  }

  Future<List<File>> _pickImagesForCategory(String category) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      return pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    }
    return [];
  }

  Future<List<String>> _uploadImages(List<File> images) async {
    setState(() {
      _uploading = true; // Set uploading to true when uploading images
    });
    EasyLoading.show(status: 'Uploading...');
    List<String> imageUrls = [];
    for (var imageFile in images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('images/$fileName');
      final uploadTask = ref.putFile(imageFile);
      final taskSnapshot = await uploadTask;
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }
    EasyLoading.dismiss().then((value) {
      Get.back();
    });
    setState(() {
      _uploading = false; // Set uploading to false when done uploading images
    });
    return imageUrls;
  }

  void _saveData() async {
    setState(() {
      _uploading = true; // Set uploading to true when saving data
    });
    EasyLoading.show(status: 'Saving...');
    final currentUser = await FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      EasyLoading.dismiss();
      print('User is not authenticated');
      setState(() {
        _uploading = false; // Set uploading to false if not authenticated
      });
      return;
    }

    Map<String, dynamic> userData = {
      'title': _titleController.text,
      'priceList': myPriceList,
    };

    Map<String, List<String>> imageUrls = {};
    for (var entry in _images.entries) {
      List<String> urls = await _uploadImages(entry.value);
      imageUrls[entry.key] = urls;
    }
    userData['images'] = imageUrls;

    await _firestore
        .collection('users')
        .doc(currentUser.email)
        .set(userData, SetOptions(merge: true));
    EasyLoading.dismiss();
    if (mounted) {
      setState(() {
        _uploading = false;
      });
    }
    print('Data saved successfully');
  }
}
