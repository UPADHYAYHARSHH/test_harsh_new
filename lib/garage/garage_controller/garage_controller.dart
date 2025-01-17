import 'package:get/get.dart';

import '../garage_model/vehicle_model.dart';

class GarageController extends GetxController {
  RxString selectedVehicleType = ''.obs;
  RxString selectedModel = ''.obs;
  RxString selectedBrand = ''.obs;

  RxString searchText = ''.obs;

  final List<String> vehicleTypes = ['Car', 'Bike'];
  final Map<String, List<String>> brands = {
    'Car': ['Hyundai', 'Toyota', 'Honda', 'Ford'],
    'Bike': ['Yamaha', 'Suzuki', 'Royal Enfield'],
  };
  final Map<String, List<String>> models = {
    'Hyundai': ['Aura', 'Creta', 'i20'],
    'Toyota': ['Innova', 'Fortuner'],
    'Honda': ['City', 'Civic'],
    'Ford': ['Ecosport', 'Mustang'],
    'Yamaha': ['R15', 'FZ'],
    'Suzuki': ['Gixxer', 'Hayabusa'],
    'Royal Enfield': ['Classic 350', 'Himalayan'],
  };

  RxList<VehicleModel> details = <VehicleModel>[
    // Hyundai
    VehicleModel(
      vehicleModel: 'Aura',
      ownerName: 'John Doe',
      serviceDate: '12/12/2021',
      insuranceDate: '12/12/2022',
      price: '₹ 10,00,000',
      ratings: '4.5',
    ),
    VehicleModel(
      vehicleModel: 'Creta',
      ownerName: 'Jane Doe',
      serviceDate: '12/12/2021',
      insuranceDate: '12/12/2022',
      price: '₹ 15,00,000',
      ratings: '4.8',
    ),

    // Toyota
    VehicleModel(
      vehicleModel: 'Innova',
      ownerName: 'Samuel Green',
      serviceDate: '15/01/2023',
      insuranceDate: '15/01/2024',
      price: '₹ 25,00,000',
      ratings: '4.6',
    ),
    VehicleModel(
      vehicleModel: 'Fortuner',
      ownerName: 'Emily Roberts',
      serviceDate: '20/11/2022',
      insuranceDate: '20/11/2023',
      price: '₹ 40,00,000',
      ratings: '4.7',
    ),

    // Honda
    VehicleModel(
      vehicleModel: 'City',
      ownerName: 'Daniel Wilson',
      serviceDate: '05/05/2022',
      insuranceDate: '05/05/2023',
      price: '₹ 12,00,000',
      ratings: '4.4',
    ),
    VehicleModel(
      vehicleModel: 'Civic',
      ownerName: 'Michael Smith',
      serviceDate: '11/11/2022',
      insuranceDate: '11/11/2023',
      price: '₹ 20,00,000',
      ratings: '4.7',
    ),

    // Ford
    VehicleModel(
      vehicleModel: 'Ecosport',
      ownerName: 'Anna Bell',
      serviceDate: '18/06/2021',
      insuranceDate: '18/06/2022',
      price: '₹ 9,00,000',
      ratings: '4.2',
    ),
    VehicleModel(
      vehicleModel: 'Mustang',
      ownerName: 'Lucas Taylor',
      serviceDate: '25/12/2022',
      insuranceDate: '25/12/2023',
      price: '₹ 35,00,000',
      ratings: '4.9',
    ),

    // Bike Models
    // Yamaha
    VehicleModel(
      vehicleModel: 'R15',
      ownerName: 'Prakash Singh',
      serviceDate: '10/09/2022',
      insuranceDate: '10/09/2023',
      price: '₹ 1,75,000',
      ratings: '4.4',
    ),
    VehicleModel(
      vehicleModel: 'FZ',
      ownerName: 'Vikram Reddy',
      serviceDate: '12/03/2021',
      insuranceDate: '12/03/2022',
      price: '₹ 1,30,000',
      ratings: '4.3',
    ),

    // Suzuki
    VehicleModel(
      vehicleModel: 'Gixxer',
      ownerName: 'Ravi Kapoor',
      serviceDate: '20/07/2022',
      insuranceDate: '20/07/2023',
      price: '₹ 1,50,000',
      ratings: '4.5',
    ),
    VehicleModel(
      vehicleModel: 'Hayabusa',
      ownerName: 'Kiran Joshi',
      serviceDate: '02/02/2021',
      insuranceDate: '02/02/2022',
      price: '₹ 18,00,000',
      ratings: '4.8',
    ),

    // Royal Enfield
    VehicleModel(
      vehicleModel: 'Classic 350',
      ownerName: 'Rahul Sharma',
      serviceDate: '10/10/2022',
      insuranceDate: '10/10/2023',
      price: '₹ 2,00,000',
      ratings: '4.3',
    ),
    VehicleModel(
      vehicleModel: 'Himalayan',
      ownerName: 'Sandeep Singh',
      serviceDate: '15/03/2022',
      insuranceDate: '15/03/2023',
      price: '₹ 2,80,000',
      ratings: '4.6',
    ),
  ].obs;

  RxList<VehicleModel> filteredList = <VehicleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize the filtered list with all vehicle details initially
    filteredList.value = details;

    // Debounce the search text changes to avoid filtering too frequently
    debounce(
      searchText,
      (_) => filterVehicles(),
      time: const Duration(milliseconds: 300),
    );
  }

  void filterVehicles() {
    filteredList.value = details.where((vehicle) {
      // Check if the vehicle matches the selected type
      final matchesType = selectedVehicleType.isEmpty ||
          (selectedVehicleType.value == 'Car' && brands['Car']!.contains(selectedBrand.value)) ||
          (selectedVehicleType.value == 'Bike' && brands['Bike']!.contains(selectedBrand.value));

      // Check if the vehicle matches the selected brand
      final matchesBrand = selectedBrand.isEmpty || (brands[selectedVehicleType.value]?.contains(selectedBrand.value) ?? false);

      // Check if the vehicle matches the selected model
      final matchesModel = selectedModel.isEmpty || vehicle.vehicleModel == selectedModel.value;

      // Check if the vehicle matches the search query (case-insensitive)
      final matchesSearch = searchText.isEmpty ||
          vehicle.vehicleModel!.toLowerCase().contains(searchText.value.toLowerCase()) ||
          vehicle.ownerName!.toLowerCase().contains(searchText.value.toLowerCase()) ||
          vehicle.serviceDate!.toLowerCase().contains(searchText.value.toLowerCase()) ||
          vehicle.price!.toLowerCase().contains(searchText.value.toLowerCase());

      return matchesType && matchesBrand && matchesModel && matchesSearch;
    }).toList();
  }

  List<String> getModelsForBrand() {
    return models[selectedBrand.value] ?? [];
  }
}
