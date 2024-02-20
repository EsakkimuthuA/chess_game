import "dart:convert";

List<Reward> welcomeFromJson(String str) =>
    List<Reward>.from(json.decode(str).map((x) => Reward.fromJson(x)));

String welcomeToJson(List<Reward> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reward {
  String id;
  String userId;
  String rewardAmount;
  Reward({
    required this.id,
    required this.userId,
    required this.rewardAmount
  });

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    id: json["log_id"] ?? "",
    userId: json["user_id"] ?? "",
    rewardAmount: json["reward_amount"] ?? ""
  );

  Map<String, dynamic> toJson() => {
    "log_id":id,
    "user_id": userId,
    "reward_amount":rewardAmount
  };
}
