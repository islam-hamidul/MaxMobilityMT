import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/database_helper.dart';
import '../models/add_customer.dart';




class CustomerController extends GetxController {
  var picker = ImagePicker().obs;
  var userList = <AddCustomer>[].obs;
  var nameController = TextEditingController().obs;
  var mobileController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var addressController = TextEditingController().obs;
  var latitudeController = TextEditingController().obs;
  var longitudeController = TextEditingController().obs;

  


  void launchMapOnAndroid(double latitude, double longitude) async {
    try {
      const String markerLabel = 'Here';
      final url = Uri.parse(
          'geo:$latitude,$longitude?q=$latitude,$longitude($markerLabel)');
      await launchUrl(url);
    } catch (error) {
      throw 'not found latitude and longitude';
    }
  }
  var imagePath = "".obs;

  void getImage() async {
    final pickedFile = await picker.value.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
    }
  }

  @override
  void onInit() {

    super.onInit();
    fetchCustomers();
  }

  fetchCustomers() async {
    ProductDatabaseHelper.db
        .getCustomerList()
        .then((customerList) => {userList.value = customerList});
  }

  void addCustomer(AddCustomer model) {
    if (model.id != null) {
      print("Inside add product and id is not null ${model.id}");
      ProductDatabaseHelper.db.updateCustomer(model).then((value) {
        updateCustomer(model);
      });
    } else {
      ProductDatabaseHelper.db
          .insertCustomer(model)
          .then((value) => userList.add(model));
    }
  }

  void deleteCustomer(AddCustomer model) {
    ProductDatabaseHelper.db
        .deleteCustomer(model.id!)
        .then((_) => userList.remove(model));
  }

  void updateUserList(AddCustomer model) async {
    var result = await fetchCustomers();
    if (result != null) {
      final index = userList.indexOf(model);
      print(index);
      userList[index] = model;
    }
  }

  void updateCustomer(AddCustomer model) {
    ProductDatabaseHelper.db
        .updateCustomer(model)
        .then((value) => updateUserList(model));
  }

  void handleAddButton([id]) {

    print(id);
    if (id != null) {
      var model = AddCustomer(
        id: id,
        name: nameController.value.text,
        mobile: mobileController.value.text,
        email:emailController.value.text,
        address:addressController.value.text,
        latitude:latitudeController.value.text,
        longitude:longitudeController.value.text,
        image: imagePath.value,
      );
      addCustomer(model);
    } else {
      var model = AddCustomer(
        name: nameController.value.text,
        mobile: mobileController.value.text,
        email:emailController.value.text,
        address:addressController.value.text,
        latitude:latitudeController.value.text,
        longitude:longitudeController.value.text,
        image: imagePath.value,
      );
      addCustomer(model);
    }
    nameController.value.text = "";
    mobileController.value.text = "";
    emailController.value.text = "";
    addressController.value.text = "";
    latitudeController.value.text = "";
    longitudeController.value.text = "";
    imagePath.value = "";
  }




  @override
  void onClose() {
    ProductDatabaseHelper.db.close();
    super.onClose();
  }
}