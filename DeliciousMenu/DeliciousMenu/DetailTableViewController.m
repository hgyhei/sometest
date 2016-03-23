//
//  DetailTableViewController.m
//  DeliciousMenu
//
//  Created by tarena on 16/3/22.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "DetailTableViewController.h"
#import "infoModel.h"
#import <UIImageView+WebCache.h>
#import "StepTableViewCell.h"
#import "BurTableViewCell.h"
#import "MenuConst.h"
@interface DetailTableViewController ()
@property (nonatomic,strong) infoModel *dataSource;
@property (nonatomic,strong) NSMutableArray *materialModel;
@property (strong,nonatomic) UIBarButtonItem *delButton;
@property (strong,nonatomic)UIBarButtonItem *favButton;
@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:StepViewreuseIdentifier bundle:nil] forCellReuseIdentifier:StepViewreuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:BurViewreuseIdentifier bundle:nil] forCellReuseIdentifier:BurViewreuseIdentifier];
    _favButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xin"] style:UIBarButtonItemStylePlain target:self action:@selector(addInFavSource)];
    
    _delButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"del"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteFromFavSource)];
    if (![favModels containsObject:_dataSource]) {
        self.navigationItem.rightBarButtonItem=_favButton;
    }
    else{//取消收藏按钮
        self.navigationItem.rightBarButtonItem=_delButton;
    }

}
-(void)addInFavSource{
    
    NSLog(@"我收藏了%@",_dataSource.title);
  
        [favModels insertObject:_dataSource atIndex:0];
        [favSource insertObject:[NSKeyedArchiver archivedDataWithRootObject:_dataSource] atIndex:0];//归档
        [[NSUserDefaults standardUserDefaults] setObject:favSource forKey:@"fav"];//更新离线数据
        NSLog(@"%@",favSource);
        self.navigationItem.rightBarButtonItem=_delButton;
    
    
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

- (id)initWithInfoModel:(infoModel *)model
{
    self = [super init];
    _dataSource = model;
    _materialModel = [[NSMutableArray alloc]init];
    NSArray *t_ings=  [model.ingredients componentsSeparatedByString:@";"];
    for (NSString* item in t_ings) {
        StepModel *a=[[StepModel alloc]init];
        NSArray *info=[item componentsSeparatedByString:@","];
        a.img=[info objectAtIndex:0];
        a.step=[info objectAtIndex:1];
        [_materialModel addObject:a];
    }
    NSArray *t_burs=[model.burden componentsSeparatedByString:@";"];
    for (NSString* item in t_burs) {
        StepModel *a=[[StepModel alloc]init];
        NSArray *info=[item componentsSeparatedByString:@","];
        a.img=[info objectAtIndex:0];
        a.step=[info objectAtIndex:1];
        [_materialModel addObject:a];
    }
    if (_dataSource.steps==nil) {
        _dataSource.steps=[fmdbMethod getStepsCacheWithCookId:_dataSource.id];
        NSLog(@"从缓存中取出步骤");
    }
    
    //缓存历史浏览
    [fmdbMethod setCacheWithInfoModel:_dataSource];
    
    
        return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {//图片及标题
        return 1;
    }
    else if (section==1){//材料
        if (_materialModel.count%2!=0) {
            return _materialModel.count/2+1;
        }else{
            return _materialModel.count/2;
        }
    }else{//步骤
        return _dataSource.steps.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0||indexPath.section==2){
        CGSize constraint=CGSizeMake(self.tableView.frame.size.width/3*2, 200000.0f);
        CGSize size=[((StepModel*)[_dataSource.steps objectAtIndex:indexPath.row ]).step sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height=MAX(size.height, 90);
        if (indexPath.section==0) {
            height+=10;
        }
        
        return height;
        return 90;
    }
    
    else
        return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        StepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StepViewreuseIdentifier forIndexPath:indexPath];
        // StepModel* model=((StepModel*)[_dataSource.steps objectAtIndex:0]);
        [cell.imgView sd_setImageWithURL:[_dataSource.albums objectAtIndex:0] ];
        [cell.textView setText:_dataSource.imtro];
        cell.currFont=[UIFont systemFontOfSize:12];
        [cell initText];
        return cell;
    }
    else if(indexPath.section==1){//材料
        BurTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:BurViewreuseIdentifier];
        if ((indexPath.row+1)*2<=_materialModel.count) {
            StepModel * m=(StepModel*)[_materialModel objectAtIndex:indexPath.row*2];
            cell.name_1.text=m.img;
            cell.value_1.text=m.step;
            m=(StepModel*)[_materialModel objectAtIndex:indexPath.row*2+1];
            cell.name_2.text=m.img;
            cell.value_2.text=m.step;
        }
        else{
            StepModel * m=(StepModel*)[_materialModel objectAtIndex:indexPath.row*2];
            cell.name_1.text=m.img;
            cell.value_1.text=m.step;
            cell.name_2.text=@"";
            cell.value_2.text=@"";
        }
        return cell;
    }
    else if(indexPath.section==2){
        StepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StepViewreuseIdentifier forIndexPath:indexPath];
        StepModel* model=((StepModel*)[_dataSource.steps objectAtIndex:indexPath.row]);
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:defaultImage];
        [cell.textView setText:model.step];
        cell.currFont=[UIFont systemFontOfSize:16];
        [cell initText];
        return cell;
    }
    
    return nil;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _dataSource.title;
}
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGRect frame=CGRectMake(10, 0, tableView.frame.size.width, 30);
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel* text=[[UILabel alloc]initWithFrame:frame];
    [text setTextColor:[UIColor blueColor]];
    if (section==0) {//菜名标题
        
        [view setBackgroundColor:[UIColor orangeColor]];
        [text setText:_dataSource.title];
    }
    else if (section==1) {
        [view setBackgroundColor:[UIColor orangeColor]];
        [text setText:@"材料准备"];
    }
    else if(section==2){
        [view setBackgroundColor:[UIColor orangeColor]];
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



@end
