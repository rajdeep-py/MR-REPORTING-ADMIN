import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/team_provider.dart';
import '../../providers/employee_provider.dart';
import '../../models/team.dart';

class CreateEditTeamScreen extends ConsumerStatefulWidget {
  final String? id;
  const CreateEditTeamScreen({super.key, this.id});

  @override
  ConsumerState<CreateEditTeamScreen> createState() => _CreateEditTeamScreenState();
}

class _CreateEditTeamScreenState extends ConsumerState<CreateEditTeamScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  String? _photoPath;
  List<String> _selectedMembers = [];

  bool get isEditing => widget.id != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _descCtrl = TextEditingController();

    if (isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = ref.read(teamProvider);
        try {
          final team = state.teams.firstWhere((t) => t.id == widget.id);
          _nameCtrl.text = team.name;
          _descCtrl.text = team.description;
          setState(() {
            _photoPath = team.photoPath;
            _selectedMembers = List.from(team.memberIds);
          });
        } catch (_) {}
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
      final newTeam = Team(
        id: isEditing ? widget.id! : 'TEAM${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        photoPath: _photoPath,
        memberIds: _selectedMembers,
      );

      final notifier = ref.read(teamProvider.notifier);
      if (isEditing) {
        await notifier.updateTeam(newTeam);
      } else {
        await notifier.addTeam(newTeam);
      }

      if (mounted) context.pop();
    }
  }

  void _toggleMember(String employeeId) {
    setState(() {
      if (_selectedMembers.contains(employeeId)) {
        _selectedMembers.remove(employeeId);
      } else {
        _selectedMembers.add(employeeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(teamProvider).isLoading;
    final employees = ref.watch(employeeProvider).employees;
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: isEditing ? 'Edit Team' : 'Create New Team',
        subtitle: 'Manage team details and members',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Form(
          key: _formKey,
          child: isDesktop ? _buildDesktopLayout(isLoading, employees) : _buildMobileLayout(isLoading, employees),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(bool isLoading, List employees) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildPhotoSection(),
              AppGaps.largeV,
              _buildActionButtons(isLoading),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildDetailsSection(),
              AppGaps.largeV,
              _buildMembersSection(employees),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isLoading, List employees) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPhotoSection(),
        AppGaps.largeV,
        _buildDetailsSection(),
        AppGaps.largeV,
        _buildMembersSection(employees),
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
          Text('Team Photo', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          AppGaps.mediumV,
          GestureDetector(
            onTap: _pickPhoto,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.black.withAlpha(51), width: 2)),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: AppColors.surface,
                    backgroundImage: _photoPath != null ? FileImage(File(_photoPath!)) : null,
                    child: _photoPath == null ? const Icon(Iconsax.camera, size: 40, color: AppColors.black) : null,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.black, shape: BoxShape.circle, border: Border.all(color: AppColors.white, width: 3)),
                  child: const Icon(Iconsax.edit_2, color: AppColors.white, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Team Details', Iconsax.document_text),
          AppGaps.largeV,
          _buildField('Team Name', _nameCtrl, Iconsax.people),
          AppGaps.mediumV,
          _buildField('Description', _descCtrl, Iconsax.text_block, maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildMembersSection(List employees) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Select Members', Iconsax.user_add),
          AppGaps.largeV,
          employees.isEmpty
              ? const Text('No employees available to add.', style: TextStyle(color: AppColors.darkGrey))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final emp = employees[index];
                    final isSelected = _selectedMembers.contains(emp.id);
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      leading: CircleAvatar(
                        backgroundImage: emp.profilePhotoPath != null ? FileImage(File(emp.profilePhotoPath!)) : null,
                        child: emp.profilePhotoPath == null ? const Icon(Iconsax.user, size: 20) : null,
                      ),
                      title: Text(emp.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(emp.headquarter),
                      trailing: Checkbox(
                        value: isSelected,
                        activeColor: AppColors.black,
                        onChanged: (val) => _toggleMember(emp.id),
                      ),
                      onTap: () => _toggleMember(emp.id),
                    );
                  },
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
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.black, size: 20),
        ),
        AppGaps.mediumH,
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      boxShadow: [BoxShadow(color: AppColors.black.withAlpha(5), blurRadius: 16, offset: const Offset(0, 4))],
    );
  }

  Widget _buildActionButtons(bool isLoading) {
    return Row(
      children: [
        Expanded(child: OutlinedButton(onPressed: () => context.pop(), child: const Text('Cancel'))),
        AppGaps.mediumH,
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isLoading ? null : _save,
            child: isLoading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2)) : Text(isEditing ? 'Save Changes' : 'Create Team'),
          ),
        ),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkGrey)),
            const Text(' *', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(prefixIcon: Icon(icon, color: AppColors.darkGrey)),
          validator: (v) => v == null || v.trim().isEmpty ? 'This field is required' : null,
        ),
      ],
    );
  }
}
