import 'package:flutter/material.dart';

abstract class Languages {
  
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String? get appName;

  String? get homeWelcome;

  String? get homeWelcome1;

  String? get homeInfo;

  String? get eventText;

  String? get eventDetailText;

  String? get labelSelectLanguage;

  String? get drawerDeposit;

  String? get drawerWallet;

  String? get drawerleaderBoard;

  String? get drawerAboutUs;

  String? get drawerPrivacyOptions;

  String? get drawerTermsAndConditions;

  String? get drawerContact;

  String? get drawerLogout;

  String? get dailyChallengeString;

  String? get mainEventString;

  String? get practiceString;

  String? get topUp;
  
}