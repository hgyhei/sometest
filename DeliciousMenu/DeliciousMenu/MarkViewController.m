//
//  MarkViewController.m
//  DeliciousMenu
//
//  Created by tarena on 16/3/22.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "MarkViewController.h"
#import <UIImageView+WebCache.h>
#import "infoModel.h"
#import "DetailTableViewController.h"
@interface MarkViewController ()
@property (strong,nonatomic) UITableView * tableView;
@end

@implementation MarkViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailTableViewController *vc=[[DetailTableViewController alloc]initWithInfoModel:(infoModel *)[favModels objectAtIndex:indexPath.row]];
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
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    infoModel * model=(infoModel*)[favModels objectAtIndex:indexPath.row];
    [ cell.imageView sd_setImageWithURL:[NSURL URLWithString:[model.albums objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"tran"]];
  
    cell.textLabel.text=model.title;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

@end
