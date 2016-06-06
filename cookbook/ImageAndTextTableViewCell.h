//
//  ImageAndTextTableViewCell.h
//  cookbook
//
//  Created by 张逢阳 on 15/8/12.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAndTextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *text;

@end
