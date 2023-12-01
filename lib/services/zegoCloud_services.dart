import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoCloudServices {
  static const appID = 105250703;
  static const appSign =
      "b6e567e6dd26e1365c9bb4cbbd7f2931532fab39a29fa311c5c22facb1aa0a06";
  static void initZegoCloud(String id, String name) {
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: appID,
      appSign: appSign,
      userID: id,
      userName: name,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }
}
