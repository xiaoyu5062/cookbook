//
//  InfoCollectionViewController.h
//  cookbook
//
//  Created by 张逢阳 on 15/8/12.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface InfoCollectionViewController : UICollectionViewController
/** 根据标签id初始化*/
-(id)initWithTagId:(NSString* )tagId;
/** 根据搜索内容初始化*/
-(id)initWithSearchText:(NSString *) searchText;
@end
