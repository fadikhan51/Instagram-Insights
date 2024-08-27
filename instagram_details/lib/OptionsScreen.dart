import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instagram_details/InstaScreens/AccountsReach.dart';
import 'package:instagram_details/InstaScreens/ArchivedPostsScreen.dart';
import 'package:instagram_details/InstaScreens/AudienceInsightsScreen.dart';
import 'package:instagram_details/InstaScreens/ContentInteraction.dart';
import 'package:instagram_details/InstaScreens/CountdownScreen.dart';
import 'package:instagram_details/InstaScreens/FollowersScreen.dart';
import 'package:instagram_details/InstaScreens/Following.dart';
import 'package:instagram_details/InstaScreens/LikedCommentsScreen.dart';
import 'package:instagram_details/InstaScreens/LikedPostsScreen.dart';
import 'package:instagram_details/InstaScreens/LiveVideoScreen.dart';
import 'package:instagram_details/InstaScreens/MessageScreen.dart';
import 'package:instagram_details/InstaScreens/MonetizationEligibilityScreen.dart';
import 'package:instagram_details/InstaScreens/PollActivityScreen.dart';
import 'package:instagram_details/InstaScreens/PostsInsightsScreen.dart';
import 'package:instagram_details/InstaScreens/ProfilePhotosScreen.dart';
import 'package:instagram_details/InstaScreens/ReelsInsightScreen.dart';
import 'package:instagram_details/InstaScreens/SecretConversationsScreen.dart';
import 'package:instagram_details/InstaScreens/StoriesScreen.dart';
import 'package:instagram_details/InstaScreens/StoryLikesScreen.dart';
import 'package:instagram_details/InstaScreens/UnfollowedScreen.dart';
import 'package:instagram_details/PersonalScreens/AccountInfoScreen.dart';
import 'package:instagram_details/PersonalScreens/ProfessionalInfoScreen.dart';
import 'package:instagram_details/PersonalScreens/ProfileChangesScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'InstaScreens/PostDetailsScreen.dart';
import 'PersonalScreens/PersonalInfoScreen.dart';

class OptionsScreen extends StatelessWidget {
  final String folderName;

  const OptionsScreen({super.key, required this.folderName});

