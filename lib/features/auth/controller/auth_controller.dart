import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geogate/core/api/dio/api_service.dart';
import 'package:geogate/core/helpers/path.dart';
import 'package:geogate/core/services/firebase_service.dart';
import 'package:geogate/core/shared/controller/device_controller.dart';
import 'package:geogate/core/shared/model/failure.dart';
import 'package:geogate/core/localdata/secure_storage.dart';
import 'package:geogate/core/shared/modal/modal.dart';
import 'package:geogate/core/shared/widgets/local_lottie_image.dart';
import 'package:geogate/core/shared/widgets/logout_loading.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/auth/model/user.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:image_picker/image_picker.dart'; // Import your Failure model
import 'package:dio/dio.dart' as dio;

class AuthController extends GetxController {
  static AuthController controller = Get.find();

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  final signupFormKey = GlobalKey<FormBuilderState>();



  var isLoginLoading = false.obs;
  var isSignupLoading = false.obs;

  var rememberMe = false.obs;

  var user = User().obs;
  var token = ''.obs;
  var isTokenLoaded = false.obs;



  var uploadProgress = 0.0.obs;
  final formKey = GlobalKey<FormBuilderState>();

    final ImagePicker _picker = ImagePicker();


  XFile? selectedImage;
  // Pick an image for the profile
  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:  Icon(Icons.camera_alt, color: Palette.PRIMARY),
              title: const Text('Take a Photo'),
              onTap: () async {
                Get.back();
                selectedImage = await _picker.pickImage(source: ImageSource.camera);
                if (selectedImage != null) update();
              },
            ),
            ListTile(
              leading:  Icon(Icons.photo_library, color: Palette.PRIMARY),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Get.back();
                selectedImage = await _picker.pickImage(source: ImageSource.gallery);
                if (selectedImage != null) update();
              },
            ),
          ],
        ),
      ),
    );
  }


