import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/employee_provider.dart';
import '../../providers/auth_provider.dart';

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
  late TextEditingController _designationCtrl;

  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  String? _existingPhotoUrl;

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
    _designationCtrl = TextEditingController();

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
          _designationCtrl.text = emp.designation;
          _targetCtrl.text = emp.monthlyTarget?.toString() ?? '';
          _passCtrl.text = ''; // Password shouldn't be visible

          // Area of Work
          if (emp.areaOfWork != null) {
            final areas = emp.areaOfWork!['areas'] as List?;
            _areasCtrl.text = areas?.join(', ') ?? '';
          }

          setState(() {
            _existingPhotoUrl = emp.profilePhotoPath;
          });
        } catch (e) {
          // Fallback if id not found
        }
      });
    }
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedImageBytes = result.files.single.bytes;
        _selectedImageName = result.files.single.name;
      });
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final authState = ref.read(authProvider);
      final adminId = authState.value?.adminId;
      if (adminId == null) return;

      final notifier = ref.read(employeeProvider.notifier);
      final areas = _areasCtrl.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final areaOfWork = {'areas': areas};

      bool success = false;
      if (isEditing) {
        success = await notifier.updateEmployee(
          employeeId: widget.id!,
          fullName: _nameCtrl.text.trim(),
          phoneNo: _phoneCtrl.text.trim(),
          alternativePhoneNo: _altPhoneCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text.isEmpty ? null : _passCtrl.text.trim(),
          headquarter: _hqCtrl.text.trim(),
          designation: _designationCtrl.text.trim(),
          monthlyTarget: int.tryParse(_targetCtrl.text),
          areaOfWork: areaOfWork,
          imageBytes: _selectedImageBytes,
          imageName: _selectedImageName,
        );
      } else {
        success = await notifier.addEmployee(
          fullName: _nameCtrl.text.trim(),
          phoneNo: _phoneCtrl.text.trim(),
          alternativePhoneNo: _altPhoneCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text.trim(),
          designation: _designationCtrl.text.trim(),
          adminId: adminId,
          headquarter: _hqCtrl.text.trim(),
          monthlyTarget: int.tryParse(_targetCtrl.text),
          areaOfWork: areaOfWork,
          imageBytes: _selectedImageBytes,
          imageName: _selectedImageName,
        );
      }

      if (success) {
        if (!mounted) return;
        AppTheme.showPremiumSnackBar(
          context: context,
          message: isEditing
              ? 'Employee updated successfully!'
              : 'Employee onboarded successfully!',
        );
        context.pop();
      } else {
        if (!mounted) return;
        AppTheme.showPremiumSnackBar(
          context: context,
          message: 'Failed to save employee. Please try again.',
          isError: true,
        );
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _altPhoneCtrl.dispose();
    _emailCtrl.dispose();
    _hqCtrl.dispose();
    _areasCtrl.dispose();
    _targetCtrl.dispose();
    _passCtrl.dispose();
    _designationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(employeeProvider).isLoading;
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: isEditing ? 'Edit Employee' : 'Onboard Employee',
        subtitle: isEditing
            ? 'Update employee records'
            : 'Register a new field force member',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Form(
          key: _formKey,
          child: isDesktop
              ? _buildDesktopLayout(isLoading)
              : _buildMobileLayout(isLoading),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(bool isLoading) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildPhotoSection(),
              AppGaps.largeV,
              _buildSecuritySection(),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildPersonalSection(),
              AppGaps.largeV,
              _buildWorkSection(),
              AppGaps.extraLargeV,
              _buildActionButtons(isLoading),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPhotoSection(),
        AppGaps.largeV,
        _buildPersonalSection(),
        AppGaps.largeV,
        _buildWorkSection(),
        AppGaps.largeV,
        _buildSecuritySection(),
        AppGaps.extraLargeV,
        _buildActionButtons(isLoading),
        AppGaps.largeV,
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Text(
            'Profile Photo',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          AppGaps.mediumV,
          GestureDetector(
            onTap: _pickPhoto,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.black.withAlpha(51),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: AppColors.surface,
                    backgroundImage: _selectedImageBytes != null
                        ? MemoryImage(_selectedImageBytes!)
                        : (_existingPhotoUrl != null
                                  ? NetworkImage(_existingPhotoUrl!)
                                  : null)
                              as ImageProvider?,
                    child:
                        (_selectedImageBytes == null &&
                            _existingPhotoUrl == null)
                        ? const Icon(
                            Iconsax.camera,
                            size: 40,
                            color: AppColors.black,
                          )
                        : null,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 3),
                  ),
                  child: const Icon(
                    Iconsax.edit_2,
                    color: AppColors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          AppGaps.mediumV,
          const Text(
            'Allowed formats: JPG, PNG.\nMax size: 2MB',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.coolGrey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Personal Information', Iconsax.personalcard),
          AppGaps.largeV,
          _buildField('Full Name', _nameCtrl, Iconsax.user),
          AppGaps.mediumV,
          Row(
            children: [
              Expanded(
                child: _buildField(
                  'Phone No',
                  _phoneCtrl,
                  Iconsax.call,
                  keyboardType: TextInputType.phone,
                ),
              ),
              AppGaps.mediumH,
              Expanded(
                child: _buildField(
                  'Alternative Phone No',
                  _altPhoneCtrl,
                  Iconsax.call_add,
                  keyboardType: TextInputType.phone,
                  isRequired: false,
                ),
              ),
            ],
          ),
          AppGaps.mediumV,
          _buildField(
            'Email ID',
            _emailCtrl,
            Iconsax.sms,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Work Setup', Iconsax.briefcase),
          AppGaps.largeV,
          Row(
            children: [
              Expanded(
                child: _buildField(
                  'Designation',
                  _designationCtrl,
                  Iconsax.teacher,
                ),
              ),
              AppGaps.mediumH,
              Expanded(
                child: _buildField('Headquarter', _hqCtrl, Iconsax.location),
              ),
            ],
          ),
          AppGaps.mediumV,
          _buildField(
            'Monthly Target (₹)',
            _targetCtrl,
            Iconsax.money,
            keyboardType: TextInputType.number,
            isRequired: false,
          ),
          AppGaps.mediumV,
          _buildField(
            'Areas of Work (Comma separated)',
            _areasCtrl,
            Iconsax.map,
            isRequired: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Security Settings', Iconsax.shield_tick),
          AppGaps.largeV,
          _buildField(
            'Account Password',
            _passCtrl,
            Iconsax.lock,
            isPassword: true,
            isRequired: !isEditing,
          ),
          if (isEditing)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Leave blank to keep current password',
                style: TextStyle(color: AppColors.coolGrey, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.black, size: 20),
        ),
        AppGaps.mediumH,
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withAlpha(5),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isLoading) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => context.pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        AppGaps.mediumH,
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isLoading ? null : _save,
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(isEditing ? 'Save Changes' : 'Complete Onboarding'),
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    bool isRequired = true,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.darkGrey),
          ),
          validator: isRequired
              ? (v) => v == null || v.trim().isEmpty
                    ? 'This field is required'
                    : null
              : null,
        ),
      ],
    );
  }
}
