import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/employee_provider.dart';
import '../../models/employee.dart';

class AddEditEmployeeScreen extends ConsumerStatefulWidget {
  final String? id;
  const AddEditEmployeeScreen({super.key, this.id});

  @override
  ConsumerState<AddEditEmployeeScreen> createState() =>
      _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends ConsumerState<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _altPhoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _hqCtrl;
  late TextEditingController _areasCtrl;
  late TextEditingController _targetCtrl;
  late TextEditingController _passCtrl;
  String? _photoPath;

  bool get isEditing => widget.id != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _altPhoneCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _hqCtrl = TextEditingController();
    _areasCtrl = TextEditingController();
    _targetCtrl = TextEditingController();
    _passCtrl = TextEditingController();

    if (isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = ref.read(employeeProvider);
        try {
          final emp = state.employees.firstWhere((e) => e.id == widget.id);
          _nameCtrl.text = emp.fullName;
          _phoneCtrl.text = emp.phoneNo;
          _altPhoneCtrl.text = emp.alternativePhoneNo ?? '';
          _emailCtrl.text = emp.email;
          _hqCtrl.text = emp.headquarter;
          _areasCtrl.text = emp.areasOfWork.join(', ');
          _targetCtrl.text = emp.monthlyTarget.toString();
          _passCtrl.text = emp.password;
          setState(() {
            _photoPath = emp.profilePhotoPath;
          });
        } catch (e) {
          // Fallback if id not found
        }
      });
    }
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _photoPath = result.files.single.path;
      });
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final newEmp = Employee(
        id: isEditing
            ? widget.id!
            : 'EMP${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        fullName: _nameCtrl.text.trim(),
        phoneNo: _phoneCtrl.text.trim(),
        alternativePhoneNo: _altPhoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        headquarter: _hqCtrl.text.trim(),
        areasOfWork: _areasCtrl.text.split(',').map((e) => e.trim()).toList(),
        monthlyTarget: double.tryParse(_targetCtrl.text) ?? 0,
        password: _passCtrl.text.trim(),
        profilePhotoPath: _photoPath,
      );

      final notifier = ref.read(employeeProvider.notifier);
      if (isEditing) {
        await notifier.updateEmployee(newEmp);
      } else {
        await notifier.addEmployee(newEmp);
      }

      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(employeeProvider).isLoading;

    return Scaffold(
      appBar: PremiumAppBar(
        title: isEditing ? 'Edit Employee' : 'Onboard Employee',
        subtitle: 'Fill in the details below',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickPhoto,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.surface,
                    backgroundImage: _photoPath != null
                        ? FileImage(File(_photoPath!))
                        : null,
                    child: _photoPath == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.camera, color: AppColors.darkGrey),
                              SizedBox(height: 4),
                              Text(
                                'Add Photo',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              AppGaps.largeV,
              _buildField('Full Name', _nameCtrl, Iconsax.user),
              AppGaps.mediumV,
              _buildField(
                'Phone No',
                _phoneCtrl,
                Iconsax.call,
                keyboardType: TextInputType.phone,
              ),
              AppGaps.mediumV,
              _buildField(
                'Alternative Phone No (Optional)',
                _altPhoneCtrl,
                Iconsax.call_add,
                keyboardType: TextInputType.phone,
                isRequired: false,
              ),
              AppGaps.mediumV,
              _buildField(
                'Email ID',
                _emailCtrl,
                Iconsax.sms,
                keyboardType: TextInputType.emailAddress,
              ),
              AppGaps.mediumV,
              _buildField('Headquarter', _hqCtrl, Iconsax.location),
              AppGaps.mediumV,
              _buildField(
                'Areas of Work (Comma separated)',
                _areasCtrl,
                Iconsax.map,
              ),
              AppGaps.mediumV,
              _buildField(
                'Monthly Target',
                _targetCtrl,
                Iconsax.money,
                keyboardType: TextInputType.number,
              ),
              AppGaps.mediumV,
              _buildField('Password', _passCtrl, Iconsax.lock),
              AppGaps.extraLargeV,
              ElevatedButton(
                onPressed: isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(isEditing ? 'Save Changes' : 'Onboard Employee'),
              ),
              AppGaps.largeV,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.darkGrey),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.black),
            ),
          ),
          validator: isRequired
              ? (v) => v == null || v.isEmpty ? 'Required' : null
              : null,
        ),
      ],
    );
  }
}
