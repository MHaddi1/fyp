import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/views/tailors_data_entry2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class TailorDataEntry extends StatefulWidget {
  const TailorDataEntry({Key? key}) : super(key: key);

  @override
  State<TailorDataEntry> createState() => _TailorDataEntryState();
}

class _TailorDataEntryState extends State<TailorDataEntry> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add a global key for the form

  Map<String, int> myPriceList = {"Basic": 0, "Standard": 0, "Premium": 0};
  Map<String, List<File>> _images = {"ServiceImages": []};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_uploading) {
          // If uploading, inform the user and prevent leaving the app
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload in progress. Please wait.'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        } else {
          // If not uploading, allow leaving the app
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tailor Data Entry'),
          backgroundColor: mainColor,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a project title';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Project Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _uploading ? null : _pickImages,
                  child: Text('Select Images'),
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
                    String key = _images.keys.elementAt(index);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(key,
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a price';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                myPriceList[key] = int.tryParse(value) ?? 0;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Price',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _uploading ? null : _saveData,
                  child: _uploading
                      ? CircularProgressIndicator()
                      : Text('Save Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    setState(() {
      _uploading = true;
    });
    EasyLoading.show(status: 'Loading...');
    for (var entry in _images.entries) {
      _images[entry.key] = await _pickImagesForCategory(entry.key);
    }
    EasyLoading.dismiss();
    setState(() {
      _uploading = false;
    });
  }

  Future<List<File>> _pickImagesForCategory(String category) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    return pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
  }

  Future<List<String>> _uploadImages(List<File> images) async {
    setState(() {
      _uploading = true;
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
    EasyLoading.dismiss();
    setState(() {
      _uploading = false;
    });
    return imageUrls;
  }

  void _saveData() async {
    setState(() {
      _uploading = true;
    });

    if (_titleController.text.isEmpty) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Title Field is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        _uploading = false;
      });
      return;
    }

    if (myPriceList.containsValue(0)) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Price Field is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        _uploading = false;
      });
      return;
    }

    // Check if no images are selected
    if (_images["ServiceImages"]!.isEmpty) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Add is Image'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        _uploading = false;
      });
      return;
    }

    // Proceed with saving data
    EasyLoading.show(status: 'Saving...');
    final currentUser = await FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      EasyLoading.dismiss();
      print('User is not authenticated');
      setState(() {
        _uploading = false;
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
        .collection('Tailor_Services')
        .doc(currentUser.email)
        .set(userData, SetOptions(merge: true));
    EasyLoading.dismiss();
    setState(() {
      _uploading = false;
    });
    print('Data saved successfully');
    Get.to(() => TailorsDataEntry2());
  }
}
