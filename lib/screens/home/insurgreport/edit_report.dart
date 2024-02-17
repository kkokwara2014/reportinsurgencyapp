import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportinsurgencyapp/components/mybutton.dart';
import 'package:reportinsurgencyapp/models/category_model.dart';
import 'package:reportinsurgencyapp/models/incidentlocation_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reportinsurgencyapp/models/report_model.dart';

class EditReport extends StatefulWidget {
  const EditReport({super.key});

  @override
  State<EditReport> createState() => _EditReportState();
}

class _EditReportState extends State<EditReport> {
  IncidentLocationModel incidentLocationModel = IncidentLocationModel();
  CategoryModel categoryModel = CategoryModel();
  var selectedLocation;
  var selectedCategory;

  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  //for uploading images
  File? imageFile;
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  getImageOption() async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(12.0),
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 2,
              width: 30,
              color: Colors.black54,
            ),
            ListTile(
              onTap: () {
                Get.back();
                getImage(ImageSource.camera);
              },
              leading: const Icon(
                Icons.camera_alt,
              ),
              title: const Text("Take from Camera"),
            ),
            ListTile(
              onTap: () {
                Get.back();
                getImage(ImageSource.gallery);
              },
              leading: const Icon(
                Icons.image,
              ),
              title: const Text("Take from Gallery"),
            )
          ],
        ),
      ),
    );
  }

  //logged in user
  final loggedInUser = FirebaseAuth.instance.currentUser!;

  //firebase firestore instance
  final _db = FirebaseFirestore.instance;

  //saving report to firebase firestore
  Future saveReport() async {
    try {
      if (imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please, select Image.")));
      } else {
        final insurgreport = ReportModel(
            comment: titleController.text.trim(),
            user: loggedInUser.email.toString(),
            ishandled: false,
            isassigned: false,
            createdat: DateTime.now().toString());

        await _db.collection("insurgencyreports").add(insurgreport.toMap());

        clearInputs();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("New Report added successfully.")));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Insurgent Activity"),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ListView(
            children: [
              //category dropdown
              DropdownButtonFormField(
                hint: const Text("Select Category"),
                value: selectedCategory,
                items: categoryModel.categories
                    .map(
                      (category) => DropdownMenuItem(
                        child: Text(category.name.toString()),
                        value: category.name.toString(),
                      ),
                    )
                    .toList(),
                onChanged: (newValue) async {
                  setState(() {
                    selectedCategory = newValue as String;
                    categoryModel.categories;
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  size: 20,
                ),
                decoration: const InputDecoration(
                  labelText: "Select Category",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 8,
                  ),
                  prefixIcon: Icon(
                    Icons.menu,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              //end of category
              const SizedBox(
                height: 10,
              ),
              //location dropdown
              DropdownButtonFormField(
                hint: const Text("Select Location"),
                value: selectedLocation,
                items: incidentLocationModel.locations
                    .map(
                      (location) => DropdownMenuItem(
                        child: Text(location.name.toString()),
                        value: location.name.toString(),
                      ),
                    )
                    .toList(),
                onChanged: (newValue) async {
                  setState(() {
                    selectedLocation = newValue as String;
                    incidentLocationModel.locations;
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  size: 20,
                ),
                decoration: const InputDecoration(
                  labelText: "Select Location",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 8,
                  ),
                  prefixIcon: Icon(
                    Icons.menu,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              //end of location
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: titleController,
                validator: (value) => value == "" ? "Title required" : null,
                decoration: const InputDecoration(
                  hintText: "Title",
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: descriptionController,
                maxLines: 3,
                validator: (value) =>
                    value == "" ? "Description required" : null,
                decoration: const InputDecoration(
                  hintText: "Description",
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: imageFile == null ? 0 : 200,
                decoration: BoxDecoration(
                  image: imageFile == null
                      ? null
                      : DecorationImage(
                          image: FileImage(
                            imageFile ?? File(''),
                          ),
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    getImageOption();
                  },
                  icon: const Icon(Icons.camera_alt_outlined)),
              const SizedBox(
                height: 12,
              ),
              MyButton(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    saveReport();
                  }
                },
                text: "Save Report",
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearInputs() {
    titleController.clear();
    descriptionController.clear();
  }
}
