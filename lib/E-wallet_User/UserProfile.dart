import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserMain.dart';
import 'package:suc_fyp/login_system/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class CloudinaryService {
  static const cloudName = 'dj5err3f6';
  static const uploadPreset = 'flutter_upload';

  static Future<String?> uploadImage(File imageFile) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    if (res.statusCode == 200) {
      final responseData = jsonDecode(res.body);
      return responseData['secure_url'];
    } else {
      print('Cloudinary upload failed: ${res.body}');
      return null;
    }
  }
}

class UserProfilePage extends StatefulWidget {
  final bool showSecondGuide;
  const UserProfilePage({super.key, this.showSecondGuide = false});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _SixDigitPasswordController = TextEditingController();
  String? _profileImageUrl;
  String? _email;
  String? _uid;

  final GlobalKey _avatarKey = GlobalKey();
  final GlobalKey _pinKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();

    if (widget.showSecondGuide) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSecondTutorial();
      });
    }
  }

  void showSecondTutorial() {
    TutorialCoachMark(
      targets: [
        TargetFocus(
          keyTarget: _avatarKey,
          contents: [
            TargetContent(
              child: Text("You can upload your profile image here👤", style: TextStyle(color: Colors.lightBlue)),
            ),
          ],
        ),
        TargetFocus(
          keyTarget: _pinKey,
          contents: [
            TargetContent(
              child: Text("Setup your 6 digit password for transaction use 🔐", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ],
      onFinish: () {
        // 可以加入完成提示
      },
    ).show(context: context);
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _uid = user.uid;
        _email = user.email;
      });

      final response = await ApiService.getUserByUID(user.uid);
      if (response['success']) {
        setState(() {
          _usernameController.text = response['user']['username'];
          _SixDigitPasswordController.text = response['user']['SixDigitPassword'] ?? '';
          _profileImageUrl = response['user']['Image'];
        });
      }
    }
  }

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final uploadedUrl = await CloudinaryService.uploadImage(file);

      if (uploadedUrl != null) {
        setState(() {
          _profileImageUrl = uploadedUrl;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image upload failed")),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_uid == null) return;

    final response = await ApiService.updateUserProfile(
      uid: _uid!,
      username: _usernameController.text,
      ImageUrl: _profileImageUrl ?? '',
      SixDigitPassword: _SixDigitPasswordController.text,
    );

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Update failed: \${response['message']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/UserMainBackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserMainPage())),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/image/BackButton.jpg',
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text('Back', style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Row(
                    children: [
                      GestureDetector(
                        key: _avatarKey,
                        onTap: pickAndUploadImage,
                        child: CircleAvatar(
                          radius: screenWidth * 0.1,
                          backgroundImage: _profileImageUrl != null
                              ? NetworkImage(_profileImageUrl!)
                              : const AssetImage('assets/image/Profile_icon.png') as ImageProvider,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Expanded(
                        child: _buildInfoRow('Username', _usernameController.text, screenWidth),
                      ),
                    ],
                  ),
                  Divider(height: screenHeight * 0.05, thickness: 2, color: Colors.black),
                  _buildInfoRow('Email', _email ?? '', screenWidth),
                  Divider(height: screenHeight * 0.05, thickness: 1, color: Colors.black),
                  _buildPinRow(screenWidth, context),
                  SizedBox(height: screenHeight * 0.05),
                  Center(
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      child: const Text("Save Changes"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, double screenWidth) {
    final controller = TextEditingController(text: value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        TextField(
          readOnly: true,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintText: value,
            hintStyle: TextStyle(fontSize: screenWidth * 0.04),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinRow(double screenWidth, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('6-Digit PIN', style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        TextField(
          key: _pinKey,
          controller: _SixDigitPasswordController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter 6-digit PIN',
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
