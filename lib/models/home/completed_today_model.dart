/// Stats for "Completed Today" section on home.
class CompletedTodayModel {
  const CompletedTodayModel({
    this.tasksCount = 0,
    this.distanceKm = 0,
  });

  final int tasksCount;
  final double distanceKm;

  factory CompletedTodayModel.fromJson(Map<String, dynamic> json) {
    return CompletedTodayModel(
      tasksCount: (json['tasksCount'] as num?)?.toInt() ?? 0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
    );
  }
}
