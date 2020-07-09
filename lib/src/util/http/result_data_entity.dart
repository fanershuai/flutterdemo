//返回的结果类 可以根据后台返回数据进行改便2
import '../../../entity_factory.dart';

class Data<T> {
  List<T> listData;
  T mapData;
}

class ResultDataEntity<T> {
  int code;
  Data<T> data = new Data<T>();
  String message;

  ResultDataEntity({this.code, this.data, this.message});

  ResultDataEntity.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data.mapData = json['data'] != null
        ? EntityFactory.generateOBJ<T>(json["data"])
        : null;
    message = json['message'];
  }
}

class ResultDataListEntity<T> {
  int code;
  String message;
  Data<T> data = new Data<T>();


  ResultDataListEntity({this.code, this.message, List<T> list}){
    this.data.listData=list;
  }

  factory ResultDataListEntity.fromJson(json) {
    List<T> mData = List();
    if (json['data'] != null) {
      //遍历data并转换为我们传进来的类型
      (json['data'] as List).forEach((v) {
        mData.add(EntityFactory.generateOBJ<T>(v));
      });
    }

    return ResultDataListEntity(
      code: json["code"],
      message: json["msg"],
      list: mData,
    );
  }
}
