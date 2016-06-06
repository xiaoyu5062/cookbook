//
//  StepTableViewCell.h
//  cookbook
//
//  Created by 张逢阳 on 15/8/13.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) UIFont *currFont;
-(void)initText;
@end
