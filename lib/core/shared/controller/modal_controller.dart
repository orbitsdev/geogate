

import 'package:get/get.dart';

class ModalController extends  GetxController{
static ModalController controller = Get.find();
   var isDialogVisible = false.obs;

 

  void setDialog(bool value){
    isDialogVisible(value);
    update();
  }


  @override
  void onInit() {
    isDialogVisible = false.obs;
    super.onInit();

  }

}