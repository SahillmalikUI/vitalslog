import 'package:flutter/material.dart';
import 'services/api_service.dart';

class LogVitalsScreen extends StatefulWidget {
  const LogVitalsScreen({super.key});

  @override
  State<LogVitalsScreen> createState() => _LogVitalsScreenState();
}

class _LogVitalsScreenState extends State<LogVitalsScreen> {
  final _heartRateController = TextEditingController();
  final _spo2Controller = TextEditingController();
  final _bpSystolicController = TextEditingController();
  final _bpDiastolicController = TextEditingController();
  final _temperatureController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveVitals() async {
    if (_heartRateController.text.isEmpty ||
        _spo2Controller.text.isEmpty ||
        _bpSystolicController.text.isEmpty ||
        _bpDiastolicController.text.isEmpty ||
        _temperatureController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all vitals!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // 🧒 Send vitals to real backend!
    final result = await ApiService.saveVitals(
      heartRate: double.parse(_heartRateController.text),
      spo2: double.parse(_spo2Controller.text),
      systolic: double.parse(_bpSystolicController.text),
      diastolic: double.parse(_bpDiastolicController.text),
      temperature: double.parse(_temperatureController.text),
    );

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      // Clear all fields
      _heartRateController.clear();
      _spo2Controller.clear();
      _bpSystolicController.clear();
      _bpDiastolicController.clear();
      _temperatureController.clear();

      // 🧒 Show what status the server calculated!
      final status = result['vital']['status'];
      final statusColor = status == 'Normal'
          ? Colors.green
          : status == 'Warning'
          ? Colors.orange
          : Colors.red;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Vitals saved! Status: $status'),
          backgroundColor: statusColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to save vitals!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Header
              const Text(
                'Log Vitals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Enter your health readings for today',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),

              const SizedBox(height: 10),

              // Date indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF6C63FF).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF6C63FF),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Today — ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      style: const TextStyle(
                        color: Color(0xFF6C63FF),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Heart Rate
              _VitalInputCard(
                title: 'Heart Rate',
                unit: 'bpm',
                hint: 'e.g. 72',
                icon: Icons.favorite,
                color: const Color(0xFFFF6B6B),
                controller: _heartRateController,
                normalRange: 'Normal: 60–100 bpm',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              // SpO2
              _VitalInputCard(
                title: 'SpO2',
                unit: '%',
                hint: 'e.g. 98',
                icon: Icons.air,
                color: const Color(0xFF00D4FF),
                controller: _spo2Controller,
                normalRange: 'Normal: 95–100%',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              // Blood Pressure
              _BloodPressureCard(
                systolicController: _bpSystolicController,
                diastolicController: _bpDiastolicController,
              ),

              const SizedBox(height: 16),

              // Temperature
              _VitalInputCard(
                title: 'Temperature',
                unit: '°F',
                hint: 'e.g. 98.6',
                icon: Icons.thermostat,
                color: const Color(0xFFFFB347),
                controller: _temperatureController,
                normalRange: 'Normal: 97–99°F',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveVitals,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Save Vitals',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _VitalInputCard extends StatelessWidget {
  final String title;
  final String unit;
  final String hint;
  final IconData icon;
  final Color color;
  final TextEditingController controller;
  final String normalRange;
  final TextInputType keyboardType;

  const _VitalInputCard({
    required this.title,
    required this.unit,
    required this.hint,
    required this.icon,
    required this.color,
    required this.controller,
    required this.normalRange,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                normalRange,
                style: TextStyle(color: color.withOpacity(0.7), fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: Colors.white24,
                      fontSize: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  unit,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BloodPressureCard extends StatelessWidget {
  final TextEditingController systolicController;
  final TextEditingController diastolicController;

  const _BloodPressureCard({
    required this.systolicController,
    required this.diastolicController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6C63FF).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.speed,
                  color: Color(0xFF6C63FF),
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Blood Pressure',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Text(
                'Normal: 90/60–120/80',
                style: TextStyle(color: Color(0xFF6C63FF), fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Systolic',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: systolicController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: '120',
                        hintStyle: TextStyle(
                          color: Colors.white24,
                          fontSize: 22,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                '/',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Diastolic',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: diastolicController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: '80',
                        hintStyle: TextStyle(
                          color: Colors.white24,
                          fontSize: 22,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'mmHg',
                  style: TextStyle(
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
