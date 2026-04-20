import 'package:flutter/material.dart';
import 'services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> _historyData = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    // 🧒 initState runs automatically when screen opens
    // Like a waiter who immediately asks "what would you like?"
    _loadVitals();
  }

  // 🧒 This fetches real data from MongoDB!
  Future<void> _loadVitals() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    final result = await ApiService.getVitals();

    if (result['success'] == true) {
      setState(() {
        _historyData = result['vitals'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result['message'] ?? 'Failed to load vitals!';
        _isLoading = false;
      });
    }
  }

  // 🧒 Format date nicely
  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString).toLocal();
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff Days Ago';
  }

  String _formatFullDate(String dateString) {
    final date = DateTime.parse(dateString).toLocal();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Your past vitals records',
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                      ),
                    ],
                  ),
                  // 🧒 Refresh button — reloads data from server
                  GestureDetector(
                    onTap: _loadVitals,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16213E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Color(0xFF6C63FF),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🧒 Show loading, error, or data
              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                  ),
                )
              else if (_error.isNotEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 50,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _error,
                          style: const TextStyle(color: Colors.white60),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadVitals,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_historyData.isEmpty)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, color: Colors.white38, size: 60),
                        SizedBox(height: 16),
                        Text(
                          'No vitals recorded yet!\nGo to Log tab to add your first reading.',
                          style: TextStyle(color: Colors.white60),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // Summary Cards
                Row(
                  children: [
                    _SummaryCard(
                      title: 'Total Logs',
                      value: '${_historyData.length}',
                      icon: Icons.assignment,
                      color: const Color(0xFF6C63FF),
                    ),
                    const SizedBox(width: 12),
                    _SummaryCard(
                      title: 'Normal',
                      value:
                          '${_historyData.where((d) => d['status'] == 'Normal').length}',
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 12),
                    _SummaryCard(
                      title: 'Warning',
                      value:
                          '${_historyData.where((d) => d['status'] == 'Warning').length}',
                      icon: Icons.warning,
                      color: Colors.orange,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'Recent Records',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Real data list
                Expanded(
                  child: ListView.separated(
                    itemCount: _historyData.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final data = _historyData[index];
                      return _HistoryCard(
                        data: data,
                        dateLabel: _formatDate(data['createdAt']),
                        fullDate: _formatFullDate(data['createdAt']),
                        onDelete: () async {
                          // 🧒 Delete from MongoDB!
                          final result = await ApiService.deleteVital(
                            data['_id'],
                          );
                          if (result['success'] == true) {
                            _loadVitals(); // Reload list
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String dateLabel;
  final String fullDate;
  final VoidCallback onDelete;

  const _HistoryCard({
    required this.data,
    required this.dateLabel,
    required this.fullDate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isWarning = data['status'] == 'Warning';
    final isCritical = data['status'] == 'Critical';
    final statusColor = isCritical
        ? Colors.red
        : isWarning
        ? Colors.orange
        : Colors.green;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    fullDate,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data['status'],
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 🧒 Delete button
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _VitalMini(
                icon: Icons.favorite,
                color: const Color(0xFFFF6B6B),
                value: '${data['heartRate']}',
                unit: 'bpm',
              ),
              _VitalMini(
                icon: Icons.air,
                color: const Color(0xFF00D4FF),
                value: '${data['spo2']}',
                unit: '%',
              ),
              _VitalMini(
                icon: Icons.speed,
                color: const Color(0xFF6C63FF),
                value:
                    '${data['bloodPressure']['systolic']}/${data['bloodPressure']['diastolic']}',
                unit: 'mmHg',
              ),
              _VitalMini(
                icon: Icons.thermostat,
                color: const Color(0xFFFFB347),
                value: '${data['temperature']}',
                unit: '°F',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VitalMini extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String unit;

  const _VitalMini({
    required this.icon,
    required this.color,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(unit, style: const TextStyle(color: Colors.white60, fontSize: 10)),
      ],
    );
  }
}