Future<void> updateProfile() async {
  if (formKey.currentState?.saveAndValidate() ?? false) {
    // Show loading modal
    Modal.loading();

    try {
      // Extract form values
      var formValues = formKey.currentState!.value;

      // Prepare FormData for the API request
      var formData = dio.FormData();

      // Add form fields
      formValues.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      // Add the avatar file if selected
      if (selectedImage != null) {
        print("Selected Image Path: ${selectedImage!.path}"); // Print selected image path
        print("Selected Image Filename: ${selectedImage!.path.split('/').last}"); // Print image filename

        formData.files.add(MapEntry(
          'profile_image',
          await dio.MultipartFile.fromFile(
            selectedImage!.path,
            filename: selectedImage!.path.split('/').last,
          ),
        ));
      } else {
        print("No image selected."); // Print if no image is selected
      }

      // Debug log to ensure data is being sent correctly
      print("FormData being sent:");
      formData.fields.forEach((field) {
        print('${field.key}: ${field.value}');
      });

      var response = await ApiService.filePostAuthenticatedResource(
        'user/profile-update',
        formData,
        onSendProgress: (int sent, int total) {
          uploadProgress.value = sent / total;
          update();
        },
      );

      // Handle the API response
      Get.back(); // Close the loading modal

      response.fold(
        (failure) {
          uploadProgress.value = 0.0; // Reset progress on failure
          Modal.errorDialog(message: 'Failed to update profile', failure: failure);
        },
        (success) async {
          print('-------------------- SUCCESS DATA');
          print(success.data);
          uploadProgress.value = 0.0; // Reset progress on success
          user.value = User.fromJson(success.data['data']); // Update user data locally
          await SecureStorage().writeSecureData('user', jsonEncode(user.value.toJson()));

          // Clear selected image
          selectedImage = null;

          update(); // Notify UI of changes
          
          // Show success modal and navigate back
          Modal.success(
            message: 'Profile updated successfully',
            onDismiss: () {
              Get.back(); // Navigate back to the previous screen
            },
          );
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      uploadProgress.value = 0.0;
      update();
      Modal.errorDialog(message: 'An error occurred. Please try again. $e');
    }
  } else {
    Modal.showToast(msg: 'Please complete the form.');
  }
}




  Future<void> loadTokenAndUser({bool showModal = true}) async {
    try {
      String? savedToken = await SecureStorage().readSecureData('token');

      if (savedToken != null && savedToken.isNotEmpty) {
        token.value = savedToken;

        String? userJson = await SecureStorage().readSecureData('user');
        if (userJson != null && userJson.isNotEmpty) {
          user(User.fromJson(jsonDecode(userJson)));
          // print('------------TOKEN-------------');
          // print('${token.value}');
          // print('--------------------------------------');
          print('------------USER DETAILS--------------------');
            print(token.value);
            print(user.toJson());
          print('--------------------------------------');
        }
      }
    } catch (e) {
      print("Error loading token and user: $e");
    } finally {
      isTokenLoaded.value = true;
    }
  }

  bool isLoggedIn() {
    return token.isNotEmpty;
  }


  Future<void> login(Map<String, dynamic>? formData) async {
    isLoginLoading(true);
    Modal.loading();

    final response = await ApiService.postPublicResource('login', {
      'email': formData!['email'],
      'password': formData['password'],
    });

    Get.back();

    response.fold(
      (failure) {
        isLoginLoading(false);
        Modal.errorDialog(failure: failure);
      },
      (success) async {
        final data = success.data['data'];
        // print('DATA----------------');
        // print(data);
        // print('DATA--------------');
        await SecureStorage().writeSecureData('token', data['access_token']);
        await SecureStorage().writeSecureData('user', jsonEncode(data['user']));
        //  await fetchUserFromStorage();
        await loadTokenAndUser();
        await AuthController.controller.updateDeviceToken();
        Get.offAllNamed('/home-main');
      },
    );

    isLoginLoading(false);
  }

 
  Future<void> clearLocalData() async {
    await SecureStorage().deleteSecureData('token');
    await SecureStorage().deleteSecureData('user');
    user.value = User(); // Clear user data in-memory
    token.value = ''; // Clear token in-memory
  }

  // Logout function that returns a bool (true for success, false for failure)
  Future<bool> logout() async {
    Modal.loading(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 24),
          CircularProgressIndicator(),
          SizedBox(width: 36),
          Text(
            "Logging out...",
            style: Get.textTheme.titleMedium,
          ),
        ],
      ),
    );

    // Call the logout API
    final response = await ApiService.postAuthenticatedResource('logout', {});

    // Close the loading modal
    Get.back();

    // Handle success or failure response
    return response.fold(
      (failure) async {

       
        await clearLocalData();
        Modal.error(
          content: Text(failure.message ?? 'Logout failed.'),
          visualContent: failure.icon,
        );
        return false; // Return false indicating failure
      },
      (success) async {
        // Clear local data on successful logout
        await clearLocalData();

        // Redirect to login page after successful logout
        Get.offAllNamed('/login');
        return true; // Return true indicating success
      },
    );
  }

  Future<void> fetchUserFromStorage() async {
    String? userJson = await SecureStorage().readSecureData('user');

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      user(User.fromJson(userMap));

      // print(user.toJson());
    } else {
      print('No user found in storage');
    }
  }

  Future<void> updateUserDetailsLocal(User updatedUser) async {
    user.value = user.value.copyWith(
      firstName: updatedUser.firstName ?? user.value.firstName,
      lastName: updatedUser.lastName ?? user.value.lastName,
      email: updatedUser.email ?? user.value.email,
      image: updatedUser.image ?? user.value.image,
    );

    await SecureStorage().writeSecureData(
      'user',
      jsonEncode(user.value.toJson()),
    );

    print('User details updated locally with selected fields.');
  }

  Future<bool> fetchAndUpdateUserDetails({bool showModal = true}) async {
    if (token.value.isNotEmpty) {
      final response = await ApiService.getAuthenticatedResource('user');

      return response.fold(
        (failure) {
          if (failure.statusCode != 401) {
            Modal.error(
              content: Text(failure.message ?? 'Something went wrong.'),
              visualContent: LocalLottieImage(
                path: lottiesPath('error.json'),
                repeat: false,
              ),
            );
          }

          return false; // Return false indicating failure
        },
        (success) async {
          final updatedUser = User.fromJson(success.data['data']);

          // print('Local stored user: ${user.value.toJson()}');

          if (updatedUser != user.value) {
            print('User details are different. Updating local user...');

            // Update the user and save it to SecureStorage
            user(updatedUser);

            await SecureStorage().writeSecureData(
              'user',
              jsonEncode(updatedUser.toJson()),
            );

            print('User details updated locally.');
          } else {
            print('No updates in user details.');
          }

          return true; // Return true indicating success
        },
      );
    }
    return false; // Return false if token is empty
  }

  Future<void> updateDeviceToken() async {
    if (AuthController.controller.user.value.id != null) {
      String? deviceToken = await FirebaseService.getDeviceToken();
      Map<String, dynamic> deviceData = await DeviceController().getDeviceInfo();

      Map<String, dynamic> data = {
        "device_token": deviceToken,
        "device_id": deviceData['id'],
        "device_name": deviceData['model'],
        "device_type": deviceData['brand'],
      };
      var response = await ApiService.postAuthenticatedResource('devices/register', data);
      response.fold((failure) {
        Modal.showToast(msg: failure.message);
      }, (success) {
        print('device registered');
      });
    }

    //  print(updateDeviceToken);
  }

  Future<void> localLogout({Failure? failure}) async {
    Modal.loading(
      content: Column(
        children: [
          if (failure != null) Text('Session Expired'),
          LogoutLoading(),
        ],
      ),
    );

    // Delay for 5 seconds (optional, based on your use case)
    await Future.delayed(Duration(seconds: 2));
    await SecureStorage().deleteSecureData('token');
    await SecureStorage().deleteSecureData('user');

    // Clear AuthController's token and user observable
    AuthController authController = Get.find<AuthController>();
    authController.token.value = '';
    authController.user.value = User(); // Reset user to an empty User model

    // Redirect to the login page
    Get.offAllNamed('/login');
  }

  


Future<void> signInWithGoogle() async {
    String? userDetails = await SecureStorage().readSecureData('user');

    if (userDetails == null) {
      await googleSignIn.signOut();
    }

    Modal.loading();
    final GoogleSignInAccount? googleAccount =
        await googleSignIn.signIn().catchError((err) {
      Get.back();
      Modal.showToast(msg: err.toString());
    });

    if (googleAccount == null) {
      Get.back();

      return;
    }

    final GoogleSignInAuthentication googleAuthentication =
        await googleAccount.authentication;
    var response = await ApiService.postPublicResource(
        'sign-in-with-google', {'token': googleAuthentication.accessToken});

    // Modal.androidDialog(context,title: 'Authenticating');
    response.fold((failure) {
      Get.back();
      Modal.errorDialog( failure:  failure);
    }, (success) async {
        final data = success.data['data'];
        print('DATA----------------');
        print(data);
        print('DATA--------------');
        await SecureStorage().writeSecureData('token', data['access_token']);
        await SecureStorage().writeSecureData('user', jsonEncode(data['user']));
       
        await loadTokenAndUser();
        await AuthController.controller.updateDeviceToken();
        Get.offAllNamed('/home-main');
    });
  }


  





}