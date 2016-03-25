//
//  SearchViewController.m
//  DeliciousMenu
//
//  Created by tarena on 16/3/22.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "SearchViewController.h"
#import "InfoCollectionViewController.h"
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *histroyTableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearch];
    [self setupHistoryTableView];
    [self setupClearButton];
}

- (void)setupSearch{
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

}
- (void)setupHistoryTableView{
    _histroyTableView=[[UITableView alloc]initWithFrame:self.view.bounds];
    _histroyTableView.delegate=self;
    _histroyTableView.dataSource=self;
    [self.view addSubview:_histroyTableView];
    [self getData];
}
- (void)getData{
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"search"];
   SearchArray = [NSMutableArray arrayWithArray:array];
    [_histroyTableView reloadData];
   
}
- (void)setupClearButton{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    UIButton *btn_clear=[[UIButton alloc]initWithFrame:CGRectMake(50, 10, self.view.width -100, 40)];
    [btn_clear setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [btn_clear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_clear.backgroundColor = [UIColor orangeColor];
    [btn_clear addTarget:self action:@selector(clearHistory:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn_clear];
    _histroyTableView.tableFooterView = footerView;
}
-(void)clearHistory:(UIButton *)button{
    NSLog(@"清除按钮被点击");
    SearchArray =[NSMutableArray array];
    [[NSUserDefaults standardUserDefaults] setObject:SearchArray forKey:@"search"];
    [_histroyTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([SearchArray containsObject:searchBar.text]) {
        NSUInteger index=[SearchArray indexOfObject:searchBar.text];
        [SearchArray removeObjectAtIndex:index];
    }
    
    [SearchArray insertObject:searchBar.text atIndex:0];
    [_histroyTableView reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:SearchArray forKey:@"search"];
    InfoCollectionViewController *vc=[[InfoCollectionViewController alloc]initWithSearchText:searchBar.text];
    [vc setTitle:searchBar.text];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (editingStyle==UITableViewCellEditingStyleDelete) {
     
        [SearchArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[NSUserDefaults standardUserDefaults] setObject:SearchArray forKey:@"search"];
    }
}
//点击历史记录直接搜索
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _searchBar.text=[SearchArray objectAtIndex:indexPath.row];
    [self searchBarSearchButtonClicked:_searchBar];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return SearchArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[[UITableViewCell alloc]init];
    cell.textLabel.text=[SearchArray objectAtIndex:indexPath.row];
    return cell;
}
@end
