class PayloadAddFilm {
  final String filmId;

  const PayloadAddFilm({
    required this.filmId,
  });

  Map<String, dynamic> toJson() => {
        'filmId': filmId,
      };
}
