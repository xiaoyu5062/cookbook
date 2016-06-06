//
//  AppDelegate.m
//  cookbook
//
//  Created by 张逢阳 on 15/8/9.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import "AppDelegate.h"
#import "ConstFile.h"
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import "AllVC.h"
#import "SearchVC.h"
#import "MarkVC.h"
#import "ConfigVC.h"
#import "CalendarVC.h"
#import <Reachability.h>
#import <UMengAnalytics-NO-IDFA/MobClick.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


-(void)initDB{
    // 首先获取iPhone上Sqlite3的数据库文件的地址
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Cache"];
    NSLog(@"%@",path);
    /*
     1、当数据库文件不存在时，fmdb会自己创建一个。
     2、 如果你传入的参数是空串：@"" ，则fmdb会在临时文件目录下创建这个数据库，数据库断开连接时，数据库文件被删除。
     3、如果你传入的参数是 NULL，则它会建立一个在内存中的数据库，数据库断开连接时，数据库文件被删除。
     */
    
    db=[FMDatabase databaseWithPath:path];
    [db open];
    //如果表不存在,创建
    if(![self isTableOK:@"T_Url"]){
        NSLog(@"表不存在");
        
            //创建URL表
            NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS 'T_Url' ('id' INTEGER PRIMARY KEY AUTOINCREMENT, 'url' TEXT)";
            BOOL res = [db executeUpdate:sqlCreateTable];
            if (!res) {
                NSLog(@"error when creating db table");
                return;
            } else {
                NSLog(@"success to creating db table <T_Url>");
            }
            
            sqlCreateTable=@"CREATE TABLE IF NOT EXISTS 'T_Cook' ('id' TEXT PRIMARY KEY, 'uid' INTEGER ,'title' TEXT,'tags' TEXT,'imtro' TEXT,'ingredients' TEXT, 'burden' TEXT,'albums' TEXT, 'steps' INTEGER)";
            res=[db executeUpdate:sqlCreateTable];
            if (!res) {
                NSLog(@"error when creating db table");
                return;
            } else {
                NSLog(@"success to creating db table <T_Cook>");
            }
            
            sqlCreateTable=@"CREATE TABLE IF NOT EXISTS 'T_Step' ( 'id' INTEGER PRIMARY KEY AUTOINCREMENT,'img' TEXT,'step' TEXT, 'xh' INTEGER,'cookId' TEXT)";
            res=[db executeUpdate:sqlCreateTable];
            if (!res) {
                NSLog(@"error when creating db table");
                return;
            } else {
                NSLog(@"success to creating db table <T_Step>");
            }
        

    }
    
    //历史记录表
    if(![self isTableOK:@"T_History"]){
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS 'T_History' ('id' INTEGER PRIMARY KEY AUTOINCREMENT, 'cookId' TEXT)";
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
            return;
        } else {
            NSLog(@"success to creating db table <T_History>");
        }
    }
    [db close];
}

// 判断是否存在表
- (BOOL) isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %ld", (long)count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}
//UMeng统计
-(void)initUMeng{
    [MobClick startWithAppkey:@"56432ddb67e58ed0f7001a52" reportPolicy:BATCH channelId:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
 
    
//    if( [self GetCurrentNet] ==0){
//        ALERT_MESSAGE(@"当前无网络,可以使用离线收藏");
//    }
    [self initConst];
    [self initDB];
    [self initUMeng];
    //config JHSDK
    [[JHOpenidSupplier shareSupplier] registerJuheAPIByOpenId:OpenID];
    
   
    UITabBarController *tab=[[UITabBarController alloc]init];
    AllVC *allVC=[[AllVC alloc]init];
    allVC.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"菜谱大师" image:[UIImage imageNamed:@"home"] tag:0];
    
    SearchVC *allVC2=[[SearchVC alloc]init];
    allVC2.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"搜索" image:[UIImage imageNamed:@"light"] tag:1];

    
    MarkVC *allVC3=[[MarkVC alloc]init];
    allVC3.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"我的收藏" image:[UIImage imageNamed:@"flower"] tag:2];
    
    CalendarVC *allVC5=[[CalendarVC alloc]init];
    allVC5.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"最近浏览" image:[UIImage imageNamed:@"calendar"] tag:3];
 
    ConfigVC *allVC4=[[ConfigVC alloc]init];
    allVC4.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"设置" image:[UIImage imageNamed:@"config"] tag:4];
   
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:allVC];
   // [nav.navigationBar setBackgroundColor:[UIColor redColor]];
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:allVC2];
    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:allVC3];

      UINavigationController *nav4=[[UINavigationController alloc]initWithRootViewController:allVC5];
    UINavigationController *nav5=[[UINavigationController alloc]initWithRootViewController:allVC4];
    //tab.viewControllers=@[nav,nav2,nav3,nav4,nav5];
    tab.viewControllers=@[nav,nav2,nav3,nav4];
    UIColor *color=UIColorFromRGBA(0xFF6666, 1);
    for (UINavigationController *vc in tab.viewControllers) {
       // [vc.navigationBar setOpaque:YES];
        vc.navigationBar.barStyle=UIBarStyleBlackTranslucent;
  
        //vc.navigationBar.barTintColor=color;//UIColorFromRGBA(0xFFCC33,1);//[UIColor orangeColor];
       
    }
      
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    //UIColor *color=[UIColor colorWithRed:1  green:153/255 blue:204/255 alpha:1];
    [self.window setTintColor:color];

    self.window.rootViewController=tab;
    [self.window makeKeyAndVisible];
    
   
    return YES;
}
-(void)initConst{
    defaultImage=[UIImage imageNamed:@"tran"];
    //收藏数据
    favSource=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"fav"]];
   favModels=[NSMutableArray array];
    if (favSource) {
        for (NSData * item in favSource) {
            [favModels addObject:[NSKeyedUnarchiver unarchiveObjectWithData:item]];
        }
    }else{
        favSource=[NSMutableArray array];
        
    }
}

 -(NSUInteger) GetCurrentNet{
    Reachability *r=[Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            return 0;
        case ReachableViaWiFi:
            return 2;
        case  ReachableViaWWAN:
            return 1;
        default:
            return 3;
    }
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
