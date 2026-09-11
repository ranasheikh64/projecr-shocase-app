import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/project_entity.dart';
import '../bloc/project_bloc.dart';
import '../bloc/project_event.dart';
import '../bloc/project_state.dart';
import 'edit_project_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectEntity project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectBloc, ProjectState>(
      listener: (context, state) {
        if (state is ProjectDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Project deleted successfully'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is ProjectError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.bgDark,
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: _buildBody(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: project.images.isNotEmpty ? 280 : 100,
      pinned: true,
      backgroundColor: AppTheme.bgDark,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 18),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditProjectScreen(project: project),
              ),
            );
            if (context.mounted) {
              context.read<ProjectBloc>().add(const LoadAllProjectsEvent());
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
          ),
        ),
        GestureDetector(
          onTap: () => _showDeleteDialog(context),
          child: Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.delete_outline_rounded,
                color: AppTheme.errorColor, size: 18),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: project.images.isNotEmpty
            ? _buildImageCarousel(context)
            : Container(
                decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
              ),
      ),
    );
  }

  Widget _buildImageCarousel(BuildContext context) {
    if (project.images.length == 1) {
      return CachedNetworkImage(
        imageUrl: project.images.first,
        fit: BoxFit.cover,
        placeholder: (_, url) => Container(color: AppTheme.bgCardLight),
        errorWidget: (_, url, err) => Container(color: AppTheme.bgCardLight),
      );
    }

    return PageView.builder(
      itemCount: project.images.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: project.images[index],
          fit: BoxFit.cover,
          placeholder: (_, url) => Container(color: AppTheme.bgCardLight),
          errorWidget: (_, url, err) => Container(color: AppTheme.bgCardLight),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bgDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            project.name,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),

          // Image count badge
          if (project.images.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_library_rounded,
                      color: AppTheme.primaryLight, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Swipe image to see all',
                    style: TextStyle(
                      color: AppTheme.primaryLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),
          const Divider(color: AppTheme.dividerColor),
          const SizedBox(height: 20),

          // About
          _buildSection(
            context,
            icon: Icons.description_outlined,
            title: 'About',
            child: Text(
              project.details,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.6,
                  ),
            ),
          ),

          const SizedBox(height: 24),

          // Links
          _buildSection(
            context,
            icon: Icons.link_rounded,
            title: 'Links',
            child: Column(
              children: [
                if (project.googlePlayStore.isNotEmpty)
                  _buildLinkTile(
                    context,
                    icon: Icons.shop_rounded,
                    label: 'Google Play Store',
                    url: project.googlePlayStore,
                    color: AppTheme.successColor,
                  ),
                if (project.appleAppStore.isNotEmpty)
                  _buildLinkTile(
                    context,
                    icon: Icons.shop_rounded,
                    label: 'Apple App Store',
                    url: project.appleAppStore,
                    color: AppTheme.primaryColor,
                  ),
                if (project.github.isNotEmpty)
                  _buildLinkTile(
                    context,
                    icon: Icons.code_rounded,
                    label: 'GitHub Repository',
                    url: project.github,
                    color: AppTheme.secondaryColor,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Meta
          _buildSection(
            context,
            icon: Icons.info_outline_rounded,
            title: 'Details',
            child: Column(
              children: [
                _buildMetaTile(context, 'Project ID', project.id),
                const SizedBox(height: 8),
                _buildMetaTile(
                    context, 'Created', _formatDate(project.createdAt)),
                const SizedBox(height: 8),
                _buildMetaTile(
                    context, 'Last Updated', _formatDate(project.updatedAt)),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Action Buttons
          BlocBuilder<ProjectBloc, ProjectState>(
            builder: (context, state) {
              final isLoading = state is ProjectActionLoading;
              return Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => _showDeleteDialog(context),
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.errorColor,
                        side: const BorderSide(color: AppTheme.errorColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditProjectScreen(project: project),
                                ),
                              );
                              if (context.mounted) {
                                context
                                    .read<ProjectBloc>()
                                    .add(const LoadAllProjectsEvent());
                              }
                            },
                      icon: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.edit_rounded),
                      label: const Text('Edit Project'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primaryLight, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryLight,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildLinkTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String url,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  url,
                  style: const TextStyle(
                    color: AppTheme.textHint,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.open_in_new_rounded, color: color, size: 16),
        ],
      ),
    );
  }

  Widget _buildMetaTile(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textHint,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text(
          'Are you sure you want to delete "${project.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<ProjectBloc>()
                  .add(DeleteProjectEvent(project.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
