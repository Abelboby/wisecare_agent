part of '../task_details_screen.dart';

/// Request info section: status badge, category, title, product image, description.
class _RequestSection extends StatelessWidget {
  const _RequestSection({required this.task});

  final AgentTaskModel task;

  static String _statusLabel(AgentTaskModel t) {
    final s = t.status?.toUpperCase() ?? 'ASSIGNED';
    if (s == 'IN_PROGRESS') return 'IN PROGRESS';
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final requestType = task.requestType;
    final subtitleParts = task.subtitle?.split(' • ');
    final categoryLabel =
        requestType ?? (subtitleParts != null && subtitleParts.isNotEmpty ? subtitleParts.first : null);
    final hasTypeBadge = categoryLabel != null && categoryLabel.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Skin.color(Co.loginContactBorder), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusBadge(label: _statusLabel(task)),
              if (hasTypeBadge) ...[
                const SizedBox(width: 8),
                _CategoryBadge(label: categoryLabel),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            task.title,
            style: GoogleFonts.lexend(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 28 / 20,
              color: Skin.color(Co.loginHeading),
            ),
          ),
          const SizedBox(height: 12),
          _ProductImageCard(task: task),
          const SizedBox(height: 12),
          Text(
            task.description ?? task.subtitle ?? '—',
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 23 / 14,
              color: Skin.color(Co.loginInstruction),
            ),
          ),
          if (task.rawMessage != null &&
              task.rawMessage!.isNotEmpty &&
              task.rawMessage != task.description) ...[
            const SizedBox(height: 12),
            Text(
              'Original message',
              style: GoogleFonts.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 16 / 12,
                color: Skin.color(Co.loginIconMuted),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              task.rawMessage!,
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 23 / 14,
                color: Skin.color(Co.loginInstruction),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: Skin.color(Co.loginLogoIconBg),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: GoogleFonts.lexend(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 16 / 12,
          letterSpacing: 0.6,
          color: Skin.color(Co.primary),
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: Skin.color(Co.loginInputBg),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: GoogleFonts.lexend(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
          color: Skin.color(Co.loginSubtitle),
        ),
      ),
    );
  }
}

/// Categories for task type; used to pick fallback icon when product image is missing/placeholder.
enum _TaskDetailCategory { grocery, medicine, transport, emergency, other }

class _ProductImageCard extends StatelessWidget {
  const _ProductImageCard({required this.task});

  final AgentTaskModel task;

  static bool _isPlaceholderOrInvalid(String? url) {
    if (url == null || url.isEmpty) return true;
    return url.contains('via.placeholder.com');
  }

  static _TaskDetailCategory _categoryFromTask(AgentTaskModel t) {
    final subtitleFirst = t.subtitle?.split(' • ');
    final raw = (t.requestType ?? (subtitleFirst != null && subtitleFirst.isNotEmpty ? subtitleFirst.first : ''))
        .toString()
        .toUpperCase();
    if (raw.contains('GROCERY')) return _TaskDetailCategory.grocery;
    if (raw.contains('MEDICINE')) return _TaskDetailCategory.medicine;
    if (raw.contains('TRANSPORT')) return _TaskDetailCategory.transport;
    if (raw.contains('EMERGENCY') || raw.contains('SOS')) return _TaskDetailCategory.emergency;
    return _TaskDetailCategory.other;
  }

  static IconData _iconForCategory(_TaskDetailCategory category) {
    switch (category) {
      case _TaskDetailCategory.grocery:
        return Icons.shopping_cart_rounded;
      case _TaskDetailCategory.medicine:
        return Icons.medical_services_rounded;
      case _TaskDetailCategory.transport:
        return Icons.directions_car_rounded;
      case _TaskDetailCategory.emergency:
        return Icons.emergency_rounded;
      case _TaskDetailCategory.other:
        return Icons.inventory_2_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = task.productImageUrl;
    final category = _categoryFromTask(task);
    final icon = _iconForCategory(category);
    final useImage = !_isPlaceholderOrInvalid(imageUrl);

    return Container(
      height: 115,
      decoration: BoxDecoration(
        color: Skin.color(Co.loginInputBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: useImage
          ? Opacity(
              opacity: 0.8,
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => _CategoryIconPlaceholder(icon: icon),
              ),
            )
          : _CategoryIconPlaceholder(icon: icon),
    );
  }
}

class _CategoryIconPlaceholder extends StatelessWidget {
  const _CategoryIconPlaceholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(icon, size: 40, color: Skin.color(Co.loginIconMuted)),
    );
  }
}
