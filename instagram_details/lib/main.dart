import 'dart:io';

import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
import 'package:flutter/material.dart';
import 'package:instagram_details/InstaScreens/ArchivedPostsScreen.dart';
import 'package:instagram_details/InstaScreens/ContentInteraction.dart';
import 'package:instagram_details/InstaScreens/LikedPostsScreen.dart';
import 'package:instagram_details/InstaScreens/PollActivityScreen.dart';
import 'package:instagram_details/InstaScreens/PostDetailsScreen.dart';
import 'package:instagram_details/InstaScreens/PostsInsightsScreen.dart';
import 'package:instagram_details/InstaScreens/ProfilePhotosScreen.dart';
import 'package:instagram_details/InstaScreens/StoriesScreen.dart';
import 'package:instagram_details/InstaScreens/StoryLikesScreen.dart';
import 'package:instagram_details/PersonalScreens/ProfessionalInfoScreen.dart';
import 'package:instagram_details/Screens/DownloadTest.dart';
import 'package:instagram_details/Screens/ViewDetails.dart';
import 'package:instagram_details/Screens/WebView.dart';
import 'package:permission_handler/permission_handler.dart';

import 'DashboardScreen.dart';
import 'InstaScreens/AccountsReach.dart';
import 'InstaScreens/AudienceInsightsScreen.dart';
import 'InstaScreens/CountdownScreen.dart';
import 'InstaScreens/FollowersScreen.dart';
import 'InstaScreens/Following.dart';
import 'InstaScreens/LikedCommentsScreen.dart';
import 'InstaScreens/LiveVideoScreen.dart';
import 'InstaScreens/MessageScreen.dart';
import 'InstaScreens/MonetizationEligibilityScreen.dart';
import 'InstaScreens/ReelsInsightScreen.dart';
import 'InstaScreens/SecretConversationsScreen.dart';
import 'InstaScreens/UnfollowedScreen.dart';
import 'PersonalScreens/AccountInfoScreen.dart';
import 'PersonalScreens/PersonalInfoScreen.dart';
import 'PersonalScreens/ProfileChangesScreen.dart';

void main() {
  runApp(MaterialApp(
    home: DownloadTest(),
  ));
}