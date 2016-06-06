//
//  Comm.h
//  cookbook
//
//  Created by 张逢阳 on 15/8/21.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoModel.h"
@interface Comm : NSObject

+(Comm*)sharedInstance;

/** 判断是否此URL已经有缓存*/
+(BOOL)urlContains:(NSString *) url;

/** 根据url及数据设置缓存*/
+(BOOL)setCacheWithUrl:(NSString*)url :(NSArray *)infoModelArray;

/** 根据url取缓存数据*/
+(NSArray *)getCacheWithUrl:(NSString *)url;

/** 根据菜的ID获取该菜的步骤缓存数据*/
+(NSArray *)getStepsCacheWithCookId:(NSString *)cookId;

/** 设置浏览记录*/
+(BOOL)setCacheWithInfoModel:(InfoModel*)infoModel;

/** 获取历史浏览记录*/
+(NSArray *)getHistoryCache;

/** 根据菜谱ID删除浏览记录*/
+(BOOL)deleteHistoryWithCookId:(NSString*)cookId;
@end
