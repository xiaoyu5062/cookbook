//
//  ViewController.m
//  cookbook
//
//  Created by 张逢阳 on 15/8/9.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import "ViewController.h"
#import "ConstFile.h"
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import "TagModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"openID=%@",OpenID);
    //[self getTags];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getTags{
    NSString *path = API_category;
    NSString *api_id = APPID;
    NSString *method = Method_Get;
    JHAPISDK *juheapi = [JHAPISDK shareJHAPISDK];
    
    [juheapi executeWorkWithAPI:path
                          APIID:api_id
                     Parameters:nil
                         Method:method
                        Success:^(id responseObject){
                               int error_code = [[responseObject objectForKey:@"error_code"] intValue];
                                if (!error_code) {
                                    NSLog(@" %@", responseObject);
                                }else{
                                    NSLog(@" %@", responseObject);
                                }
                            
                        } Failure:^(NSError *error) {
                            NSLog(@"error:   %@",error.description);
                        }];
}
@end
