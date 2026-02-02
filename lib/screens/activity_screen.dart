import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/payment_service.dart';
import '../models/transaction.dart' as Txn;

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool _loading = true;
  List<Txn.Transaction> _transactions = [];
  List<Txn.Transaction> _allTransactions = [];
  String? _errorMessage;
  String _selectedFilter = 'Today';

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final auth = AuthService();
    final payment = PaymentService();
    try {
      final userId = await auth.getCurrentUserId();
      if (userId == null) throw Exception('No logged-in user');

      // ensure payment service uses same token
      if (auth.getToken() != null) await payment.setAuthToken(auth.getToken()!);

      final txns = await payment.getUserTransactions(userId);
      setState(() {
        _allTransactions = txns;
        _applyFilter();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _transactions = [];
        _allTransactions = [];
        _loading = false;
        _errorMessage = 'Failed to load transactions: ${e.toString()}';
      });
    }
  }

  void _applyFilter() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (_selectedFilter) {
      case 'Today':
        _transactions = _allTransactions.where((t) {
          if (t.createdAt == null) return false;
          final txnDate = DateTime(
            t.createdAt!.year,
            t.createdAt!.month,
            t.createdAt!.day,
          );
          return txnDate == today;
        }).toList();
        break;
      case 'Success':
        _transactions = _allTransactions
            .where((t) => t.status?.name == 'completed')
            .toList();
        break;
      case 'Failed':
        _transactions = _allTransactions
            .where(
              (t) =>
                  t.status?.name == 'failed' || t.status?.name == 'cancelled',
            )
            .toList();
        break;
      default:
        _transactions = _allTransactions;
    }
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'View your Financial\nActivity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A1B5D),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Color(0xFF6B7280)),
                            ),
                          ),
                        ),
                        Icon(Icons.search, color: Color(0xFF6B7280)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filter Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFilterTab('Today', _selectedFilter == 'Today'),
                      _buildFilterTab('Success', _selectedFilter == 'Success'),
                      _buildFilterTab('Failed', _selectedFilter == 'Failed'),
                    ],
                  ),
                ],
              ),
            ),

            // Transactions List
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Color(0xFF6B7280),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadTransactions,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A1B5D),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _transactions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: Color(0xFF6B7280),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No transactions yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your transaction history will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadTransactions,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          final t = _transactions[index];
                          return _buildTransactionItem(
                            t.merchantName ??
                                (t.merchantId != null
                                    ? 'Merchant ${t.merchantId}'
                                    : 'Transaction'),
                            t.amount != null
                                ? '${t.currency ?? 'LKR'} ${t.amount!.toStringAsFixed(2)}'
                                : 'LKR -',
                            _formatDateTime(t.createdAt),
                            t.biometricVerified == true
                                ? 'Face Verified'
                                : 'Face',
                            t.status?.name.toUpperCase() ?? 'UNKNOWN',
                            _getIconForTransaction(t),
                            t.status,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => _onFilterChanged(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0A1B5D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0A1B5D)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    final local = dateTime.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txnDate = DateTime(local.year, local.month, local.day);

    if (txnDate == today) {
      return 'Today ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    } else {
      return '${local.day}/${local.month}/${local.year} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    }
  }

  IconData _getIconForTransaction(Txn.Transaction t) {
    if (t.type?.name == 'refund') return Icons.undo;
    if (t.status?.name == 'completed') return Icons.check_circle;
    if (t.status?.name == 'failed') return Icons.error;
    return Icons.shopping_cart;
  }

  Color _getStatusColor(Txn.TransactionStatus? status) {
    switch (status?.name) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'pending':
      case 'processing':
        return const Color(0xFFF59E0B);
      case 'failed':
      case 'cancelled':
        return const Color(0xFFEF4444);
      case 'refunded':
        return const Color(0xFF6366F1);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Widget _buildTransactionItem(
    String name,
    String amount,
    String dateTime,
    String faceType,
    String status,
    IconData icon,
    Txn.TransactionStatus? statusEnum,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF1E3A8A), size: 24),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF4C3A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      dateTime,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(statusEnum).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(statusEnum),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Face type
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.face,
                  color: Color(0xFF1E3A8A),
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                faceType,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
