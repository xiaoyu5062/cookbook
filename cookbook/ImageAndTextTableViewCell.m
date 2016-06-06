//
//  ImageAndTextTableViewCell.m
//  cookbook
//
//  Created by 张逢阳 on 15/8/12.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import "ImageAndTextTableViewCell.h"

@implementation ImageAndTextTableViewCell

- (void)awakeFromNib {
    // Initialization code
   // self.img.layer.cornerRadius=self.img.frame.size.width/2;
    //self.img.clipsToBounds=YES;
    UIView *view=[[UIView alloc]init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self setSelectedBackgroundView:view];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
