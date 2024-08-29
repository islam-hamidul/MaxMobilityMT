import 'dart:io';
import 'package:demo_flutter_local_db/views/add_customer_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/customer_controller.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  Future<bool> _onWillPop() async {
    // This will exit the app when the back button is pressed
    SystemNavigator.pop();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Assignment",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              tooltip: 'Menu Icon',
              onPressed: () {},
            ),
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          backgroundColor: Colors.white70,
          body: Column(
            children: [
              CustomerList(),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            onPressed: () {
              Get.to(AddCustomerScreen());
            },
            label: const Text(
              'Add Customer',
              style: TextStyle(color: Colors.black),
            ),
            icon: const Icon(Icons.add, color: Colors.black, size: 25),
          ),
        ),
      ),
    );
  }
}

class CustomerList extends StatelessWidget {
  CustomerList({super.key});

  final customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.builder(
            itemCount: customerController.userList.length,
            itemBuilder: (context, index) {
              final customer = customerController.userList[index];
              print(customer.address);

              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  customerController.deleteCustomer(customer);
                  Get.snackbar(
                    "${customer.name ?? 'Customer'} deleted",
                    "",
                    icon: const Icon(Icons.message),
                    barBlur: 20,
                    isDismissible: true,
                    duration: const Duration(seconds: 2),
                  );
                },
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete,
                    size: 50,
                  ),
                ),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12.0), // Set corner radius here
                  ),
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Check if image path is not null or empty before displaying
                            if (customer.image != null &&
                                customer.image!.isNotEmpty)
                              ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0),
                                  ),
                                  child: Image.file(
                                    File(customer.image!),
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                  ))
                            else
                              const Icon(Icons.person, size: 64),
                            // Placeholder icon
                            Text(
                              customer.name ?? 'Unknown', // Fallback text
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "mobile: ${customer.mobile ?? 'No mobile'}",
                                  // Fallback text
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "email: ${customer.email ?? 'No email'}",
                                  // Fallback text
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "address: ${customer.address ?? 'No address'}",
                                  // Fallback text
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "lati: ${customer.latitude != null ? '${customer.latitude}' : 'No latitude'}",
                                  // Fallback text
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "longi: ${customer.longitude != null ? '${customer.longitude}' : 'No longitude'}", // Fallback text
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    String getLong = customer.longitude != null
                                        ? '${customer.longitude}'
                                        : 'No longitude';

                                    String getLat = customer.latitude != null
                                        ? '${customer.latitude}'
                                        : 'No latitude';

                                    try {
                                      double postLat = double.parse(getLat);
                                      double postLong = double.parse(getLong);
                                      customerController.launchMapOnAndroid(
                                          postLat, postLong);
                                    } catch (e) {
                                      // Handle parsing error
                                      Get.snackbar(
                                        'Error',
                                        'Invalid location data',
                                        icon: const Icon(Icons.error),
                                        isDismissible: true,
                                        duration: const Duration(seconds: 2),
                                      );
                                      return;
                                    }
                                  },
                                  icon: const Icon(Icons.location_on),
                                  label: Text("Redirect Location".tr),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
