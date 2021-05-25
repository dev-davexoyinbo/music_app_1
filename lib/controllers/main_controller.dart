import 'package:get/get.dart';

class MainController extends GetxController {
  RxBool showMediaSheet = false.obs;

  void displayMediaSheetAction(bool val) {
    showMediaSheet.value = val;
  }//end method displayMediaSheetAction
}//end class MainController