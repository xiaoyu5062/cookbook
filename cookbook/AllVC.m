//
//  AllVC.m
//  cookbook
//
//  Created by 张逢阳 on 15/8/9.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import "AllVC.h"
#import "JHAPISDK.h"
#import "ConstFile.h"
#import "TagModel.h"
#import "ImageAndTextTableViewCell.h"
#import "InfoCollectionViewController.h"
static NSString *cellIndetifier=@"ImageAndTextTableViewCell";
NSUInteger leftIndex=0;//左侧选中索引
@interface AllVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView * tableView;

@property (strong ,nonatomic) UITableView * rightTableView;

@property (strong,nonatomic) NSArray * dataSource;


@end

@implementation AllVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSThread sleepForTimeInterval:1]; //延迟启动画面
    
    // Do any additional setup after loading the view.
    [self  setTitle:@"菜谱大师"];
    //leftTableView
    CGRect left_frame=self.view.frame;
    left_frame.size.width=80;
    _tableView=[[UITableView alloc]initWithFrame:left_frame];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView setTag:101];
    _tableView.separatorStyle=UITableViewCellStyleDefault;//UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    [self.tableView registerNib:[UINib nibWithNibName:cellIndetifier bundle:nil] forCellReuseIdentifier:@"ImageAndTextTableViewCell"];
  
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self getTagData];
    
    //rightTablelView
    CGRect right_frame=self.view.frame;
    right_frame.size.width-=80;
    right_frame.origin.x+=80;
    right_frame.origin.y=self.navigationController.navigationBar.frame.size.height+20;
    right_frame.size.height-=right_frame.origin.y+self.tabBarController.tabBar.frame.size.height;
    _rightTableView=[[UITableView alloc]initWithFrame:right_frame];
    _rightTableView.delegate=self;
    _rightTableView.dataSource=self;
    [_rightTableView setTag:102];
    UIView * footView=[[UIView alloc]init];
    [footView setBackgroundColor:[UIColor whiteColor]];
    [_rightTableView setTableFooterView:footView];
    [self.view addSubview:_rightTableView];
    
   }
/** 获取分类数据*/
-(void)getTagData{
    NSString * path=[[NSBundle mainBundle] pathForResource:@"TagList" ofType:@"plist"];
    NSArray * tags=[[NSArray alloc]initWithContentsOfFile:path];
    _dataSource=[TagModel objectArrayWithKeyValuesArray:tags];
    [_tableView reloadData];
    //设置默认选中第一行
    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [self tableView:_tableView didSelectRowAtIndexPath:ip];
    //暂时先用本地数据来替代,API目录更新一般没有那么快
//    JHAPISDK *juheapi = [JHAPISDK shareJHAPISDK];
//    [juheapi executeWorkWithAPI:API_category
//                          APIID:APPID
//                     Parameters:nil
//                         Method:Method_Get
//                        Success:^(id responseObject){
//                            int error_code = [[responseObject objectForKey:@"error_code"] intValue];
//                            if (!error_code) {
//                              //  NSLog(@" %@", responseObject);
//                                _dataSource=[TagModel objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
//                                [_tableView reloadData];
//                                //设置默认选中第一行
//                                NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
//                                [_tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
//                                [self tableView:_tableView didSelectRowAtIndexPath:ip];
//                                
//                            }else{
//                                NSLog(@" %@", responseObject);
//                            }
//                            
//                        } Failure:^(NSError *error) {
//                            NSLog(@"error:   %@",error.description);
//                        }];
}

#pragma mark -UITableView
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中左侧个性右侧
    if (tableView.tag==101) {
        leftIndex=indexPath.row;
        [_rightTableView reloadData];
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    else if (tableView.tag==102){
        Tag_ListModel *molde=(Tag_ListModel*)((TagModel*)[_dataSource objectAtIndex:leftIndex]).list[indexPath.row];
        InfoCollectionViewController *vc=[[InfoCollectionViewController alloc]initWithTagId:molde.id];
        [vc setTitle:molde.name];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==101) {
        return 80;
    }else
        return 40;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==101) {
        return _dataSource.count;
    }
    else{
        return ((TagModel*)[_dataSource objectAtIndex:leftIndex]).list.count;
    }
}



-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==101) {
        ImageAndTextTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndetifier forIndexPath:indexPath];
        TagModel *model=(TagModel*)[_dataSource objectAtIndex:indexPath.row];
        cell.text.text=model.name;
        cell.img.image=[UIImage imageNamed:model.parentId];
        return cell;
    }
    else{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.text=((Tag_ListModel*)[((TagModel*)[_dataSource objectAtIndex:leftIndex]).list objectAtIndex:indexPath.row]).name;
    return cell;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
