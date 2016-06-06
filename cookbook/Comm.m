//
//  Comm.m
//  cookbook
//
//  Created by 张逢阳 on 15/8/21.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import "Comm.h"
#import "ConstFile.h"

static Comm * sharedObj=nil;
@implementation Comm

+(Comm*)sharedInstance{
    @synchronized(self){
        if (sharedObj==nil) {
          sharedObj=  [[self alloc]init];
        }
    }
    return sharedObj;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        if (sharedObj==nil) {
            sharedObj=[super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}

//是否已请求过此URL
+(BOOL)urlContains:(NSString *) url{
    if([db open]){
    NSString * sql=[NSString stringWithFormat:@"select count(*) from T_Url where url = '%@'",url];
       NSInteger count=  [db intForQuery:sql];
        [db close];
        return count!=0;
    }else
        return NO;
}

+(BOOL)setCacheWithUrl:(NSString*)url :(NSArray *)infoModelArray{
    if (infoModelArray.count<1) {
        return NO;
    }
    [db open];
   
    [db beginTransaction];
    BOOL isRollBack=NO;
    @try {
        NSString * sql=[NSString stringWithFormat:@"insert into T_Url (url) values ('%@') ",url];
        [db executeUpdate:sql];
        NSInteger urlId=[db intForQuery:@"select last_insert_rowid()"];
        if (urlId==0) {
            return NO;
        }
        
        for (InfoModel* item in infoModelArray) {
            NSString * count_sql=[NSString stringWithFormat:@"select count(*) from T_cook where id='%@'",item.id];
            NSString *sql_infomodel;
            NSInteger count=[db intForQuery:count_sql];
            if(count==0){//如果搜索中有过此菜谱只需要更新所属的URL即可
            sql_infomodel=[NSString stringWithFormat:@"insert into T_Cook (id,uid,title,tags,imtro,ingredients,burden,albums) values ('%@',%ld,'%@','%@','%@','%@','%@','%@')",item.id,(long)urlId,item.title,item.tags,item.imtro,item.ingredients,item.burden,[item.albums objectAtIndex:0]];
            }else{
                sql_infomodel=[NSString stringWithFormat:@"update T_Cook set uid=%ld where id='%@'",(long)urlId,item.id];
            }
           // NSLog(@"sql=%@",sql_infomodel);
         BOOL result=   [db executeUpdate:sql_infomodel];
            
            if (!result) {
                NSLog(@"插入失败 %@",sql_infomodel);
                continue;
            }
            
            for (int i=0; i<item.steps.count; i++) {
                StepModel *model=[item.steps objectAtIndex:i];
                NSString * sql_stepModel=[NSString stringWithFormat:@"insert into T_Step (img,step,xh,cookId) values ('%@','%@',%d,'%@')",model.img,model.step,i,item.id];
               // NSLog(@"%@",sql_stepModel);
                result=[db executeUpdate:sql_stepModel];
                if (!result) {
                    NSLog(@"插入失败 sql:%@  %@",item.title,model.step);
                }
            }
        }
    }
    @catch (NSException *exception) {
        isRollBack=YES;
        [db rollback];
    }
    @finally {
        if (!isRollBack) {
            [db commit ];
             [db close];
             return YES;
        }
         [db close];
        return NO;
    }  
   
}


+(NSArray *)getCacheWithUrl:(NSString *)url{
    NSString *sql=[NSString stringWithFormat:@"select * from T_Cook where uid=(select id from T_Url where url='%@' limit 0,1)",url];
   // NSLog(@"%@",sql);
    NSMutableArray * array=[NSMutableArray array];
    [db open];
    FMResultSet * rs=[db executeQuery:sql];
    while ([rs next]) {
        InfoModel *model=[[InfoModel alloc]init];
        model.id=[rs stringForColumn:@"id"];
        model.title=[rs stringForColumn:@"title"];
        model.tags=[rs stringForColumn:@"tags"];
        model.imtro=[rs stringForColumn:@"imtro"];
        model.ingredients=[rs stringForColumn:@"ingredients"];
        model.burden=[rs stringForColumn:@"burden"];
        model.albums=@[[rs stringForColumn:@"albums"]];
        [array addObject:model];
    }
    [db close];
    return array;
}

+(NSArray *)getStepsCacheWithCookId:(NSString *)cookId{
    NSString *sql=[NSString stringWithFormat:@"select * from T_Step where cookId='%@' order by xh",cookId];
    NSMutableArray *array=[NSMutableArray array];
    [db open];
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        StepModel *model=[[StepModel alloc]init];
        model.img=[rs stringForColumn:@"img"];
        model.step=[rs stringForColumn:@"step"];
        [array addObject:model];
    }
    [db close];
    return array;
}

+(BOOL)setCacheWithInfoModel:(InfoModel*)infoModel{
    //检查所有菜谱中有没有当前菜谱,如果有直接往历史记录里存,如果没有先在菜谱里增加一条,然后取到id再加到历史记录中
    [db open];
    
    [db beginTransaction];
    BOOL isRollBack=NO;
    @try {
        BOOL result=NO;
        NSString * count_sql=[NSString stringWithFormat:@"select count(*) from T_cook where id='%@'",infoModel.id];
        NSInteger count=[db intForQuery:count_sql];
        if (count==0) {
            //插入该菜谱信息 uid=0表示从搜索结果浏览后插入的数据
             NSString *sql_infomodel=[NSString stringWithFormat:@"insert into T_Cook (id,uid,title,tags,imtro,ingredients,burden,albums) values ('%@',%d,'%@','%@','%@','%@','%@','%@')",infoModel.id,0,infoModel.title,infoModel.tags,infoModel.imtro,infoModel.ingredients,infoModel.burden,[infoModel.albums objectAtIndex:0]];
           result= [db executeUpdate:sql_infomodel];
            if (!result) {
                NSLog(@"插入失败 sql:%@",sql_infomodel);
            }
            //插入步骤信息
            for (int i=0; i<infoModel.steps.count; i++) {
                StepModel *model=[infoModel.steps objectAtIndex:i];
                NSString * sql_stepModel=[NSString stringWithFormat:@"insert into T_Step (img,step,xh,cookId) values ('%@','%@',%d,'%@')",model.img,model.step,i,infoModel.id];
                // NSLog(@"%@",sql_stepModel);
                result=[db executeUpdate:sql_stepModel];
                if (!result) {
                    NSLog(@"插入失败 sql:%@  %@",infoModel.title,model.step);
                }
            }

        }
        //如果之前已经有此记录,删除
        NSString * sql_count=[NSString stringWithFormat:@"select count(*) from T_History where cookId='%@'",infoModel.id];
     count= [db intForQuery:sql_count];
        if (count>0) {
            [db executeUpdate:[NSString stringWithFormat:@"delete from T_History where cookId='%@'",infoModel.id
                               ]];
        }
        //插入历史记录表
        NSString * sql_history=[NSString stringWithFormat:@"insert into T_History (cookId) values ('%@')",infoModel.id];
        result=[db executeUpdate:sql_history];
        if (!result) {
            NSLog(@"插入历史记录表失败 sql=%@",sql_history);
        }

    }
    @catch (NSException *exception) {
        isRollBack=YES;
        [db rollback];
    }
    @finally {
        if (!isRollBack) {
            [db commit ];
            [db close];
            return YES;
        }
        [db close];
        return NO;
    }

    return YES;
}

+(NSArray *)getHistoryCache{
    [db open];
    NSMutableArray *array=[NSMutableArray array];
    NSString * sql_ids=[NSString stringWithFormat:@"select b.* from T_History a left join T_Cook b on a.cookId=b.id order by a.id desc"];
    FMResultSet *rs=[db executeQuery:sql_ids];
    while ([rs next]) {
        InfoModel *model=[[InfoModel alloc]init];
        model.id=[rs stringForColumn:@"id"];
        model.title=[rs stringForColumn:@"title"];
        model.tags=[rs stringForColumn:@"tags"];
        model.imtro=[rs stringForColumn:@"imtro"];
        model.ingredients=[rs stringForColumn:@"ingredients"];
        model.burden=[rs stringForColumn:@"burden"];
        model.albums=@[[rs stringForColumn:@"albums"]];
        [array addObject:model];
    }
    [db close];
    return array;

}

+(BOOL)deleteHistoryWithCookId:(NSString*)cookId{
    [db open];
    NSString * sql=[NSString stringWithFormat:@"delete from T_History where cookId='%@'",cookId];
    BOOL result=[db executeUpdate:sql];
    if (!result) {
        NSLog(@"删除浏览记录失败");
    }
    [db close];
    return result;
}

-(id)init{
    @synchronized(self){
       self= [super init];
        return self;
    }
}
@end
