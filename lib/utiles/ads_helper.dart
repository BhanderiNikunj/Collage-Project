// import 'dart:developer';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// // Account Id => ca-app-pub-1456785417505368~7946375379

// class AdsHelper {
//   static late BannerAd? bannerAd;
//   static late InterstitialAd interstitialAd;

//   // ca-app-pub-3940256099942544/6300978111     ->   banner ads for test
//   // ca-app-pub-1456785417505368/1821634933     ->   banner ads for my
//   // ca-app-pub-3940256099942544/1033173712     ->   Interstitial ads for test
//   // ca-app-pub-1456785417505368/9985381207     ->   Interstitial ads for my

//   static void loadBannerAd() {
//     bannerAd = BannerAd(
//       size: AdSize.banner,
//       adUnitId: "ca-app-pub-1456785417505368/1821634933",
//       listener:   BannerAdListener(
//         onAdLoaded: (ad) {
//           bannerAd = ad as BannerAd?;
//         },
//       ),
//       request: const AdRequest(),
//     )..load();
//   }

//   static void loadInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: "ca-app-pub-3940256099942544/1033173712",
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           interstitialAd = ad;
//         },
//         onAdFailedToLoad: (error) {
//           log("$error");
//         },
//       ),
//     );
//   }
// }
