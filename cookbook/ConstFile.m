//
//  ConstFile.m
//  cookbook
//
//  Created by 张逢阳 on 15/8/9.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import "ConstFile.h"
#warning 请替换成自己在聚合上的OpenID
 NSString * OpenID=@"......";
 NSString * APPID=@"46";
 NSString * Method_Get=@"GET";
 NSString * Method_Post=@"POST";
 NSMutableArray * SearchArray;
 NSMutableArray * favSource;
 NSMutableArray * favModels;
UIImage *    defaultImage;

FMDatabase * db;
//API
//菜谱大全
 NSString * API_query=@"http://apis.juhe.cn/cook/query.php";
//查看菜谱的所有分类，如菜系、口味等
 NSString * API_category=@"http://apis.juhe.cn/cook/category";
//按标签检索菜谱
 NSString * API_queryByTag=@"http://apis.juhe.cn/cook/index";
//按菜谱ID查看详细
NSString * API_queryByID=@"http://apis.juhe.cn/cook/queryid";



@implementation ConstFile

@end
