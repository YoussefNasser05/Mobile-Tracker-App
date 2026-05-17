import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/date_utils.dart';
import '../../models/subscription_model.dart';
import '../../providers/subscription_provider.dart';

class AddEditSubscriptionScreen extends StatefulWidget {
  final String? subscriptionId;

  const AddEditSubscriptionScreen({super.key, this.subscriptionId});

  @override
  State<AddEditSubscriptionScreen> createState() =>
      _AddEditSubscriptionScreenState();
}

class _AddEditSubscriptionScreenState
    extends State<AddEditSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  String _category = 'streaming';
  String _currency = 'USD';
  String _billingCycle = 'monthly';
  DateTime _startDate = DateTime.now();
  DateTime _nextBillingDate =
      DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;
  bool _isEditing = false;

  static const _categories = [
    'streaming',
    'gym',
    'saas',
    'utility',
    'other'
  ];
  static const _currencies = ['USD', 'EGP', 'EUR', 'GBP', 'JPY'];
  static const _billingCycles = ['monthly', 'yearly', 'weekly'];

  @override
  void initState() {
    super.initState();
    if (widget.subscriptionId != null) {
      _isEditing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExisting());
    }
  }

  void _loadExisting() {
    final sub = context
        .read<SubscriptionProvider>()
        .findById(widget.subscriptionId!);
    if (sub != null) {
      _nameController.text = sub.name;
      _priceController.text = sub.price.toString();
      _notesController.text = sub.notes ?? '';
      setState(() {
        _category = sub.category;
        _currency = sub.currency;
        _billingCycle = sub.billingCycle;
        _startDate = sub.startDate;
        _nextBillingDate = sub.nextBillingDate;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateNextBillingDate() {
    setState(() {
      _nextBillingDate =
          AppDateUtils.nextBillingDate(_startDate, _billingCycle);
    });
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              onPrimary: AppColors.textPrimary,
              surface: AppColors.surface),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
      _updateNextBillingDate();
    }
  }

  Future<void> _pickNextBillingDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextBillingDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2035),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              onPrimary: AppColors.textPrimary,
              surface: AppColors.surface),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _nextBillingDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final provider = context.read<SubscriptionProvider>();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    try {
      if (_isEditing) {
        final existing =
            provider.findById(widget.subscriptionId!);
        if (existing != null) {
          await provider.update(existing.copyWith(
            name: _nameController.text.trim(),
            category: _category,
            price: price,
            currency: _currency,
            billingCycle: _billingCycle,
            startDate: _startDate,
            nextBillingDate: _nextBillingDate,
            notes: notes,
          ));
        }
      } else {
        await provider.add(Subscription.create(
          name: _nameController.text.trim(),
          category: _category,
          price: price,
          currency: _currency,
          billingCycle: _billingCycle,
          startDate: _startDate,
          nextBillingDate: _nextBillingDate,
          notes: notes,
        ));
      }
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, yyyy');
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          _isEditing ? 'Edit Subscription' : 'Add Subscription',
          style: AppTextStyles.title,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: 'Name *'),
                style:
                    const TextStyle(color: AppColors.textPrimary),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Name is required'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                'Category',
                _category,
                _categories,
                (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _priceController,
                      decoration:
                          const InputDecoration(labelText: 'Price *'),
                      keyboardType:
                          const TextInputType.numberWithOptions(
                              decimal: true),
                      style: const TextStyle(
                          color: AppColors.textPrimary),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        final n = double.tryParse(v);
                        if (n == null || n <= 0) return 'Must be > 0';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdown(
                      'Currency',
                      _currency,
                      _currencies,
                      (v) => setState(() => _currency = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                'Billing Cycle',
                _billingCycle,
                _billingCycles,
                (v) {
                  setState(() => _billingCycle = v!);
                  _updateNextBillingDate();
                },
              ),
              const SizedBox(height: 16),
              _buildDateField('Start Date', _startDate, fmt,
                  _pickStartDate),
              const SizedBox(height: 16),
              _buildDateField('Next Billing Date', _nextBillingDate,
                  fmt, _pickNextBillingDate),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                    labelText: 'Notes (optional)'),
                style:
                    const TextStyle(color: AppColors.textPrimary),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: AppColors.background,
                              strokeWidth: 2),
                        )
                      : Text(_isEditing
                          ? 'Save Changes'
                          : 'Add Subscription'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      key: ValueKey('$label-$value'),
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      dropdownColor: AppColors.surfaceElevated,
      style: const TextStyle(color: AppColors.textPrimary),
      items: options
          .map((o) => DropdownMenuItem(
                value: o,
                child: Text(
                  '${o[0].toUpperCase()}${o.substring(1)}',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField(
    String label,
    DateTime date,
    DateFormat fmt,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accentSoft),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: 2),
                Text(fmt.format(date), style: AppTextStyles.subtitle),
              ],
            ),
            const Icon(Icons.calendar_today_outlined,
                color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
