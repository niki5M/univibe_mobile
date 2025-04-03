import 'package:uni_mobile/features/schedule/data/models/lottie_model.dart';

class NavItemModel {
  final String title;
  final LottieModel lottie;

  NavItemModel({required this.title, required this.lottie});
}

List<NavItemModel> bottomNavItems = [
  NavItemModel(
    title: 'BELL',
    lottie: LottieModel(
      src: 'assets/lottie/schedule.json',
      width: 90,
      height: 90,
    ),
  ),
  NavItemModel(
    title: 'CHAT',
    lottie: LottieModel(
      src: 'assets/lottie/demo.json',
      width: 90,
      height: 90,
    ),
  ),
  NavItemModel(
    title: 'SETTINGS',
    lottie: LottieModel(
      src: 'assets/lottie/aaa.json',
      width: 90,
      height: 90,
    ),
  ),
];