//
//  InfoCollectionViewController.m
//  cookbook
//
//  Created by 张逢阳 on 15/8/12.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import "InfoCollectionViewController.h"
#import "InfoCollectionViewCell.h"
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import "ConstFile.h"
#import "InfoModel.h"
#import <UIKit/UIKit.h>
#import <MJRefresh.h>
#import "DetailTableViewController.h"
#import "Comm.h"

@interface InfoCollectionViewController ()<UISearchBarDelegate>
@property NSString* tagId;
@property NSMutableArray *dataSource;
@property UIImage * defaultImage;
@property BOOL isSearch;
@property NSString * searchText;
@end

@implementation InfoCollectionViewController

static NSString * const reuseIdentifier = @"InfoCollectionViewCell";
static int pn=0;
-(id)initWithTagId:(NSString* )tagId{
    self= [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
    _tagId=tagId;
    _isSearch=false;
    return self;
}

-(id)initWithSearchText:(NSString *) searchText{
    self=[super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
    _searchText=searchText;
    _isSearch=true;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setTitle:@"返回"];
    if (_isSearch) {
        //导航栏用搜索框
        
        CGRect  frame=self.navigationController.navigationBar.frame;
        frame.origin.y=0;
       
       // frame.origin.x=self.navigationController.navigationItem.leftBarButtonItem.width+10;
        UIView *titleView=[[UIView alloc]initWithFrame:frame];
        [titleView setBackgroundColor:[UIColor clearColor]];
        frame.size.width-=80;
       
        UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:frame];
        searchBar.backgroundColor=[UIColor clearColor];
        [searchBar setTintColor:[UIColor grayColor]];
        [searchBar setPlaceholder:@"菜谱搜索"];
        [searchBar setText:_searchText];
        //去除搜索框背景
        for (UIView *view in searchBar.subviews) {
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
        searchBar.delegate=self;
        searchBar.layer.cornerRadius=2;
        //searchBar.layer.masksToBounds=YES;
        [titleView addSubview:searchBar];
        self.navigationItem.titleView=titleView;
    }
    
    _defaultImage=defaultImage;//[UIImage imageNamed:@"config"];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
    [self setupRefresh];
}


-(void)setupRefresh{
    // 下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pn=0;
        if (!_isSearch) {
            [self getDataByTagId];
        }
        else{
            [self getDataBySearchText];
        }
        [self.collectionView.header endRefreshing];
    }];
    [self.collectionView.header beginRefreshing];
    
    // 上拉刷新
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pn+=30;
        if(!_isSearch){
            [self getDataByTagId];
        }else{
            [self getDataBySearchText];
        }
        // 结束刷新
        [self.collectionView.footer endRefreshing];

    }];
    // 默认先隐藏footer
    //self.collectionView.header.hidden = YES;
}

-(void)getDataBySearchText{
   
    //调用数据接口
        JHAPISDK *juheapi = [JHAPISDK shareJHAPISDK];
        NSDictionary *parms=@{
                              @"menu":_searchText,
                              @"pn": [NSString stringWithFormat:@"%d",pn],
                              @"rn":@"30"
                              };
        [juheapi executeWorkWithAPI:API_query
                              APIID:APPID
                         Parameters:parms
                             Method:Method_Get
                            Success:^(id responseObject){
                                int error_code = [[responseObject objectForKey:@"error_code"] intValue];
                                if (!error_code) {
                                    //  NSLog(@" %@", responseObject);
    
                                    if (pn==0) {
                                        _dataSource=[InfoModel objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"result"] objectForKey:@"data"]];

                                    }else{
                                        NSArray* arry=[InfoModel objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"result"] objectForKey:@"data"]];

                                        [_dataSource addObjectsFromArray:arry];
                                    }
                                    
                                    [self.collectionView reloadData];
    
                                }else{
                                    NSLog(@" %@", responseObject);
                                    ALERT_MESSAGE(@"没有搜索到相关菜谱")
                                }
    
                            } Failure:^(NSError *error) {
                                NSLog(@"error:   %@",error.description);
                            }];
  

}

-(void)getDataByTagId{
    NSString *url=[NSString stringWithFormat:@"%@?cid=%@&pn=%d&rn=%d",API_queryByTag,_tagId,pn,30];
    if( ![Comm urlContains:url]){
    JHAPISDK *juheapi = [JHAPISDK shareJHAPISDK];
    NSDictionary *parms=@{
                          @"cid":_tagId,
                          @"pn": [NSString stringWithFormat:@"%d",pn],
                          @"rn":@"30"
                          };
    [juheapi executeWorkWithAPI:API_queryByTag
                          APIID:APPID
                     Parameters:parms
                         Method:Method_Get
                        Success:^(id responseObject){
                            int error_code = [[responseObject objectForKey:@"error_code"] intValue];
                            if (!error_code) {
                                if (pn==0) {
                                _dataSource=[InfoModel objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"result"] objectForKey:@"data"]];
                                    [ Comm setCacheWithUrl:url :_dataSource];
                                }else{
                                    NSArray* arry=[InfoModel objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"result"] objectForKey:@"data"]];
                                    [ Comm setCacheWithUrl:url :arry];
                                    [_dataSource addObjectsFromArray:arry];
                                }
                               [self.collectionView reloadData];
                                
                            }else{
                                NSLog(@" %@", responseObject);
                            }
                            
                        } Failure:^(NSError *error) {
                            NSLog(@"error:   %@",error.description);
                        }];
    }else{
        NSLog(@"从缓存中取的数据 url=%@",url);
        if (pn==0) {
               _dataSource= [NSMutableArray arrayWithArray:[Comm getCacheWithUrl:url]];
        }else{
            [_dataSource addObjectsFromArray:[Comm getCacheWithUrl:url]];
        }
        [self.collectionView reloadData];
     
    }
}

#pragma mark -UISearchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _searchText=searchBar.text;
    pn=0;
    [self getDataBySearchText];
    
    //记录历史记录
    if ([SearchArray containsObject:searchBar.text]) {
        NSUInteger index=[SearchArray indexOfObject:searchBar.text];
        [SearchArray removeObjectAtIndex:index];
    }
    [SearchArray insertObject:searchBar.text atIndex:0];
 
    [[NSUserDefaults standardUserDefaults] setObject:SearchArray forKey:@"search"];
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 110);
}

#pragma mark <UICollectionViewDataSource>



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InfoCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    InfoModel *model=(InfoModel*)[_dataSource objectAtIndex:indexPath.row];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:[model.albums objectAtIndex:0]] placeholderImage:_defaultImage];
    
    cell.text.text=model.title;
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    cell.layer.transform=CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.25 animations:^{
        cell.layer.transform=CATransform3DMakeScale(1, 1, 1);
    }];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailTableViewController * vc=[[DetailTableViewController alloc]initWithInfoModel:(InfoModel*)[_dataSource objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
