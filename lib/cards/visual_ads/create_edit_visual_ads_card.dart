import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/visual_ads.dart';
import '../../providers/visual_ads_provider.dart';
import '../../providers/auth_provider.dart';

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
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  String? _existingImageUrl;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.ad != null) {
      _nameController.text = widget.ad!.productName;
      _quantityController.text = widget.ad!.productQuantity ?? '';
      _descriptionController.text = widget.ad!.productDescription ?? '';
      _existingImageUrl = widget.ad!.productImage;
      _isActive = widget.ad!.status == 'active';
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      setState(() {
        _selectedImageBytes = result.files.single.bytes;
        _selectedImageName = result.files.single.name;
      });
    }
  }

  void _submit() async {
    final name = _nameController.text.trim();
    final quantity = _quantityController.text.trim();
    final description = _descriptionController.text.trim();
    final authState = ref.read(authProvider);
    final adminId = authState.value?.adminId;

    if (name.isEmpty) {
      AppTheme.showPremiumSnackBar(
        context: context,
        message: 'Please provide a product name.',
        isError: true,
      );
      return;
    }

    if (widget.ad == null && _selectedImageBytes == null) {
      AppTheme.showPremiumSnackBar(
        context: context,
        message: 'Please select a product image.',
        isError: true,
      );
      return;
    }

    if (adminId == null) return;

    bool success = false;
    if (widget.ad == null) {
      success = await ref
          .read(visualAdsProvider.notifier)
          .addAd(
            adminId: adminId,
            productName: name,
            productQuantity: quantity,
            productDescription: description,
            imageBytes: _selectedImageBytes,
            imageName: _selectedImageName,
          );
    } else {
      success = await ref
          .read(visualAdsProvider.notifier)
          .updateAd(
            visualAdId: widget.ad!.visualAdId,
            productName: name,
            productQuantity: quantity,
            productDescription: description,
            status: _isActive ? 'active' : 'inactive',
            imageBytes: _selectedImageBytes,
            imageName: _selectedImageName,
          );
    }

    if (success) {
      if (!mounted) return;
      AppTheme.showPremiumSnackBar(
        context: context,
        message: widget.ad == null
            ? 'Visual Ad created!'
            : 'Visual Ad updated!',
      );
      context.pop();
    } else {
      if (!mounted) return;
      AppTheme.showPremiumSnackBar(
        context: context,
        message: 'Something went wrong.',
        isError: true,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.ad != null;
    final isLoading = ref.watch(visualAdsProvider).isLoading;

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
      child: SingleChildScrollView(
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
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.lightGrey,
                    style: BorderStyle.solid,
                  ),
                  image: _selectedImageBytes != null
                      ? DecorationImage(
                          image: MemoryImage(_selectedImageBytes!),
                          fit: BoxFit.cover,
                        )
                      : _existingImageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(_existingImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child:
                    (_selectedImageBytes == null && _existingImageUrl == null)
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
            _buildTextField(_nameController, 'Product Name', Iconsax.box),
            AppGaps.mediumV,
            _buildTextField(
              _quantityController,
              'Product Quantity',
              Iconsax.weight,
            ),
            AppGaps.mediumV,
            _buildTextField(
              _descriptionController,
              'Product Description',
              Iconsax.document_text,
              maxLines: 3,
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
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      isEditing ? 'Update Ad' : 'Publish Ad',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.darkGrey),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
