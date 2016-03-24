//
//  MenufirstViewController.m
//  DeliciousMenu
//
//  Created by tarena on 16/3/23.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "MenufirstViewController.h"
#import "InfoCollectionViewController.h"
#import "VarietyDetailTableViewController.h"
#import "TagModel.h"
#import "MenuSingleView.h"
#import "FirstVarietyMenuTableViewCell.h"
#import "UIButton+ClickBlock.h"
@interface MenufirstViewController ()
@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,strong) UITableView *tab;
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

     [self.tableView registerNib:[UINib nibWithNibName:FirstVarietyMenuIdentifier bundle:nil] forCellReuseIdentifier:FirstVarietyMenuIdentifier];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [self setHeaderView];
    [self setfooterView];
}


- (void)setHeaderView{

    TagModel *firstmodel = (TagModel *)self.dataSource[0];
    NSUInteger number = firstmodel.list.count;
    UIScrollView *firstitemScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, self.view.width-20, 100)];
    firstitemScrollView.contentSize = CGSizeMake(100 * number, 0);
    firstitemScrollView.showsHorizontalScrollIndicator = NO;
    CGFloat btnwidth = 60;
    CGFloat margin = 20;
    for (int i = 0; i < number; i++) {
        Tag_ListModel *listmodel = firstmodel.list[i];
        CGFloat x = (margin + i *(margin * 2 + btnwidth));
        MenuSingleView *singleView = [[MenuSingleView alloc]initWithFrame:CGRectMake(x, 10, 60, 100)];
        singleView.descText = listmodel.name;
        singleView.buttonImg = [NSString stringWithFormat:@"1000%d",i+1];
        __weak typeof(self) WeakSelf = self;
        singleView.menuSingleViewButtonClickBlock = ^(void){
            InfoCollectionViewController *vc=[[InfoCollectionViewController alloc]initWithTagId:listmodel.id];
            [vc setTitle:listmodel.name];
            [WeakSelf.navigationController pushViewController:vc animated:YES];
        
        };
        [singleView buildView];
      
        [firstitemScrollView addSubview:singleView];
        
    }
    [self.view addSubview:firstitemScrollView];
    self.tableView.tableHeaderView = firstitemScrollView;

}
- (void)setfooterView{
    UIView *footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    UIButton *footerButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, self.view.width - 20, 30)];
    footerButton.backgroundColor = [UIColor orangeColor];
    [footerview addSubview:footerButton];
    [footerButton addTarget:nil action:@selector(footerClick) forControlEvents:UIControlEventTouchUpInside];
  
    self.tableView.tableFooterView = footerButton;

}
- (void)footerClick{
 [[NSNotificationCenter defaultCenter] postNotificationName:MenuFirstViewControllerNotification object:nil];
}
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
       
         UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            Tag_ListModel *listmodel = firstmodel.list[indexPath.row];
            cell.textLabel.text = listmodel.name;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
     else{
    FirstVarietyMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstVarietyMenuIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUInteger i = 0 + indexPath.row * 3;
    NSUInteger j = 0 + indexPath.row * 3;
    for (id obj in cell.contentView.subviews) {
      Tag_ListModel *listmodel = firstmodel.list[i];
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *label = obj;
            label.text = listmodel.name;
            label.font = [UIFont systemFontOfSize:14];
             i++;
        }
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = obj;
             btn.tag = j;
            __weak typeof (self)WeakSelf = self;
            btn.buttonClickBlock = ^(void){
                InfoCollectionViewController *vc=[[InfoCollectionViewController alloc]initWithTagId:listmodel.id];
                [vc setTitle:listmodel.name];
                [WeakSelf.navigationController pushViewController:vc animated:YES];
            };
            [btn addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
        return cell;
     }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.dataSource.count - 2) {
        TagModel *model = self.dataSource[indexPath.section - 1];
        Tag_ListModel *listmodel = model.list[indexPath.row];
        InfoCollectionViewController * vc=[[InfoCollectionViewController alloc]initWithTagId:listmodel.id];
        vc.title = listmodel.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == self.dataSource.count - 2){
               return 50;
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
    line.backgroundColor =[UIColor blackColor];
    [v1 addSubview:line];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 80, 30)];
    label.font = [UIFont systemFontOfSize:15];
    label.text = model.name;
    
    [label setTextColor:[UIColor orangeColor]];
    [v1 addSubview:label];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width - 50, 10, 50, 30)];
    [btn setTitle:@"更多" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.tag = section + 1;
    [btn addTarget:self action:@selector(sessionHeaderButtonClock:) forControlEvents:UIControlEventTouchUpInside];
    [v1 addSubview:btn];
    
    return v1;
}
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
@end
