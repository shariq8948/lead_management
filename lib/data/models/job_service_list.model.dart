import 'package:flutter/material.dart';

class JobServiceListModel {
  String? id;
  String? service;
  String? ingredientid;
  String? remark;
  List<JobServiceIngredient>? ingredient;

  TextEditingController ingController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  JobServiceListModel(
      {this.id, this.service, this.ingredientid, this.remark, this.ingredient});

  JobServiceListModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    service = json['Service'];
    ingredientid = json['Ingredientid'];
    remark = json['Remark'];
    if (json['Ingredient'] != null) {
      ingredient = <JobServiceIngredient>[];
      json['Ingredient'].forEach((v) {
        ingredient!.add(JobServiceIngredient.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Service'] = service;
    data['Ingredientid'] = ingredientid;
    data['Remark'] = remark;
    if (ingredient != null) {
      data['Ingredient'] = ingredient!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobServiceIngredient {
  String? id;
  String? ingredient;

  JobServiceIngredient({this.id, this.ingredient});

  JobServiceIngredient.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    ingredient = json['Ingredient'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Ingredient'] = ingredient;
    return data;
  }
}
