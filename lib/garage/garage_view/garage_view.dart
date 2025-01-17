import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_harsh/garage/garage_controller/garage_controller.dart';

class VehicleView extends StatelessWidget {
  final GarageController garageController = Get.put(GarageController());

  VehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle List',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // three  dropdowns
            Row(
              children: [
                // vehicle type
                Obx(
                  () => DropdownButton<String>(
                    value: garageController.selectedVehicleType.value.isEmpty ? null : garageController.selectedVehicleType.value,
                    onChanged: (value) {
                      garageController.selectedVehicleType.value = value!;
                      garageController.selectedBrand.value = '';
                      garageController.selectedModel.value = '';
                      garageController.filterVehicles();
                    },
                    hint: Text('Select Vehicle Type'),
                    items: garageController.vehicleTypes.isEmpty
                        ? []
                        : garageController.vehicleTypes.map(
                            (type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            },
                          ).toList(),
                  ),
                ),
                const SizedBox(width: 8),

                // brand dropdown
                Expanded(
                  child: Obx(
                    () => DropdownButton<String>(
                      value: garageController.selectedBrand.value.isEmpty ? null : garageController.selectedBrand.value,
                      hint: Text('Select Brand'),
                      onChanged: (value) {
                        garageController.selectedBrand.value = value!;
                        garageController.selectedModel.value = '';
                        garageController.filterVehicles();
                      },
                      items: garageController.brands[garageController.selectedVehicleType.value]?.map(
                        (brand) {
                          return DropdownMenuItem<String>(
                            value: brand,
                            child: Text(brand),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // model dropdown
                Expanded(
                  child: Obx(
                    () {
                      var models = garageController.getModelsForBrand();
                      var uniqueModels = models.toSet().toList();

                      return DropdownButton<String>(
                        value: garageController.selectedModel.value.isEmpty ? null : garageController.selectedModel.value,
                        hint: Text('Select Model'),
                        onChanged: (value) {
                          garageController.selectedModel.value = value!;
                          garageController.filterVehicles();
                        },
                        items: uniqueModels.isEmpty
                            ? []
                            : uniqueModels.map(
                                (model) {
                                  return DropdownMenuItem<String>(
                                    value: model,
                                    child: Text(model),
                                  );
                                },
                              ).toList(),
                      );
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      garageController.searchText.value = value;
                      garageController.filterVehicles();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                      suffixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // table
            Expanded(
              child: Obx(
                () {
                  if (garageController.filteredList.isEmpty) {
                    return Center(
                      child: Text(
                        garageController.searchText.value.isEmpty ? 'No data available' : 'No results found for "${garageController.searchText.value}"',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Vehicle Model')),
                          DataColumn(label: Text('Owner')),
                          DataColumn(label: Text('Service Date')),
                          DataColumn(label: Text('Insurance Due')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Ratings')),
                        ],
                        rows: garageController.filteredList
                            .map(
                              (vehicle) => DataRow(
                                cells: [
                                  DataCell(Text(vehicle.vehicleModel ?? 'N/A')),
                                  DataCell(Text(vehicle.ownerName ?? 'N/A')),
                                  DataCell(Text(vehicle.serviceDate ?? 'N/A')),
                                  DataCell(Text(vehicle.insuranceDate ?? 'N/A')),
                                  DataCell(Text(vehicle.price ?? 'N/A')),
                                  DataCell(Text(vehicle.ratings ?? 'N/A')),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
