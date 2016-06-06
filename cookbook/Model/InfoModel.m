//
//  InfoModel.m
//  cookbook
//
//  Created by 张逢阳 on 15/8/12.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import "InfoModel.h"

@implementation InfoModel

MJCodingImplementation

+ (NSDictionary*)objectClassInArray{
    return @{
             @"steps":@"StepModel"
             };
}

-(BOOL)isEqual:(id)object{
    if (object==self) {
        return YES;
    }
    if (![object isKindOfClass:[InfoModel class]]) {
        return NO;
    }
    InfoModel* model=(InfoModel*) object;
    return  [model.id isEqualToString:self.id];
 
}
@end

@implementation StepModel
MJCodingImplementation


@end