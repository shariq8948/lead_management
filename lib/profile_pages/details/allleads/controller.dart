// lead_model.dart
import 'package:get/get.dart';

class Lead {
  final String id;
  final String name;
  final String company;
  final String email;
  final String phone;
  final String status;
  final double value;
  final String source;
  final DateTime createdAt;
  final DateTime? lastContact;
  final int tasksCount;
  final String industry;
  final String priority;

  Lead({
    required this.id,
    required this.name,
    required this.company,
    required this.email,
    required this.phone,
    required this.status,
    required this.value,
    required this.source,
    required this.createdAt,
    this.lastContact,
    required this.tasksCount,
    required this.industry,
    required this.priority,
  });
}

// leads_controller.dart

class LeadsController extends GetxController {
  final RxList<Lead> leads = <Lead>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  final Rx<DateTime?> toDate = Rx<DateTime?>(null);

  void updateDateRange(DateTime? from, DateTime? to) {
    fromDate.value = from;
    toDate.value = to;
  }

  // Filters
  final RxString selectedStatus = 'all'.obs;
  final RxString selectedPriority = 'all'.obs;
  final RxString selectedSource = 'all'.obs;
  final RxString selectedIndustry = 'all'.obs;
  final RxString sortBy = 'recent'.obs;
  final RxString searchQuery = ''.obs;

