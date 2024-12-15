class TrackingProgress {
  int progress;
  String episodeId;

  TrackingProgress({
    required this.progress,
    required this.episodeId,
  });

  factory TrackingProgress.fromJson(Map<String, dynamic> json) =>
      TrackingProgress(
        progress: json["progress"],
        episodeId: json["episodeId"],
      );

  Map<String, dynamic> toJson() => {
        "progress": progress,
        "episodeId": episodeId,
      };
}