  Future<String?> _readFileIfExists(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      print('Error reading file: $e');
    }
    return null;
  }

  void _navigateToNextScreen(
      BuildContext context, String data, String folderName) {
    // Define how to navigate to the next screen with the data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NextScreen(data: data, folderName: folderName),
      ),
    );
  }

  void _viewPersonalInfo() {}

  void _viewAccountInfo() {}

  void _viewBusinessInfo() {}

  void _viewProfileChanges() {}

  void _viewFollowers() {}

  void _viewFollowings() {}

  void _viewUnfollowed() {}

  void _viewLikedComments() {}

  void _viewLikedPosts() {}

  void _viewPosts() {}

  void _viewArchivedPosts() {}

  void _viewProfilePhotos() {}

  void _viewStories() {}

  void _viewChats() {}

  void _viewSecretConvo() {}

  void _viewEligibility() {}

  void _viewStoryLikes() {}

  void _viewCountdownActivity() {}

  void _viewPollActivity() {}

  void _viewAccountsReached() {}

  void _viewAudienceInsights() {}

  void _viewContentInteraction() {}

  void _viewRecentPosts() {}

  void _viewReels() {}

  void _viewLiveVideo() {}

  @override
  Widget build(BuildContext context) {
    // Get the app documents directory
    Future<String> _getAppDocumentsDirectory() async {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      return appDocumentsDirectory.path;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select any option"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //-----------------PERSONAL INFORMATION SCREENS----------------------
            CustomButton(
              buttonText: "Personal Information",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/personal_information/personal_information/personal_information.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ProfileInfoScreen(
                          jsonData: data,
                          folderName: folderName,
                        )));
              },
            ),
            CustomButton(
              buttonText: "Account Information",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/personal_information/personal_information/account_information.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => AccountInfoScreen(
                          jsonData: data,
                          folderName: folderName,
                        )));
              },
            ),
            CustomButton(
              buttonText: "Business Information",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/personal_information/personal_information/professional_information.json',
              onSuccess: (data) {
                // _navigateToNextScreen(context, data, folderName);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ProfessionalInfoScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));
              },
            ),
            CustomButton(
              buttonText: "See Profile Changes",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/personal_information/personal_information/profile_changes.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ProfileChangesScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));

              },
            ),

            //-----------------FOLLOWERS AND FOLLOWINGS-------------------------
            CustomButton(
              buttonText: "View Followers",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/connections/followers_and_following/followers_1.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => FollowersScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));
                // _navigateToNextScreen(context, data, folderName);
              },
            ),
            CustomButton(
              buttonText: "View Followings",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/connections/followers_and_following/following.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => FollowingScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));
              },
            ),
            CustomButton(
              buttonText: "Recently Unfollowed",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/connections/followers_and_following/recently_unfollowed_accounts.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => UnfollowedScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));
              },
            ),

            //----------------LIKED COMMENTS AND POSTS--------------------------
            CustomButton(
              buttonText: "Liked Comments",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/your_instagram_activity/likes/liked_comments.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => LikedCommentsScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));
              },
            ),
            CustomButton(
              buttonText: "Liked Posts",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/your_instagram_activity/likes/liked_posts.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => LikedPostsScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));
              },
            ),

            //-----------------CONTENT SCREENS----------------------------------
            CustomButton(
              buttonText: "Your Posts",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/your_instagram_activity/content/posts_1.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => PostsScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));
              },
            ),
            CustomButton(
              buttonText: "Archived Posts",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/your_instagram_activity/content/archived_posts.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ArchivedPostsScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));
              },
            ),
            CustomButton(
              buttonText: "Profile Photos",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/your_instagram_activity/content/profile_photos.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ProfilePhotosScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));
                // _navigateToNextScreen(context, data, folderName);
              },
            ),
            CustomButton(
              buttonText: "Stories Shared",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/your_instagram_activity/content/stories.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => StoriesScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));
              },
            ),

            //--------------------------MESSAGES--------------------------------
            MessagesButton(
              buttonText: "Your Chats",
              directoryPathFuture: () async =>
              '${await _getAppDocumentsDirectory()}/$folderName/your_instagram_activity/messages/inbox',
              onSuccess: (directoryPath) {
                print(folderName);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ChatMessagesScreen(
                      dirName: folderName,
                    )));
              },
            ),
            CustomButton(
              buttonText: "Secret Conversation Details",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/your_instagram_activity/messages/secret_conversations.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => SecretConversationsScreen(
                      data: data,
                      folderName: folderName,
                    )));
                // _navigateToNextScreen(context, data, folderName);
              },
            ),

            //-----------------MONETIZATION ELIGIBILITY-------------------------
            CustomButton(
              buttonText: "MONETIZATION Eligibility",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/your_instagram_activity/monetization/eligibility.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => MonetizationEligibilityScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));
                // _navigateToNextScreen(context, data, folderName);
              },
            ),

            //-----------------STORY STICKER INTERACTIONS-----------------------
            CustomButton(
              buttonText: "Story Likes",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/your_instagram_activity/story_sticker_interactions/story_likes.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => StoryLikesScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));
                // _navigateToNextScreen(context, data, folderName);
              },
            ),
            CustomButton(
              buttonText: "Countdown Activity",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/your_instagram_activity/story_sticker_interactions/countdowns.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => CountdownActivityScreen(
                      data: data,
                      folderName: folderName,
                    )));
              },
            ),
            CustomButton(
              buttonText: "Poll Activity",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/your_instagram_activity/story_sticker_interactions/polls.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => PollActivityScreen(
                      data: data,
                      folderName: folderName,
                    )));
              },
            ),

            //------------------PAST INSTAGRAM INSIGHTS-------------------------
            CustomButton(
              buttonText: "Accounts Reached",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/logged_information/past_instagram_insights/accounts_reached.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => AccountsReachScreen(
                      data: data,
                      folderName: folderName,
                    )));
              },
            ),
            CustomButton(
              buttonText: "Audience Insights",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/logged_information/past_instagram_insights/audience_insights.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => AudienceInsightsScreen(
                      AudienceData: data,
                      folderName: folderName,
                    )));
                // _navigateToNextScreen(context, data, folderName);
              },
            ),
            CustomButton(
              buttonText: "Content Interaction",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/logged_information/past_instagram_insights/content_interactions.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ContentInteractionScreen(
                      jsonData: data,
                      folderName: folderName,
                    )));
                // _navigateToNextScreen(context, data, folderName);
              },
            ),
            CustomButton(
              buttonText: "Recent Posts",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/logged_information/past_instagram_insights/posts.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => PostsInsightsScreen(
                      data: data,
                      folderName: folderName,
                    )));
              },
            ),
            CustomButton(
              buttonText: "Reels",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/logged_information/past_instagram_insights/reels.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ReelsInsightsScreen(
                      data: data,
                      folderName: folderName,
                    )));
              },
            ),
            CustomButton(
              buttonText: "Live Videos",
              filePathFuture: () async =>
                  '${await _getAppDocumentsDirectory()}/$folderName/logged_information/past_instagram_insights/live_videos.json',
              onSuccess: (data) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => LiveVideoScreen(
                      data: data,
                      folderName: folderName,
                    )));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesButton extends StatefulWidget {
  final String buttonText;
  final Future<String> Function() directoryPathFuture;
  final Function(String) onSuccess;

  const MessagesButton({
    Key? key,
    required this.buttonText,
    required this.directoryPathFuture,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _MessagesButtonState createState() => _MessagesButtonState();
}

class _MessagesButtonState extends State<MessagesButton> {
  bool _isLoading = false;

  void _handleOnPressed() async {
    setState(() {
      _isLoading = true;
    });

    final directoryPath = await widget.directoryPathFuture();
    final exists = await _checkDirectoryExists(directoryPath);

    setState(() {
      _isLoading = false;
    });

    if (exists) {
      widget.onSuccess(directoryPath);
    } else {
      // Show message if the directory doesn't exist
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("You don't have any data in this section.")),
      );
    }
  }

  Future<bool> _checkDirectoryExists(String directoryPath) async {
    try {
      final directory = Directory(directoryPath);
      return await directory.exists();
    } catch (e) {
      print('Error checking directory: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleOnPressed,
      child: _isLoading
          ? const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
          : Text(
        widget.buttonText,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  final String buttonText;
  final Future<String> Function() filePathFuture;
  final void Function(String data) onSuccess;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.filePathFuture,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;

  void _handleOnPressed() async {
    setState(() {
      _isLoading = true;
    });

    final filePath = await widget.filePathFuture();
    final data = await _readFileIfExists(filePath);

    setState(() {
      _isLoading = false;
    });

    if (data != null) {
      widget.onSuccess(data);
    } else {
      // Show message if the file doesn't exist
      print(filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("You don't have any information in this section.")),
      );
    }
  }

  Future<String?> _readFileIfExists(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      print('Error reading file: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleOnPressed,
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : Text(
              widget.buttonText,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
    );
  }
}

class NextScreen extends StatelessWidget {
  final String data;
  final String folderName;

  const NextScreen({Key? key, required this.data, required this.folderName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Next Screen"),
      ),
      body: Center(
        child: Text('Data: $data\nFolder: $folderName'),
      ),
    );
  }
}
