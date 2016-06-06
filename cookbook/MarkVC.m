//
//  MarkVC.m
//  cookbook
//
//  Created by 张逢阳 on 15/8/9.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import "MarkVC.h"
#import "InfoModel.h"
#import "ConstFile.h"
#import <UIImageView+WebCache.h>
#import "DetailTableViewController.h"
@interface MarkVC ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UITableView * tableView;
@end

@implementation MarkVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的收藏"];
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
//    favSource=[NSMutableArray arrayWithObject:[NSKeyedArchiver archivedDataWithRootObject:m]];
//    [[NSUserDefaults standardUserDefaults] setObject:_favSource forKey:@"fav"];
//    
  
//    NSLog(@"%@",[NSKeyedUnarchiver unarchiveObjectWithData:[_favSource objectAtIndex:0]]);
}

#pragma mark - UITableView
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailTableViewController *vc=[[DetailTableViewController alloc]initWithInfoModel:(InfoModel*)[favModels objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layer.transform=CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.25 animations:^{
        cell.layer.transform=CATransform3DMakeScale(1, 1, 1);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return favModels.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString * identifier=@"sc_cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    InfoModel * model=(InfoModel*)[favModels objectAtIndex:indexPath.row];
   [ cell.imageView sd_setImageWithURL:[NSURL URLWithString:[model.albums objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"tran"]];
    // [ cell.imageView sd_setImageWithURL:[NSURL URLWithString:[model.albums objectAtIndex:0]] ];
    cell.textLabel.text=model.title;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
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
