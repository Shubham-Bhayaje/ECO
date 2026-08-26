import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  String _fuelType = 'Petrol';
  int _seats = 4;

  final List<String> _fuelTypes = ['Petrol', 'Diesel', 'CNG', 'Electric'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Add Vehicle', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Vehicle Identification', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    const SizedBox(height: 12),
                    _buildTextField(label: 'Make', initialValue: 'Honda', icon: Icons.directions_car_rounded),
                    const SizedBox(height: 12),
                    _buildTextField(label: 'Model', initialValue: 'City ZX', icon: Icons.car_repair_rounded),
                    const SizedBox(height: 12),
                    _buildTextField(label: 'Manufacturing Year', initialValue: '2022', icon: Icons.calendar_today_rounded, isNumber: true),
                    const SizedBox(height: 12),
                    _buildTextField(label: 'Registration Number Plate', initialValue: 'MH 02 EE 4589', icon: Icons.pin_rounded),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Fuel & Cost Parameters', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Fuel Type',
                        prefixIcon: const Icon(Icons.local_gas_station_rounded, color: Color(0xFF059669)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                      value: _fuelType,
                      items: _fuelTypes.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                      onChanged: (v) => setState(() => _fuelType = v!),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      label: 'Certified Mileage (km/L)',
                      initialValue: '16.5',
                      icon: Icons.speed_rounded,
                      isNumber: true,
                      helperText: 'Used for exact per-km fuel cost recovery formula',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Available Seats (1-7):', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline_rounded, color: Color(0xFF64748B)),
                              onPressed: () => setState(() => _seats = _seats > 1 ? _seats - 1 : 1),
                            ),
                            Text('$_seats', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF059669)),
                              onPressed: () => setState(() => _seats = _seats < 7 ? _seats + 1 : 7),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vehicle Honda City (MH 02 EE 4589) added successfully!'),
                        backgroundColor: Color(0xFF059669),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    context.pop();
                  },
                  child: const Text('Save Vehicle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTextField({required String label, String? initialValue, required IconData icon, bool isNumber = false, String? helperText}) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: Icon(icon, color: const Color(0xFF0F172A), size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}
