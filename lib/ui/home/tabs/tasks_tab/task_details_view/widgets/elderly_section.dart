part of '../task_details_screen.dart';

/// Elderly details section: heading, person row, map + address cards.
class _ElderlySection extends StatelessWidget {
  const _ElderlySection({
    required this.task,
    required this.onCall,
    required this.onOpenMap,
  });

  final AgentTaskModel task;
  final VoidCallback onCall;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    final address = task.elderlyAddress ?? task.location ?? task.elderlyCity ?? '—';
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
          Text(
            'ELDERLY DETAILS',
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 20 / 14,
              letterSpacing: 1.4,
              color: Skin.color(Co.loginIconMuted),
            ),
          ),
          const SizedBox(height: 16),
          _PersonRow(task: task, onCall: onCall),
          const SizedBox(height: 12),
          _LocationCards(task: task, address: address, onOpenMap: onOpenMap),
        ],
      ),
    );
  }
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({required this.task, required this.onCall});

  final AgentTaskModel task;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final name = task.customerName ?? 'Customer';
    final distance = task.distanceAway;

    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Skin.color(Co.loginLogoIconBg),
            border: Border.all(
              color: Skin.color(Co.loginButtonShadow),
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_rounded,
            size: 28,
            color: Skin.color(Co.primary),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.lexend(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 24 / 16,
                  color: Skin.color(Co.loginHeading),
                ),
              ),
              if (distance != null && distance.isNotEmpty) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: Skin.color(Co.primary),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$distance away',
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 16 / 12,
                        color: Skin.color(Co.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onCall,
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              width: 31,
              height: 31,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Skin.color(Co.loginLogoIconBg),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone_rounded,
                size: 15,
                color: Skin.color(Co.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationCards extends StatelessWidget {
  const _LocationCards({
    required this.task,
    required this.address,
    required this.onOpenMap,
  });

  final AgentTaskModel task;
  final String address;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    final lat = task.elderlyLatitude;
    final lng = task.elderlyLongitude;
    final hasCoords = lat != null && lng != null;

    return Column(
      children: [
        Container(
          height: 96,
          decoration: BoxDecoration(
            color: Skin.color(Co.loginContactBorder),
            border: Border.all(color: Skin.color(Co.loginContactBorder)),
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: hasCoords
              ? FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(lat, lng),
                    initialZoom: 15,
                    interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'wisecare_agent',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(lat, lng),
                          width: 24,
                          height: 24,
                          child: Icon(
                            Icons.location_on_rounded,
                            size: 24,
                            color: Skin.color(Co.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Center(
                  child: Icon(
                    Icons.map_outlined,
                    size: 36,
                    color: Skin.color(Co.loginIconMuted),
                  ),
                ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: Skin.color(Co.loginInputBg),
            border: Border.all(color: Skin.color(Co.loginContactBorder)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const SizedBox(width: 17),
              Icon(
                Icons.home_rounded,
                size: 18,
                color: Skin.color(Co.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      address,
                      style: GoogleFonts.lexend(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 18 / 14,
                        color: Skin.color(Co.loginHeading),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.elderlyCity != null && task.elderlyCity!.isNotEmpty)
                      Text(
                        task.elderlyCity!,
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 16 / 12,
                          color: Skin.color(Co.loginSubtitle),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onOpenMap,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'MAP',
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 16 / 12,
                          color: Skin.color(Co.primary),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.navigation_rounded,
                        size: 12,
                        color: Skin.color(Co.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
