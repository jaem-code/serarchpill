import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:serarchpill/pill.dart';

class PillService extends ChangeNotifier {
  PillService() {
  }

  List<Pill> pillList = []; // 책 목록
  List<Pill> likedPillList = [];

  // 좋아요 토글 메서드 수정
  void toggleLikePill({required Pill pill}) {
    pill.isLiked = !pill.isLiked;

    if (pill.isLiked) {
      likedPillList.add(pill); // "좋아요"한 약을 목록에 추가
    } else {
      likedPillList.remove(pill); // "좋아요" 취소한 약을 목록에서 제거
    }

    notifyListeners();
  }


  void search(String q) async {
    pillList.clear(); // 검색 버튼 누를때 이전 데이터들을 지워주기

    var address = "http://apis.data.go.kr/1471000/MdcinGrnIdntfcInfoService01/getMdcinGrnIdntfcInfoList01";
    var key = "eMEhP7QNlj%2B8kN2%2F%2Bt8TywozszylgFK78iAr3OUwWs7mFDjpFX3pzxCAyAwu7kDqMYDFFloEq8wOl4xwl4DVnQ%3D%3D";

    if (q.isNotEmpty) {
      Response res = await Dio().get(
        "$address?serviceKey=$key&type=json&item_name=$q",
      );

      Map<String, dynamic> body = res.data["body"];
      List items = body["items"];

      for (Map<String, dynamic> item in items) {
        Pill pill = Pill.fromJson(item);
        pillList.add(pill);
      }
    }
    notifyListeners();
  }
}