  final RxInt totalLeads = 0.obs;
  final RxDouble totalValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeads();
  }

  Future<void> fetchLeads() async {
    isLoading.value = true;
    try {
      await Future.delayed(Duration(seconds: 1)); // Simulate API call

      leads.value = [
        Lead(
          id: '1',
          name: 'John Smith',
          company: 'Tech Corp',
          email: 'john@techcorp.com',
          phone: '+1 234 567 8900',
          status: 'active',
          value: 50000,
          source: 'referral',
          createdAt: DateTime.now().subtract(Duration(days: 30)),
          lastContact: DateTime.now().subtract(Duration(days: 2)),
          tasksCount: 3,
          industry: 'technology',
          priority: 'high',
        ),
        Lead(
          id: '2',
          name: 'Jane Doe',
          company: 'HealthCo',
          email: 'jane@healthco.com',
          phone: '+1 987 654 3210',
          status: 'inactive',
          value: 30000,
          source: 'email campaign',
          createdAt: DateTime.now().subtract(Duration(days: 60)),
          lastContact: DateTime.now().subtract(Duration(days: 10)),
          tasksCount: 2,
          industry: 'healthcare',
          priority: 'medium',
        ),
        Lead(
          id: '3',
          name: 'Robert Brown',
          company: 'FinancePlus',
          email: 'robert@financeplus.com',
          phone: '+1 345 678 9012',
          status: 'active',
          value: 75000,
          source: 'website',
          createdAt: DateTime.now().subtract(Duration(days: 90)),
          lastContact: DateTime.now().subtract(Duration(days: 5)),
          tasksCount: 4,
          industry: 'finance',
          priority: 'high',
        ),
        Lead(
          id: '4',
          name: 'Emily White',
          company: 'EduWorld',
          email: 'emily@eduworld.com',
          phone: '+1 456 789 0123',
          status: 'won',
          value: 20000,
          source: 'referral',
          createdAt: DateTime.now().subtract(Duration(days: 15)),
          lastContact: DateTime.now().subtract(Duration(days: 1)),
          tasksCount: 1,
          industry: 'education',
          priority: 'low',
        ),
        Lead(
          id: '5',
          name: 'Michael Johnson',
          company: 'Green Energy Inc.',
          email: 'michael@greenenergy.com',
          phone: '+1 567 890 1234',
          status: 'active',
          value: 40000,
          source: 'conference',
          createdAt: DateTime.now().subtract(Duration(days: 45)),
          lastContact: DateTime.now().subtract(Duration(days: 8)),
          tasksCount: 5,
          industry: 'energy',
          priority: 'medium',
        ),
        Lead(
          id: '6',
          name: 'Sarah Lee',
          company: 'Retail Solutions',
          email: 'sarah@retailsol.com',
          phone: '+1 678 901 2345',
          status: 'cold',
          value: 10000,
          source: 'cold call',
          createdAt: DateTime.now().subtract(Duration(days: 20)),
          lastContact: DateTime.now().subtract(Duration(days: 12)),
          tasksCount: 0,
          industry: 'retail',
          priority: 'low',
        ),
        Lead(
          id: '7',
          name: 'David Wilson',
          company: 'AutoSmart',
          email: 'david@autosmart.com',
          phone: '+1 789 012 3456',
          status: 'active',
          value: 90000,
          source: 'ad campaign',
          createdAt: DateTime.now().subtract(Duration(days: 100)),
          lastContact: DateTime.now().subtract(Duration(days: 3)),
          tasksCount: 7,
          industry: 'automobile',
          priority: 'high',
        ),
        Lead(
          id: '8',
          name: 'Sophia Taylor',
          company: 'Foodies',
          email: 'sophia@foodies.com',
          phone: '+1 890 123 4567',
          status: 'cold',
          value: 15000,
          source: 'social media',
          createdAt: DateTime.now().subtract(Duration(days: 12)),
          lastContact: DateTime.now().subtract(Duration(days: 2)),
          tasksCount: 1,
          industry: 'food',
          priority: 'medium',
        ),
        Lead(
          id: '9',
          name: 'James Anderson',
          company: 'RealEstatePro',
          email: 'james@realestatepro.com',
          phone: '+1 901 234 5678',
          status: 'active',
          value: 120000,
          source: 'referral',
          createdAt: DateTime.now().subtract(Duration(days: 40)),
          lastContact: DateTime.now().subtract(Duration(days: 7)),
          tasksCount: 6,
          industry: 'real estate',
          priority: 'high',
        ),
        Lead(
          id: '10',
          name: 'Olivia Martinez',
          company: 'BeautyGlow',
          email: 'olivia@beautyglow.com',
          phone: '+1 123 456 7890',
          status: 'inactive',
          value: 5000,
          source: 'trade show',
          createdAt: DateTime.now().subtract(Duration(days: 50)),
          lastContact: DateTime.now().subtract(Duration(days: 20)),
          tasksCount: 2,
          industry: 'beauty',
          priority: 'low',
        ),
        // Add more unique leads up to 40 entries
      ];

      _updateStats();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch leads');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateStats() {
    totalLeads.value = leads.length;
    totalValue.value = leads.fold(0, (sum, lead) => sum + lead.value);
  }

  List<Lead> get filteredLeads {
    return leads.where((lead) {
      // Add date filtering logic
      bool dateFilter = true;
      if (fromDate.value != null) {
        dateFilter = dateFilter && lead.createdAt.isAfter(fromDate.value!);
      }
      if (toDate.value != null) {
        dateFilter = dateFilter &&
            lead.createdAt.isBefore(toDate.value!.add(Duration(days: 1)));
      }

      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        if (!lead.name.toLowerCase().contains(query) &&
            !lead.company.toLowerCase().contains(query) &&
            !lead.email.toLowerCase().contains(query)) {
          return false;
        }
      }

      if (selectedStatus.value != 'all' &&
          lead.status != selectedStatus.value) {
        return false;
      }

      if (selectedPriority.value != 'all' &&
          lead.priority != selectedPriority.value) {
        return false;
      }

      if (selectedSource.value != 'all' &&
          lead.source != selectedSource.value) {
        return false;
      }

      if (selectedIndustry.value != 'all' &&
          lead.industry != selectedIndustry.value) {
        return false;
      }

      return dateFilter; // Include date filter in final result
    }).toList()
      ..sort((a, b) {
        switch (sortBy.value) {
          case 'recent':
            return b.createdAt.compareTo(a.createdAt);
          case 'value':
            return b.value.compareTo(a.value);
          case 'tasks':
            return b.tasksCount.compareTo(a.tasksCount);
          default:
            return 0;
        }
      });
  }
}
