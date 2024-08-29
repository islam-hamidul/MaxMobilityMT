import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/customer_controller.dart';


class AddCustomerScreen extends StatelessWidget {
      AddCustomerScreen({super.key});

   final customerController = Get.put(CustomerController());

  void onAddProductScreenPress() {
    if (Get.arguments != null) {
      customerController.handleAddButton(Get.arguments.id);
    } else {
      customerController.handleAddButton();
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      var args = Get.arguments;
      print(args);
      customerController.nameController.value.text = args.name;
      customerController.mobileController.value.text = args.mobile;
      customerController.emailController.value.text = args.email;
      customerController.addressController.value = args.address;
      customerController.latitudeController.value = args.latitude;
      customerController.longitudeController.value = args.longitude;
      customerController.imagePath.value = args.image;
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                controller: customerController.nameController.value,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: TextField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Mobile No",
                  border: OutlineInputBorder(),
                  counterText: "",
                ),
                controller: customerController.mobileController.value,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email Id",
                  border: OutlineInputBorder(),
                ),
                controller: customerController.emailController.value,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 10,
              ),
              child: TextField(
                maxLines: 2,
                controller: customerController.addressController.value,

                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                //  errorText: fullNameError.value.isEmpty ? null : fullNameError.value,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 10,
              ),
              child: TextField(
                controller:  customerController.latitudeController.value,
                decoration: InputDecoration(
                  labelText: "Latitude",
                  border: OutlineInputBorder(),
                //  errorText: mobileError.value.isEmpty ? null : mobileError.value,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 10,
              ),
              child: TextField(

                keyboardType: TextInputType.number,
                controller:  customerController.longitudeController.value,
                decoration: InputDecoration(
                  labelText: "Longitude",
                  border: OutlineInputBorder(),
                  //errorText: emailError.value.isEmpty ? null : emailError.value,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 10,
              ),
              child: TextButton.icon(
                  icon: Icon(Icons.add_photo_alternate),
                  label: FittedBox(
                    child: Obx(
                          () => Text(
                        customerController.imagePath.value == ""
                            ? "Select Image".tr
                            : customerController.imagePath.value.substring(44),
                      ),
                    ),
                  ),
                  onPressed: customerController.getImage

              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontStyle: FontStyle.normal),
                  ),
                  child: Text(
                    "Add Product".tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: onAddProductScreenPress,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}