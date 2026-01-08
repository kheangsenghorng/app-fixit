import 'package:flutter/material.dart';

void showGallerySheet(BuildContext context) {
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // Required for custom rounded corners
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            // 1. DRAG HANDLE
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // 2. HEADER
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new,
                          size: 18,
                          color: theme.colorScheme.primary
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Work Gallery",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "12 Photos", // Example count
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),

            // 3. GALLERY SCROLL
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    // ROW 1: Large Left, Two Small Right
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _galleryItem('assets/images/providers/img_1.png', 250),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              _galleryItem('assets/images/providers/img.png', 119),
                              const SizedBox(height: 12),
                              _galleryItem('assets/images/providers/img.png', 119),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ROW 2: Balanced Two-Column
                    Row(
                      children: [
                        Expanded(child: _galleryItem('assets/images/providers/img.png', 160)),
                        const SizedBox(width: 12),
                        Expanded(child: _galleryItem('assets/images/providers/img.png', 160)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ROW 3: One Small Left, Large Right
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _galleryItem('assets/images/providers/img.png', 200),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: _galleryItem('assets/images/providers/img.png', 200),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ROW 4: Triple Grid
                    Row(
                      children: [
                        Expanded(child: _galleryItem('assets/images/providers/img.png', 100)),
                        const SizedBox(width: 12),
                        Expanded(child: _galleryItem('assets/images/providers/img.png', 100)),
                        const SizedBox(width: 12),
                        Expanded(child: _galleryItem('assets/images/providers/img.png', 100)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _galleryItem(String path, double height) {
  return Container(
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        path,
        fit: BoxFit.cover,
        // Error builder handles missing images gracefully
        errorBuilder: (context, error, stackTrace) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.image_not_supported_outlined),
        ),
      ),
    ),
  );
}