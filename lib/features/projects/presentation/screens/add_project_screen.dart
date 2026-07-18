import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/project_bloc.dart';
import '../bloc/project_event.dart';
import '../bloc/project_state.dart';

class AddProjectScreen extends StatelessWidget {
  const AddProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectBloc, ProjectState>(
      listener: (context, state) {
        if (state is ProjectCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Project created successfully! 🎉'),
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
      child: const _AddProjectForm(),
    );
  }
}

class _AddProjectForm extends StatefulWidget {
  const _AddProjectForm();

  @override
  State<_AddProjectForm> createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<_AddProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _detailsController = TextEditingController();
  final _liveLinkController = TextEditingController();
  final _githubController = TextEditingController();
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _liveLinkController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> files = await _picker.pickMultiImage(
      imageQuality: 85,
    );
    if (files.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(files.map((f) => File(f.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one image'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
      context.read<ProjectBloc>().add(
            CreateProjectEvent(
              name: _nameController.text.trim(),
              details: _detailsController.text.trim(),
              liveLink: _liveLinkController.text.trim(),
              github: _githubController.text.trim(),
              images: _selectedImages,
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
        title: const Text('Add New Project'),
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
            _buildSectionTitle(context, 'Project Info', Icons.info_outline_rounded),
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
            _buildSectionTitle(
                context, 'Links', Icons.link_rounded),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _liveLinkController,
              label: 'Live Demo URL',
              hint: 'https://example.com',
              icon: Icons.launch_rounded,
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
                context, 'Project Images', Icons.photo_library_rounded),
            const SizedBox(height: 16),
            _buildImagePicker(context),
            const SizedBox(height: 40),
            BlocBuilder<ProjectBloc, ProjectState>(
              builder: (context, state) {
                final isLoading = state is ProjectActionLoading;
                return _buildSubmitButton(context, isLoading);
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
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
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

  Widget _buildImagePicker(BuildContext context) {
    return Column(
      children: [
        // Image Grid
        if (_selectedImages.isNotEmpty) ...[
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              separatorBuilder: (a, b) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImages[index],
                        width: 100,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
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

        // Add Image Button
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.4),
                style: BorderStyle.solid,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  color: AppTheme.primaryLight,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedImages.isEmpty
                      ? 'Tap to add images'
                      : 'Add more images',
                  style: TextStyle(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                if (_selectedImages.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${_selectedImages.length} image(s) selected',
                    style: const TextStyle(
                      color: AppTheme.textHint,
                      fontSize: 12,
                    ),
                  ),
                ],
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
                          'Creating Project...',
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
                        Icon(Icons.add_circle_outline_rounded,
                            color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Create Project',
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
