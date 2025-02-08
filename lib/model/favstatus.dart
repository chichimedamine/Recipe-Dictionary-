class FavStatus {
  bool fav;

  FavStatus({required this.fav});

  factory FavStatus.fromJson(Map<String, dynamic> json) =>
      FavStatus(fav: json["Fav"]);

  Map<String, dynamic> toJson() => {
        "Fav": fav,
      };
}
