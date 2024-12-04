import 'package:geogate/core/api/dio/api_service.dart';
import 'package:geogate/core/shared/modal/modal.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/course/model/available_course.dart';
import 'package:get/get.dart';

class CourseController  extends GetxController{
static CourseController controller = Get.find();

var availableCourses = <AvailableCourse>[].obs;
var isFetchingCourse =false.obs;


Future<void> fetchAvailableCourse() async {
    isFetchingCourse(true);
    update();

    var response = await ApiService.getAuthenticatedResource('courses/available');

    response.fold(
      (failure) {
        isFetchingCourse(false);
        update();
        Modal.errorDialog(failure: failure);
      },
      (success) {
        isFetchingCourse(false);

        var courses = (success.data['data'] as List<dynamic>);
        availableCourses.value = courses
            .map((json) => AvailableCourse.fromMap(json as Map<String, dynamic>))
            .toList();

        update();
      },
    );
  }


Future<void> refreshData() async {
    await Future.wait([
      AuthController.controller.fetchAndUpdateUserDetails(),
      fetchAvailableCourse(),
    ]);
  }


}