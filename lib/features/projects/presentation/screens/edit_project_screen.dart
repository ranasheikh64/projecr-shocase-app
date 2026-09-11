import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/project_entity.dart';
import '../bloc/project_bloc.dart';
import '../bloc/project_event.dart';
import '../bloc/project_state.dart';

class EditProjectScreen extends StatelessWidget {
  final ProjectEntity project;

  const EditProjectScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectBloc, ProjectState>(
      listener: (context, state) {
        if (state is ProjectUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Project updated successfully! ✅'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          Navigator.pop(context);
        } else if (state is ProjectError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      },
      child: _EditProjectForm(project: project),
    );
  }
}

class _EditProjectForm extends StatefulWidget {
  final ProjectEntity project;

  const _EditProjectForm({required this.project});

  @override
  State<_EditProjectForm> createState() => _EditProjectFormState();
}

class _EditProjectFormState extends State<_EditProjectForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _detailsController;
  late final TextEditingController _googlePlayStoreController;
  late final TextEditingController _appleAppStoreController;
  late final TextEditingController _githubController;
  final List<File> _newImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name);
    _detailsController = TextEditingController(text: widget.project.details);
    _googlePlayStoreController = TextEditingController(text: widget.project.googlePlayStore);
    _appleAppStoreController = TextEditingController(text: widget.project.appleAppStore);
    _githubController = TextEditingController(text: widget.project.github);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _googlePlayStoreController.dispose();
    _appleAppStoreController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  Future<void> _pickNewImages() async {
    final List<XFile> files = await _picker.pickMultiImage(imageQuality: 85);
    if (files.isNotEmpty) {
      setState(() {
        _newImages.addAll(files.map((f) => File(f.path)));
      });
    }
  }

  void _removeNewImage(int index) {
    setState(() => _newImages.removeAt(index));
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<ProjectBloc>().add(
            UpdateProjectEvent(
              id: widget.project.id,
              name: _nameController.text.trim(),
              details: _detailsController.text.trim(),
              googlePlayStore: _googlePlayStoreController.text.trim(),
              appleAppStore: _appleAppStoreController.text.trim(),
              github: _githubController.text.trim(),
              newImages: _newImages.isNotEmpty ? _newImages : null,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppTheme.textPrimary),
          ),
        ),
        title: const Text('Edit Project'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.dividerColor),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // ID Badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tag_rounded,
                      color: AppTheme.textHint, size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'ID: ',
                    style: TextStyle(
                        color: AppTheme.textHint, fontSize: 12),
                  ),
                  Expanded(
                    child: Text(
                      widget.project.id,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle(
                context, 'Project Info', Icons.info_outline_rounded),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _nameController,
              label: 'Project Name',
              hint: 'e.g. My Portfolio App',
              icon: Icons.title_rounded,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _detailsController,
              label: 'Project Description',
              hint: 'Describe what this project does...',
              icon: Icons.description_outlined,
              maxLines: 4,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Description is required' : null,
            ),
            const SizedBox(height: 32),

            _buildSectionTitle(context, 'Links', Icons.link_rounded),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _googlePlayStoreController,
              label: 'Google Play Store URL',
              hint: 'https://play.google.com/...',
              icon: Icons.shop_rounded,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _appleAppStoreController,
              label: 'Apple App Store URL',
              hint: 'https://apps.apple.com/...',
              icon: Icons.shop_rounded,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _githubController,
              label: 'GitHub URL',
              hint: 'https://github.com/username/repo',
              icon: Icons.code_rounded,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 32),

            _buildSectionTitle(
                context, 'Current Images', Icons.photo_library_rounded),
            const SizedBox(height: 12),

            // Existing images (read-only preview)
            if (widget.project.images.isNotEmpty) ...[
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.project.images.length,
                  separatorBuilder: (a, b) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: widget.project.images[index],
                            width: 100,
                            height: 110,
                            fit: BoxFit.cover,
                            placeholder: (ctx, url) => Container(
                              color: AppTheme.bgCardLight,
                              width: 100,
                              height: 110,
                            ),
                            errorWidget: (ctx, url, err) => Container(
                              color: AppTheme.bgCardLight,
                              width: 100,
                              height: 110,
                              child: const Icon(Icons.broken_image,
                                  color: AppTheme.textHint),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload new images below to replace existing ones',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textHint,
                    ),
              ),
              const SizedBox(height: 16),
            ],

            _buildSectionTitle(
                context, 'Replace with New Images', Icons.upload_rounded),
            const SizedBox(height: 12),
            _buildNewImagePicker(context),

            const SizedBox(height: 40),
            BlocBuilder<ProjectBloc, ProjectState>(
              builder: (context, state) {
                return _buildSubmitButton(
                    context, state is ProjectActionLoading);
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
      BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryLight, size: 18),
        ),
        const SizedBox(width: 12),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppTheme.textPrimary),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.textHint, size: 20),
      ),
    );
  }

  Widget _buildNewImagePicker(BuildContext context) {
    return Column(
      children: [
        if (_newImages.isNotEmpty) ...[
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _newImages.length,
              separatorBuilder: (a, b) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _newImages[index],
                        width: 100,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeNewImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.errorColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 12),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
        GestureDetector(
          onTap: _pickNewImages,
          child: Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.upload_rounded,
                    color: AppTheme.primaryLight, size: 28),
                const SizedBox(height: 6),
                Text(
                  _newImages.isEmpty
                      ? 'Upload new images (optional)'
                      : '${_newImages.length} new image(s) — tap to add more',
                  style: const TextStyle(
                      color: AppTheme.primaryLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        gradient: isLoading ? null : AppTheme.primaryGradient,
        color: isLoading ? AppTheme.bgCard : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLoading
            ? null
            : [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading ? null : _submit,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryLight,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Updating Project...',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_rounded, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
