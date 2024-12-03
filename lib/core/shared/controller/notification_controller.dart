
import 'package:geogate/core/api/dio/api_service.dart';
import 'package:geogate/core/shared/modal/modal.dart';
import 'package:geogate/core/shared/model/notification_model.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  static NotificationController controller = Get.find();
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  var isMarkLoading = false.obs;

  Future<void> loadNotifications() async {  
    print('load notif--');
    print('loacd');
    print('');
 isLoading(true);
 update();
    var response = await ApiService.getAuthenticatedResource('notifications');

    response.fold(
      (failure) {
        isLoading(false);
         update();
        Modal.errorDialog(failure: failure);
      },
      (success) {
        isLoading(false);
         update();
          var data = success.data['data'];  
          notifications((data as List<dynamic>).map((item) => NotificationModel.fromMap(item)).toList());
          update();
      }
    );
  }


   int get unreadNotificationCount {
    return notifications.where((notification) => notification.read_at == null).length;
  }
   void markNotificationsAsRead(context) async {
    isMarkLoading(true);
    update();
   
    List<String?> notificationIds = getUnReadNotifications();
    
    if (notificationIds.isEmpty) return;
    
    Map<String, dynamic> data = {
      'notification_ids': notificationIds,
    };
    
    
    print('----notifcaiton------');
    print(data);
    print('----------');
    var response = await ApiService.postAuthenticatedResource('notifications/read/multiple', data);

    response.fold(
      (failure) {
        isMarkLoading(false);
        update();
    
        Modal.errorDialog(failure: failure);
      },
      (success) {
        print(success.data);
          isMarkLoading(false);
            update();
        loadNotifications();
      }
    );
  }

   List<String?> getUnReadNotifications() {
   
  List<String?> unread = notifications
        .where((notification) => notification.read_at == null)
        .map((notification) => notification.id)
        .toList();
       
         
        return unread;
  }
}
