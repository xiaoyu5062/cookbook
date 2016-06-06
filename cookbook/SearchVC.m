//
//  SearchVC.m
//  cookbook
//
//  Created by 张逢阳 on 15/8/9.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import "SearchVC.h"
#import "ConstFile.h"
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import "InfoModel.h"
#import "InfoCollectionViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kClearButtonWidth 160
@interface SearchVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong , nonatomic) UITableView * tableView;
@property (strong,nonatomic) UISearchBar *searchBar;
@property NSMutableArray *dataSource;
@end
int pn=0;
@implementation SearchVC

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView  reloadData];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"搜索"];
 
    CGRect  frame=self.navigationController.navigationBar.frame;
    frame.origin.y=0;
    UIView *titleView=[[UIView alloc]initWithFrame:frame];
    [titleView setBackgroundColor:[UIColor clearColor]];
    frame.size.width-=20;
    _searchBar=[[UISearchBar alloc]initWithFrame:frame];
    _searchBar.backgroundColor=[UIColor clearColor];
    [_searchBar setTintColor:[UIColor grayColor]];
    [_searchBar setPlaceholder:@"菜谱搜索"];
    //去除搜索框背景
    for (UIView *view in _searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }

    
    _searchBar.delegate=self;
    _searchBar.layer.cornerRadius=2;
    //searchBar.layer.masksToBounds=YES;
    [titleView addSubview:_searchBar];
    self.navigationItem.titleView=titleView;
    
  
    //TableView
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [self getData];
    
    //清除历史记录按钮
    UIButton *btn_clear=[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-kClearButtonWidth)/2, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-44, kClearButtonWidth, 30)];
    [btn_clear setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [btn_clear setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn_clear.layer.borderColor=[UIColor orangeColor].CGColor;
    btn_clear.layer.borderWidth=1;
    btn_clear.layer.cornerRadius=5;
    
    [btn_clear addTarget:self action:@selector(clearHistory:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_clear];
}

-(void)clearHistory:(UIButton *)button{
    NSLog(@"清除按钮被点击");
    SearchArray =[NSMutableArray array];
    [[NSUserDefaults standardUserDefaults] setObject:SearchArray forKey:@"search"];
    [_tableView reloadData];
}

-(void)getData{
    //加载搜索历史记录
    NSArray * arry= [[NSUserDefaults standardUserDefaults] arrayForKey:@"search"];
    if (SearchArray==nil) {
        SearchArray=[NSMutableArray array];
    }
    SearchArray= [NSMutableArray arrayWithArray:arry ];
    [_tableView reloadData];

}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"search text:%@",searchBar.text);
    if ([SearchArray containsObject:searchBar.text]) {
        NSUInteger index=[SearchArray indexOfObject:searchBar.text];
        [SearchArray removeObjectAtIndex:index];
    }
   
    [SearchArray insertObject:searchBar.text atIndex:0];
    [_tableView reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:SearchArray forKey:@"search"];
    InfoCollectionViewController *vc=[[InfoCollectionViewController alloc]initWithSearchText:searchBar.text];
    [vc setTitle:searchBar.text];
    [self.navigationController pushViewController:vc animated:YES];
    
   
}

#pragma mark - UITableView
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"commitEditingStyle");
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSLog(@"可以删除了");
        [SearchArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[NSUserDefaults standardUserDefaults] setObject:SearchArray forKey:@"search"];
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//点击历史记录直接搜索
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _searchBar.text=[SearchArray objectAtIndex:indexPath.row];
    [self searchBarSearchButtonClicked:_searchBar];
   }

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layer.transform=CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.25 animations:^{
        cell.layer.transform=CATransform3DMakeScale(1, 1, 1);
    }];
    
}-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return SearchArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[[UITableViewCell alloc]init];
    cell.textLabel.text=[SearchArray objectAtIndex:indexPath.row];
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
