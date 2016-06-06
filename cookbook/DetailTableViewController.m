//
//  DetailTableViewController.m
//  cookbook
//
//  Created by 张逢阳 on 15/8/13.
//  Copyright (c) 2015年 张逢阳. All rights reserved.
//

#import "DetailTableViewController.h"
#import "InfoModel.h"
#import <UIImageView+WebCache.h>
#import "StepTableViewCell.h"
#import "BurTableViewCell.h"
#import "ConstFile.h"
#import "Comm.h"

@interface DetailTableViewController ()
@property (strong,nonatomic) InfoModel *dataSource;
@property (strong,nonatomic) NSMutableArray *models;
@property (strong,nonatomic) UIBarButtonItem *delButton;
@property (strong,nonatomic)UIBarButtonItem *favButton;
@property (strong,nonatomic) UIColor * defaultColor;

@end
static NSString * reuseIdentifier=@"StepTableViewCell";
static NSString * reuseIdentifier2=@"BurTableViewCell";
//static UIImage * defaultImage;
@implementation DetailTableViewController

-(id)initWithInfoModel:(InfoModel*)model{
    self=[super init];
    _dataSource=model;
    _models=[[NSMutableArray alloc]init];
    
    //加载材料及调料
  NSArray *t_ings=  [model.ingredients componentsSeparatedByString:@";"];
    for (NSString* item in t_ings) {
        StepModel *a=[[StepModel alloc]init];
        NSArray *info=[item componentsSeparatedByString:@","];
        a.img=[info objectAtIndex:0];
        a.step=[info objectAtIndex:1];
        [_models addObject:a];
    }
    NSArray *t_burs=[model.burden componentsSeparatedByString:@";"];
    for (NSString* item in t_burs) {
        StepModel *a=[[StepModel alloc]init];
        NSArray *info=[item componentsSeparatedByString:@","];
        a.img=[info objectAtIndex:0];
        a.step=[info objectAtIndex:1];
        [_models addObject:a];
    }
    
    //如果步骤为空,表示是从缓存中加载进来的,需要去缓存中取该菜谱的步骤
    if (_dataSource.steps==nil) {
        _dataSource.steps=[Comm getStepsCacheWithCookId:_dataSource.id];
    }
    
    //缓存历史浏览
    [Comm setCacheWithInfoModel:_dataSource];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationController.view setTintColor:[UIColor blackColor]];
    _defaultColor=[UIColor colorWithRed:0 green:153/255.0 blue:51/255.0 alpha:1];
   // _defaultColor=[UIColor alloc]initw
     //defaultImage=[UIImage imageNamed:@"config"];
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier2 bundle:nil] forCellReuseIdentifier:reuseIdentifier2];
    
    //右侧收藏按钮
    _favButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xin"] style:UIBarButtonItemStylePlain target:self action:@selector(addInFavSource)];
    
    _delButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"del"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteFromFavSource)];
    if (![favModels containsObject:_dataSource]) {
    self.navigationItem.rightBarButtonItem=_favButton;
    }
    else{//取消收藏按钮
        self.navigationItem.rightBarButtonItem=_delButton;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)addInFavSource{
   
    NSLog(@"我收藏了%@",_dataSource.title);
    if (![favModels containsObject:_dataSource]) {
        [favModels insertObject:_dataSource atIndex:0];
        [favSource insertObject:[NSKeyedArchiver archivedDataWithRootObject:_dataSource] atIndex:0];//归档
        [[NSUserDefaults standardUserDefaults] setObject:favSource forKey:@"fav"];//更新离线数据
        self.navigationItem.rightBarButtonItem=_delButton;
    }
    
    ALERT_MESSAGE(@"已加入我的收藏");

}

-(void)deleteFromFavSource{
   NSUInteger index= [favModels indexOfObject:_dataSource];
    [favModels removeObjectAtIndex:index];
    [favSource removeObjectAtIndex:index];
    [[NSUserDefaults standardUserDefaults] setObject:favSource forKey:@"fav"];//更新离线数据
    self.navigationItem.rightBarButtonItem=_favButton;
    NSLog(@"删除收藏成功");
    ALERT_MESSAGE(@"已从我的收藏中删除");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {//图片及标题
        return 1;
    }
    else if (section==1){//材料
        if (_models.count%2!=0) {
            return _models.count/2+1;
        }else{
            return _models.count/2;
        }
    }else{//步骤
        return _dataSource.steps.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section==0) {
        StepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
       // StepModel* model=((StepModel*)[_dataSource.steps objectAtIndex:0]);
        [cell.imgView sd_setImageWithURL:[_dataSource.albums objectAtIndex:0] ];
        [cell.textView setText:_dataSource.imtro];
        cell.currFont=[UIFont systemFontOfSize:12];
        [cell initText];
        return cell;
   }
    else if(indexPath.section==1){//材料
        BurTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier2];
        if ((indexPath.row+1)*2<=_models.count) {
            StepModel * m=(StepModel*)[_models objectAtIndex:indexPath.row*2];
            cell.name_1.text=m.img;
            cell.value_1.text=m.step;
            m=(StepModel*)[_models objectAtIndex:indexPath.row*2+1];
            cell.name_2.text=m.img;
            cell.value_2.text=m.step;
        }
        else{
            StepModel * m=(StepModel*)[_models objectAtIndex:indexPath.row*2];
            cell.name_1.text=m.img;
            cell.value_1.text=m.step;
            cell.name_2.text=@"";
            cell.value_2.text=@"";
        }
        return cell;
    }
    else if(indexPath.section==2){
        StepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        StepModel* model=((StepModel*)[_dataSource.steps objectAtIndex:indexPath.row]);
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:defaultImage];
        [cell.textView setText:model.step];
        cell.currFont=[UIFont systemFontOfSize:16];
        [cell initText];
        return cell;
    }
   
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   if(indexPath.section==0||indexPath.section==2){
        CGSize constraint=CGSizeMake(self.tableView.frame.size.width/3*2, 200000.0f);
       CGSize size=[((StepModel*)[_dataSource.steps objectAtIndex:indexPath.row ]).step sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height=MAX(size.height, 90);
       if (indexPath.section==0) {
           height+=10;
       }
      // NSLog(@"======section %ld=======heigth:%f",(long)indexPath.section,height);
        return height;
    }
  
   else
        return 44;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _dataSource.title;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    CGRect frame=CGRectMake(10, 0, tableView.frame.size.width, 30);
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel* text=[[UILabel alloc]initWithFrame:frame];
    [text setTextColor:UIColorFromRGBA(0x666666,1)];
       if (section==0) {//菜名标题
           
           [view setBackgroundColor:UIColorFromRGBA(0x99CC00, 1)];
        [text setText:_dataSource.title];
    }
    else if (section==1) {
         [view setBackgroundColor:UIColorFromRGBA(0x99CC00, 1)];
        [text setText:@"材料准备"];
    }
    else if(section==2){
       [view setBackgroundColor:UIColorFromRGBA(0x99CC00, 1)];
        [text setText:@"开始制作"];

    }
    
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
    maskLayer.frame=view.bounds;
    maskLayer.path=maskPath.CGPath;
    view.layer.mask=maskLayer;
    [view addSubview:text];
    return view;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
