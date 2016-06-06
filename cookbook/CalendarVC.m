//
//  CalendarVC.m
//  cookbook
//
//  Created by 张逢阳 on 15/8/9.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import "CalendarVC.h"
#import "Comm.h"
#import <UIImageView+WebCache.h>
#import "ConstFile.h"
#import "DetailTableViewController.h"
@interface CalendarVC ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UITableView * tableView;
@property (strong,nonatomic) NSMutableArray * dataSource;
@end

@implementation CalendarVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"最近浏览"];
    
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    
    [self getData];
}

-(void)getData{
    _dataSource=[NSMutableArray arrayWithArray:[Comm getHistoryCache] ];
    [_tableView reloadData];
}

#pragma mark - UITableView
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"commitEditingStyle");
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSLog(@"可以删除了");
        [ Comm deleteHistoryWithCookId:((InfoModel*)[_dataSource objectAtIndex:indexPath.row]).id];
        
        [_dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layer.transform=CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.25 animations:^{
        cell.layer.transform=CATransform3DMakeScale(1, 1, 1);
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailTableViewController *vc=[[DetailTableViewController alloc]initWithInfoModel:(InfoModel*)[_dataSource objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * Identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    InfoModel *model=(InfoModel*)[_dataSource objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[model.albums objectAtIndex:0]] placeholderImage:defaultImage];
    cell.textLabel.text=model.title;
    cell.detailTextLabel.text=model.imtro;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
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
