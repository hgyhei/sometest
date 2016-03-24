//
//  ViewController.m
//  DeliciousMenu
//
//  Created by tarena on 16/3/21.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "ViewController.h"
#import "TagModel.h"
#import "InfoCollectionViewController.h"
#import "MenuLeftTableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * leftTableView;
@property (nonatomic,strong) UITableView * rightTableView;
@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,assign) NSInteger leftIndex;
@end

@implementation ViewController
- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc]init];
        NSString * path=[[NSBundle mainBundle] pathForResource:@"TagList" ofType:@"plist"];
      
        _dataSource = [TagModel mj_objectArrayWithFile:path];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setLeftTable];
    [self setRightTable];
}
- (void)setLeftTable{
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, self.view.height -TabbarHeight)];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    [_leftTableView setTag:101];
     [_leftTableView registerNib:[UINib nibWithNibName:MenuLeftReuseIdentifier bundle:nil] forCellReuseIdentifier:MenuLeftReuseIdentifier];
  
    [self.view addSubview:_leftTableView];
}
- (void)setRightTable{
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(80, StatusBarAndNavigationBarHeight, self.view.width - 80, self.view.height -StatusBarAndNavigationBarHeight - TabbarHeight)];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
//      _rightTableView.backgroundColor = [UIColor redColor];
    [_rightTableView setTag:102];
    [self.view addSubview:_rightTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==101) {
     
        return self.dataSource.count;

     
    }
    else{
        return ((TagModel*)[self.dataSource objectAtIndex:_leftIndex]).list.count;
     
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==101) {
        return 80;
    }else
        return 40;


}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (tableView.tag==101) {
        MenuLeftTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:MenuLeftReuseIdentifier forIndexPath:indexPath];
        TagModel *model=(TagModel*)[self.dataSource objectAtIndex:indexPath.row];
        cell.text.text=model.name;
        cell.text.font = [UIFont systemFontOfSize:15];
  
        cell.img.image=[UIImage imageNamed:model.parentId];
        return cell;
       
    
    }
    else{
        UITableViewCell *cell=[[UITableViewCell alloc]init];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        TagModel *model = [self.dataSource objectAtIndex:_leftIndex];
        Tag_ListModel *list = model.list[indexPath.row ];
    
        cell.textLabel.text = list.name;
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中左侧个性右侧
    if (tableView.tag==101) {
        _leftIndex=indexPath.row;
        [_rightTableView reloadData];
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    else if (tableView.tag==102){
               Tag_ListModel *molde=(Tag_ListModel*)((TagModel*)[self.dataSource objectAtIndex:_leftIndex]).list[indexPath.row];
         InfoCollectionViewController *vc=[[InfoCollectionViewController alloc]initWithTagId:molde.id];
        [vc setTitle:molde.name];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
