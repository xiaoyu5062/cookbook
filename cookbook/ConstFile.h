//
//  ConstFile.h
//  cookbook
//
//  Created by 张逢阳 on 15/8/9.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import <Reachability.h>
#import <FMDB.h>

extern NSString * OpenID;
extern NSString * APPID;
extern NSString * Method_Get;
extern NSString * Method_Post;
extern NSMutableArray * SearchArray;
extern NSMutableArray * favSource;//收藏数据,离线,存放NSData
extern NSMutableArray * favModels;//收藏数据,存放对象,程序在所有操作中都使用此对象,只有存档时使用NSData
extern UIImage *    defaultImage;


extern FMDatabase * db;//数据库
//API
//菜谱大全e
extern NSString * API_query;//http://apis.juhe.cn/cook/query.php
//查看菜谱的所有分类，如菜系、口味等
extern NSString * API_category; //http://apis.juhe.cn/cook/category
//按标签检索菜谱
extern NSString * API_queryByTag;//http://apis.juhe.cn/cook/index
//按菜谱ID查看详细
extern NSString * API_queryByID;//http://apis.juhe.cn/cook/queryid


#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#define ALERT_MESSAGE(msg) {\
MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo: [UIApplication sharedApplication].keyWindow animated:YES];\
hud.mode=MBProgressHUDModeText;\
hud.labelText=msg;\
hud.removeFromSuperViewOnHide=YES;\
[hud hide:YES afterDelay:1];\
}


#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
 colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
 blue:((float)(rgbValue & 0x0000FF))/255.0 \
 alpha:alphaValue]


@interface ConstFile : NSObject

@end


