import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color _emerald = const Color(0xFF059669);
  final Color _slate = const Color(0xFF0F172A);
  final Color _borderColor = const Color(0xFFE2E8F0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'My Rides',
          style: TextStyle(
            color: _slate,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: _emerald,
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: _emerald,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRideList(status: 'Upcoming'),
          _buildRideList(status: 'Completed'),
          _buildRideList(status: 'Cancelled'),
        ],
      ),
    );
  }

  Widget _buildRideList({required String status}) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: 3,
      itemBuilder: (context, index) {
        return _buildRideCard(status: status, index: index);
      },
    );
  }

  Widget _buildRideCard({required String status, required int index}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (status == 'Upcoming') {
              context.push('/ride-requests');
            } else {
              context.push('/ride-detail');
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      index == 0 ? 'Today, 10:00 AM' : (index == 1 ? 'Today, 06:30 PM' : 'Tomorrow, 09:15 AM'),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _slate),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: status == 'Upcoming'
                            ? const Color(0xFFECFDF5)
                            : status == 'Completed'
                                ? const Color(0xFFF1F5F9)
                                : const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: status == 'Upcoming'
                              ? const Color(0xFFA7F3D0)
                              : status == 'Completed'
                                  ? const Color(0xFFE2E8F0)
                                  : const Color(0xFFFECACA),
                        ),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: status == 'Upcoming'
                              ? _emerald
                              : status == 'Completed'
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFFDC2626),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _emerald,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('Andheri West, Mumbai', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: _slate)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3.5),
                  child: Container(
                    width: 1.5,
                    height: 14,
                    color: const Color(0xFFCBD5E1),
                    margin: const EdgeInsets.symmetric(vertical: 2),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEA580C),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('Bandra Kurla Complex (BKC)', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: _slate)),
                  ],
                ),
                const Divider(height: 22, color: Color(0xFFF1F5F9)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.airline_seat_recline_normal_rounded, size: 16, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text('3/4 Seats Booked', style: TextStyle(color: _slate.withOpacity(0.7), fontWeight: FontWeight.w600, fontSize: 12.5)),
                      ],
                    ),
                    if (status == 'Upcoming')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Manage Requests',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _emerald),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios_rounded, size: 10, color: _emerald),
                          ],
                        ),
                      )
                    else
                      Row(
                        children: [
                          Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _slate.withOpacity(0.6))),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios_rounded, size: 10, color: _slate.withOpacity(0.4)),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
