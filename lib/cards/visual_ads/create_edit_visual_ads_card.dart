import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io';
import '../../theme/app_theme.dart';
import '../../models/visual_ads.dart';
import '../../providers/visual_ads_provider.dart';

class CreateEditVisualAdsCard extends ConsumerStatefulWidget {
  final VisualAd? ad;
  const CreateEditVisualAdsCard({super.key, this.ad});

  @override
  ConsumerState<CreateEditVisualAdsCard> createState() =>
      _CreateEditVisualAdsCardState();
}

class _CreateEditVisualAdsCardState
    extends ConsumerState<CreateEditVisualAdsCard> {
  final TextEditingController _nameController = TextEditingController();
  String? _imagePath;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.ad != null) {
      _nameController.text = widget.ad!.productName;
      _imagePath = widget.ad!.imagePath;
      _isActive = widget.ad!.isActive;
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _imagePath = result.files.single.path;
      });
    }
  }

  void _submit() {
    final name = _nameController.text.trim();

    if (name.isNotEmpty && _imagePath != null) {
      if (widget.ad == null) {
        ref
            .read(visualAdsProvider.notifier)
            .addAd(name, _imagePath!, _isActive);
      } else {
        ref
            .read(visualAdsProvider.notifier)
            .updateAd(widget.ad!.id, name, _imagePath!, _isActive);
      }
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a product name and image.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.ad != null;

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
              Text(
                isEditing ? 'Edit Visual Ad' : 'Create Visual Ad',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          AppGaps.largeV,
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.lightGrey,
                  style: BorderStyle.solid,
                ),
                image: _imagePath != null
                    ? DecorationImage(
                        image: _imagePath!.startsWith('http')
                            ? NetworkImage(_imagePath!) as ImageProvider
                            : FileImage(File(_imagePath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _imagePath == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.image,
                          size: 40,
                          color: AppColors.darkGrey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap to upload image',
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          AppGaps.largeV,
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Product Name',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          AppGaps.mediumV,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              Switch(
                value: _isActive,
                onChanged: (val) {
                  setState(() {
                    _isActive = val;
                  });
                },
                activeThumbColor: AppColors.black,
              ),
            ],
          ),
          AppGaps.extraLargeV,
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              isEditing ? 'Update Ad' : 'Publish Ad',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
