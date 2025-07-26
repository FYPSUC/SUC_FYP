import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suc_fyp/login_system/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'VendorMain.dart';
import 'VendorSetShop.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      print('❌ Cloudinary upload failed: ${res.body}');
      return null;
    }
  }
}

class VendorProfilePage extends StatefulWidget {
  const VendorProfilePage({super.key});

  @override
  State<VendorProfilePage> createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _pickupAddressController = TextEditingController();
  final TextEditingController _sixDigitPasswordController = TextEditingController();
  final GlobalKey _avatarKey = GlobalKey();
  final GlobalKey _pinKey = GlobalKey();
  final GlobalKey _setShopKey = GlobalKey(); // 已有
  TutorialCoachMark? tutorialCoachMark;


  String? _email;
  String? _username;
  String? _imageUrl;
  String? _uid;

  void _checkAndShowGuide() async {
    final prefs = await SharedPreferences.getInstance();
    final step = prefs.getInt('vendor_guide_step') ?? 0;

    if (step == 1) {
      tutorialCoachMark = TutorialCoachMark(
        targets: _createTargets(),
        colorShadow: Colors.grey,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8,
        onFinish: () async {
          await prefs.setInt('vendor_guide_step', 2); // 下一步是 SetShop
          Navigator.push(context, MaterialPageRoute(builder: (_) => const VendorSetShopPage()));
        },
        onClickTarget: (target) => true,
        onSkip: () => true,
      );

      tutorialCoachMark!.show(context: context);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadVendorData();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndShowGuide());
  }





  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "Avatar",
        keyTarget: _avatarKey,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 80, // 距离屏幕顶部 80 px
            ),
            child: const Text("点击这里上传店的头像 Tap to upload your shop profile image"),
          ),
        ],
      ),
      TargetFocus(
        identify: "PIN",
        keyTarget: _pinKey,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 350,
            ),
            child: const Text("输入你的6位安全码以确保交易能进行 Set your 6-digit transaction PIN here"),
          ),
        ],
      ),
      TargetFocus(
        identify: "SetShop",
        keyTarget: _setShopKey,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: 80, // 距离屏幕顶部 80 px
            ),
            child: const Text("点击这里更改更多店的细节咨询 Click here to set up your shop details"),
          ),
        ],
      ),
    ];
  }


  Future<void> _loadVendorData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _uid = user.uid;
      _email = user.email;

      final response = await ApiService.getVendorByUID(user.uid);

      if (response['success']) {
        final data = response['vendor'] ?? response['user'];

        if (data == null) {
          print('❌ vendor/user not found in response');
          return;
        }

        print('✅ Loaded vendor data: $data');

        setState(() {
          _nameController.text = data['Name'] ?? '';
          _shopNameController.text = data['ShopName'] ?? '';
          _pickupAddressController.text = data['PickupAddress'] ?? '';
          _sixDigitPasswordController.text = data['SixDigitPassword'] ?? '';
          _imageUrl = data['Image'];
        });
      } else {
        print('❌ API returned failure: ${response['message']}');
      }
    }
  }


  Future<void> _selectAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final uploadedUrl = await CloudinaryService.uploadImage(file);
      if (uploadedUrl != null) {
        setState(() {
          _imageUrl = uploadedUrl;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image upload failed")));
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_uid == null) return;

    final result = await ApiService.updateVendorProfile(
      uid: _uid!,
      image_url: _imageUrl ?? '',
      Name: _nameController.text,
      ShopName: '',
      PickupAddress: '',
      SixDigitPassword: _sixDigitPasswordController.text,
    );
    print('🔧 更新结果: $result'); // 🟢 这行最关键！

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Changes saved successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save changes')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.03),
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VendorMainPage())),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset('assets/image/BackButton.jpg', width: screenWidth * 0.08, height: screenWidth * 0.08),
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
                                  onTap: _selectAndUploadImage,
                                  child: CircleAvatar(
                                    radius: screenWidth * 0.10,
                                    backgroundImage: _imageUrl != null
                                        ? NetworkImage(_imageUrl!)
                                        : const AssetImage('assets/image/Profile_icon.png') as ImageProvider,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.05),
                                SizedBox(
                                  width: screenWidth * 0.3, // 你可以调整宽度
                                  child: TextField(
                                    controller: _nameController,
                                    style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),

                                const Spacer(),
                                ElevatedButton(
                                  key: _setShopKey,
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const VendorSetShopPage()),
                                    );
                                    await _loadVendorData(); // ✨ 加上这行，刷新
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[700],
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.015),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  ),
                                  child: Text('Set Shop', style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ],
                            ),
                            Divider(height: screenHeight * 0.05, thickness: 2, color: Colors.black),
                            SizedBox(height: screenHeight * 0.02),
                            _buildReadOnlyRow('Email', _email ?? '', screenWidth),
                            SizedBox(height: screenHeight * 0.02),
                            _buildReadOnlyRow('Shop Name', _shopNameController.text, screenWidth),
                            SizedBox(height: screenHeight * 0.02),
                            _buildReadOnlyRow('Pick Up Address', _pickupAddressController.text, screenWidth),
                            Divider(height: screenHeight * 0.05, thickness: 1, color: Colors.black),
                            _buildPINField(screenWidth),
                            SizedBox(height: screenHeight * 0.03),
                            Center(
                              child: ElevatedButton(
                                onPressed: _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenHeight * 0.015),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                                child: Text('Save Changes', style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white)),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.05),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, double screenWidth, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter $label',
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

  Widget _buildReadOnlyRow(String label, String value, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPINField(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('6-Digit PIN', style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          key: _pinKey,
          controller: _sixDigitPasswordController,
          obscureText: true,
          maxLength: 6,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter 6-digit PIN',
            filled: true,
            fillColor: Colors.grey[200],
            counterText: '',
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
