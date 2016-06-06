//
//  BurTableViewCell.h
//  cookbook
//
//  Created by 张逢阳 on 15/8/13.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 材料Cell*/
@interface BurTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name_1;
@property (weak, nonatomic) IBOutlet UILabel *value_1;
@property (weak, nonatomic) IBOutlet UILabel *name_2;
@property (weak, nonatomic) IBOutlet UILabel *value_2;

@end
