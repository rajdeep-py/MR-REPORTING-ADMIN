import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../providers/announcement_provider.dart';
import '../../providers/auth_provider.dart';

class CreateAnnouncementCard extends ConsumerStatefulWidget {
  const CreateAnnouncementCard({super.key});

  @override
  ConsumerState<CreateAnnouncementCard> createState() => _CreateAnnouncementCardState();
}

class _CreateAnnouncementCardState extends ConsumerState<CreateAnnouncementCard> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _submit() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final authState = ref.read(authProvider);
    final adminId = authState.value?.adminId;

    if (adminId == null) return;

    if (title.isNotEmpty && description.isNotEmpty) {
      final success = await ref.read(announcementProvider.notifier).addAnnouncement(
        adminId: adminId,
        title: title,
        description: description,
      );
      
      if (success) {
        if (!mounted) return;
        AppTheme.showPremiumSnackBar(context: context, message: 'Announcement published!');
        context.pop();
      } else {
        if (!mounted) return;
        AppTheme.showPremiumSnackBar(context: context, message: 'Failed to publish announcement.', isError: true);
      }
    } else {
      AppTheme.showPremiumSnackBar(context: context, message: 'Please fill out all fields.', isError: true);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(announcementProvider).isLoading;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Create Announcement', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
            ],
          ),
          AppGaps.largeV,
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Announcement Title',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          AppGaps.mediumV,
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Announcement Description',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          AppGaps.extraLargeV,
          ElevatedButton(
            onPressed: isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: isLoading 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
              : const Text('Publish Announcement', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
