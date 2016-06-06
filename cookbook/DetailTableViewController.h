//
//  DetailTableViewController.h
//  cookbook
//
//  Created by 张逢阳 on 15/8/13.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"
@interface DetailTableViewController : UITableViewController
-(id)initWithInfoModel:(InfoModel * ) model;
@end
