//
//  MenufirstViewController.m
//  DeliciousMenu
//
//  Created by hgy on 16/3/23.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "MenufirstViewController.h"
#import "InfoCollectionViewController.h"
#import "VarietyDetailTableViewController.h"
#import "MarkViewController.h"
#import "SearchViewController.h"
#import "TagModel.h"
#import "infoModel.h"
#import "MenuSingleView.h"
#import "MenuLoopView.h"
#import "FirstVarietyMenuTableViewCell.h"
#import "UIButton+ClickBlock.h"
#import "UIImageView+WebCache.h"
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"

@interface MenufirstViewController ()<MenuLoopViewDelegate>
@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,strong) UITableView *tab;
@property (nonatomic,strong) NSMutableArray *infoImgArray;

@end

@implementation MenufirstViewController

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc]init];
        NSString * path=[[NSBundle mainBundle] pathForResource:@"FirstMenu" ofType:@"plist"];
        
        _dataSource = [TagModel mj_objectArrayWithFile:path];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setTableView];
}
#pragma -mark 配置
- (void)setTableView{
    [self.tableView registerNib:[UINib nibWithNibName:FirstVarietyMenuIdentifier bundle:nil] forCellReuseIdentifier:FirstVarietyMenuIdentifier];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [self setHeaderView];
    [self setfooterView];
}

- (void)setHeaderView{
    
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 250)];
    NSArray *images = @[@"19b6d1d5524f58e6d29b60c1e2cf4fa5",@"19b6d1d5524f58e6d29b60c1e2cf4fa5",@"19b6d1d5524f58e6d29b60c1e2cf4fa5"];
    MenuLoopView *loopView = [[MenuLoopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150) images:images autoPlay:YES delay:3.0];
    loopView.delegate = self;
    [headerView addSubview:loopView];
    
    

    TagModel *firstmodel = (TagModel *)self.dataSource[0];
    NSUInteger number = firstmodel.list.count;
    UIScrollView *firstitemScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 150, self.view.width, 100)];
    firstitemScrollView.contentSize = CGSizeMake(100 * number, 0);
    firstitemScrollView.showsHorizontalScrollIndicator = NO;
   
    CGFloat margin = 20;
     CGFloat btnwidth = (self.view.width - 8 * margin) / 4;
    for (int i = 0; i < number; i++) {
        Tag_ListModel *listmodel = firstmodel.list[i];
        CGFloat x = (margin + i *(margin * 2 + btnwidth));
        MenuSingleView *singleView = [[MenuSingleView alloc]initWithFrame:CGRectMake(x, 10, btnwidth, 90)];
        singleView.descText = listmodel.name;
        singleView.buttonImg = @"place";
        __weak typeof(self) WeakSelf = self;
        singleView.menuSingleViewButtonClickBlock = ^(void){
            InfoCollectionViewController *vc=[[InfoCollectionViewController alloc]initWithTagId:listmodel.id];
            [vc setTitle:listmodel.name];
            [WeakSelf.navigationController pushViewController:vc animated:YES];
        
        };
        [singleView buildView];
      
        [firstitemScrollView addSubview:singleView];
        
    }
    [headerView addSubview:firstitemScrollView];
   
    self.tableView.tableHeaderView = headerView;

}
- (void)setfooterView{
    UIView *footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    line.backgroundColor = BackGroundLineColor;
    [footerview addSubview:line];
    
    UIButton *footerButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, self.view.width - 40, 40)];
    footerButton.layer.cornerRadius = 5.0f;
    footerButton.layer.masksToBounds = YES;
    footerButton.backgroundColor = [UIColor orangeColor];
    [footerButton setTitle:@"查看更多分类" forState:UIControlStateNormal];
    [footerButton setTintColor:[UIColor whiteColor]];
    [footerButton addTarget:nil action:@selector(footerClick) forControlEvents:UIControlEventTouchUpInside];
    [footerview addSubview:footerButton];
   
  
    self.tableView.tableFooterView = footerview;

}
#pragma -mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataSource.count-1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == self.dataSource.count - 2) {
        return 2;
    }
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     TagModel *firstmodel = (TagModel *)self.dataSource[indexPath.section + 1];
  
     if (indexPath.section == self.dataSource.count - 2) {
       
         UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            Tag_ListModel *listmodel = firstmodel.list[indexPath.row];
            cell.textLabel.text = listmodel.name;
         cell.imageView.image = defaultImage;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
     else{
    FirstVarietyMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstVarietyMenuIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUInteger i = 0 + indexPath.row * 3;
    NSUInteger j = 0 + indexPath.row * 3;
    for (id obj in cell.contentView.subviews) {
     
        if ([obj isKindOfClass:[UILabel class]]) {
             Tag_ListModel *listmodel = firstmodel.list[i];
            UILabel *label = obj;
            label.text = listmodel.name;
            label.font = [UIFont systemFontOfSize:14];
             i++;
        }
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = obj;
            Tag_ListModel *listmodel = firstmodel.list[j];
            [btn setImage:defaultImage forState:UIControlStateNormal];
            __weak typeof (self)WeakSelf = self;
            btn.buttonClickBlock = ^(void){
                InfoCollectionViewController *vc=[[InfoCollectionViewController alloc]initWithTagId:listmodel.id];
                [vc setTitle:listmodel.name];
                [WeakSelf.navigationController pushViewController:vc animated:YES];
            };
            [btn addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            j++;
        }
    }
        return cell;
     }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.dataSource.count - 2) {
        TagModel *model = self.dataSource[self.dataSource.count - 1];
        Tag_ListModel *listmodel = model.list[indexPath.row];
        InfoCollectionViewController * vc=[[InfoCollectionViewController alloc]initWithTagId:listmodel.id];
        vc.title = listmodel.name;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == self.dataSource.count - 2){
               return 70;
    }
    
    else
        return 140;
}
//headerview
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TagModel *model = self.dataSource[section + 1];
   
    UIView *v1 = [[UIView alloc]init];
    v1.backgroundColor = [UIColor whiteColor];

    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    line.backgroundColor = BackGroundLineColor;
    [v1 addSubview:line];
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 10, 10)];
    arrow.image = [UIImage imageNamed:@"iconfont-jiantou2"];
    [v1 addSubview:arrow];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 80, 30)];
    label.font = [UIFont systemFontOfSize:15];
    label.text = model.name;
    [label setTextColor:[UIColor blackColor]];
    [v1 addSubview:label];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width - 60, 10, 50, 30)];
    [btn setTitle:@"更多" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.tag = section + 1;
    [btn addTarget:self action:@selector(sessionHeaderButtonClock:) forControlEvents:UIControlEventTouchUpInside];
    [v1 addSubview:btn];
    
    UIImageView *more = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - 20, 20, 10, 10)];
    more.image = [UIImage imageNamed:@"iconfont-07xiangyou"];
    [v1 addSubview:more];
    
    return v1;
}

#pragma -mark 点击事件
- (void)cellButtonClick:(UIButton *)cellBtn{
    if (cellBtn.buttonClickBlock) {
        cellBtn.buttonClickBlock();
    }
}
- (void)sessionHeaderButtonClock:(UIButton *)btn{
    NSInteger index = btn.tag;
    TagModel *listModel = self.dataSource[index];
    VarietyDetailTableViewController *vc = [[VarietyDetailTableViewController alloc]initWithModel:listModel];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)footerClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:MenuFirstViewControllerNotification object:nil];
}

@end
