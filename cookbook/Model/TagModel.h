//
//  TagModel.h
//  cookbook
//
//  Created by 张逢阳 on 15/8/10.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
/** heheehhe*/
@interface TagModel : NSObject
@property (nonatomic, strong) NSString *parentId;
/** 大类名称*/
@property (nonatomic, strong) NSString *name;
/** 小分类*/
@property (nonatomic, strong) NSArray *list;
@end

@interface Tag_ListModel : NSObject
/** 分类ID*/
@property (nonatomic, strong) NSString *id;
/** 小分类名称*/
@property (nonatomic, strong) NSString *name;
/** 所属大分类ID*/
@property (nonatomic, strong) NSString *parentId;

@end
