import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/side_nav_bar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _companyIdController;
  late TextEditingController _companyNameController;
  late TextEditingController _cinController;
  late TextEditingController _gstinController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _altPhoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _companyIdController = TextEditingController();
    _companyNameController = TextEditingController();
    _cinController = TextEditingController();
    _gstinController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _altPhoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final authState = ref.read(authProvider);
      
      Future.microtask(() {
        if (!mounted) return;
        final profileNotifier = ref.read(profileProvider.notifier);
        profileNotifier.init(authState.value);
        
        final user = ref.read(profileProvider).user;
        if (user != null) {
          _companyIdController.text = user.companyId ?? '';
          _companyNameController.text = user.companyName ?? '';
          _cinController.text = user.cinNo ?? '';
          _gstinController.text = user.gstin ?? '';
          _addressController.text = user.address ?? '';
          _phoneController.text = user.phoneNo ?? '';
          _altPhoneController.text = user.alternativePhoneNo ?? '';
          _emailController.text = user.email;
        }
      });
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _companyIdController.dispose();
    _companyNameController.dispose();
    _cinController.dispose();
    _gstinController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(profileProvider.notifier).updateProfile(
        companyId: _companyIdController.text.trim(),
        address: _addressController.text.trim(),
        phoneNo: _phoneController.text.trim(),
        alternativePhoneNo: _altPhoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final profileState = ref.read(profileProvider);
      if (profileState.error != null) {
        if (!mounted) return;
        AppTheme.showPremiumSnackBar(
          context: context,
          message: profileState.error!,
          isError: true,
        );
      } else if (profileState.isSuccess) {
        if (!mounted) return;
        AppTheme.showPremiumSnackBar(
          context: context,
          message: 'Profile updated successfully!',
        );
        _passwordController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final isLoading = profileState.isLoading;

    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Profile',
        subtitle: 'Manage your company details',
      ),
      drawer: const SideNavBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppGaps.screenPadding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Premium Header
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.lightGrey, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withAlpha(10),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.lightGrey, width: 2),
                              ),
                              child: const Icon(
                                Iconsax.building_3,
                                size: 40,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profileState.user?.name ?? 'Organisation Admin',
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      color: AppColors.black,
                                    ),
                                  ),
                                  AppGaps.smallV,
                                  Text(
                                    profileState.user?.companyName ?? 'Your Company',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.darkGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppGaps.extraLargeV,
                      AppGaps.mediumV,
                      
                      // Form Section
                      Text(
                        'Company Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      AppGaps.largeV,

                      _buildResponsiveRow(
                        isDesktop,
                        [
                          _buildTextField(
                            controller: _companyIdController,
                            label: 'Company ID',
                            icon: Iconsax.tag,
                            readOnly: false,
                          ),
                          _buildTextField(
                            controller: _companyNameController,
                            label: 'Company Name',
                            icon: Iconsax.building,
                            readOnly: true,
                          ),
                        ],
                      ),
                      AppGaps.largeV,

                      _buildResponsiveRow(
                        isDesktop,
                        [
                          _buildTextField(
                            controller: _cinController,
                            label: 'CIN No',
                            icon: Iconsax.document_text,
                            readOnly: true,
                          ),
                          _buildTextField(
                            controller: _gstinController,
                            label: 'GSTIN',
                            icon: Iconsax.receipt_2,
                            readOnly: true,
                          ),
                        ],
                      ),
                      AppGaps.largeV,

                      _buildTextField(
                        controller: _addressController,
                        label: 'Address',
                        icon: Iconsax.location,
                      ),
                      AppGaps.extraLargeV,

                      Text(
                        'Contact Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      AppGaps.largeV,

                      _buildResponsiveRow(
                        isDesktop,
                        [
                          _buildTextField(
                            controller: _phoneController,
                            label: 'Phone No',
                            icon: Iconsax.call,
                            keyboardType: TextInputType.phone,
                          ),
                          _buildTextField(
                            controller: _altPhoneController,
                            label: 'Alternative Phone No',
                            icon: Iconsax.call_add,
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                      AppGaps.extraLargeV,

                      Text(
                        'Security',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      AppGaps.largeV,

                      _buildResponsiveRow(
                        isDesktop,
                        [
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email ID',
                            icon: Iconsax.sms,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          _buildTextField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: Iconsax.lock,
                            obscureText: true,
                            hintText: 'Enter new password to change',
                          ),
                        ],
                      ),
                      AppGaps.extraLargeV,
                      AppGaps.largeV,

                      // Update Button
                      Align(
                        alignment: isDesktop ? Alignment.centerRight : Alignment.center,
                        child: SizedBox(
                          width: isDesktop ? 200 : double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleUpdate,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
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
                                : const Text('Update Profile'),
                          ),
                        ),
                      ),
                      AppGaps.extraLargeV,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResponsiveRow(bool isDesktop, List<Widget> children) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.map((child) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: child == children.last ? 0 : 24.0,
            ),
            child: child,
          ),
        )).toList(),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children.map((child) => Padding(
          padding: EdgeInsets.only(
            bottom: child == children.last ? 0 : 24.0,
          ),
          child: child,
        )).toList(),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        AppGaps.smallV,
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: readOnly ? AppColors.darkGrey : AppColors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText ?? label,
            prefixIcon: Icon(icon, color: AppColors.darkGrey),
            filled: true,
            fillColor: readOnly ? AppColors.lightGrey.withAlpha(76) : AppColors.surface,
          ),
          validator: (value) {
            if (!readOnly && !obscureText && (value == null || value.isEmpty)) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }
}
