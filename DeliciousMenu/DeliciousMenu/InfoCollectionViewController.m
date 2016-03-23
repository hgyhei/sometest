//
//  InfoCollectionViewController.m
//  DeliciousMenu
//
//  Created by tarena on 16/3/22.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "InfoCollectionViewController.h"
#import "InfoCollectionViewCell.h"
#import "DetailTableViewController.h"
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import "infoModel.h"
#import "UIImageView+WebCache.h"
@interface InfoCollectionViewController ()<UISearchBarDelegate>
@property BOOL isSearch;
@property NSString* tagId;
@property NSString * searchText;
@property NSMutableArray *dataSource;
@end

@implementation InfoCollectionViewController
static int pn=0;

-(id)initWithTagId:(NSString* )tagId{
    self= [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
    _tagId = tagId;
    _isSearch = false;
    return self;
}

-(id)initWithSearchText:(NSString *) searchText{
    self=[super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
    _searchText = searchText;
    _isSearch = true;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView registerNib:[UINib nibWithNibName:InfoCollectionreuseIdentifier bundle:nil] forCellWithReuseIdentifier:InfoCollectionreuseIdentifier];
    [self setupRefresh];

}
- (void)setupNav{

    if (_isSearch) {
        //导航栏用搜索框
        
        CGRect  frame = self.navigationController.navigationBar.frame;
        frame.origin.y = 0;
        UIView *titleView = [[UIView alloc]initWithFrame:frame];
        [titleView setBackgroundColor:[UIColor clearColor]];
        frame.size.width -= 80;
        
        UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:frame];
        searchBar.backgroundColor = [UIColor clearColor];
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
        searchBar.delegate = self;
        searchBar.layer.cornerRadius = 2;
     
        [titleView addSubview:searchBar];
        self.navigationItem.titleView = titleView;
        }
}
-(void)setupRefresh{
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pn = 0;
        if (!_isSearch) {
            [self getDataByTagId];
        }
        else{
            [self getDataBySearchText];
        }
        [self.collectionView.mj_header endRefreshing];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pn += 10;
        if(!_isSearch){
            [self getDataByTagId];
        }else{
            [self getDataBySearchText];
        }
        // 结束刷新
        [self.collectionView.mj_footer endRefreshing];
        
    }];

}
- (void)getDataByTagId{
     NSString *url=[NSString stringWithFormat:@"%@?cid=%@&pn=%d&rn=%d",API_queryByTag,_tagId,pn,10];
    if (![fmdbMethod urlContains:url]) {
        JHAPISDK *juheapi = [JHAPISDK shareJHAPISDK];
        NSDictionary *parms = @{
                                @"cid":_tagId,
                                @"pn":[NSString stringWithFormat:@"%d",pn],
                                @"rn":@"10"
                                };
        [juheapi executeWorkWithAPI:API_queryByTag APIID:APPID Parameters:parms Method:Method_Get Success:^(id responseObject) {
            int error_code = [[responseObject objectForKey:@"error_code"] intValue];
            if (!error_code) {
                if (pn == 0) {
                    _dataSource = [infoModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"result"] objectForKey:@"data"]];
                    [fmdbMethod setCacheWithUrl:url :_dataSource];
                }
                else{
                    NSArray *array = [infoModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"result"] objectForKey:@"data"]];
                    [fmdbMethod setCacheWithUrl:url :array];
                    [_dataSource addObjectsFromArray:array];
                
                }
                [self.collectionView reloadData];
            }
           
        } Failure:^(NSError *error) {
            NSLog(@"error: %@",error.description);
        }];
    }
    else{
        if (pn == 0) {
            _dataSource = [NSMutableArray arrayWithArray:[fmdbMethod getCacheWithUrl:url]];
            NSLog(@"从缓存中取出");
        }
        else{
            [_dataSource addObjectsFromArray:[fmdbMethod getCacheWithUrl:url]];
              NSLog(@"从缓存中取出");
        }
        [self.collectionView reloadData];
    }
   }
- (void)getDataBySearchText{
    JHAPISDK *juheapi = [JHAPISDK shareJHAPISDK];
    NSDictionary *parms=@{
                          @"menu":_searchText,
                          @"pn": [NSString stringWithFormat:@"%d",pn],
                          @"rn":@"10"
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
                                    _dataSource=[infoModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"result"] objectForKey:@"data"]];
                                    
                                }else{
                                    NSArray* arry=[infoModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"result"] objectForKey:@"data"]];
                                    
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100,100);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InfoCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:InfoCollectionreuseIdentifier forIndexPath:indexPath];
    infoModel *model = [_dataSource objectAtIndex:indexPath.row];
    // Configure the cell
  
    [cell.infoimg sd_setImageWithURL:[NSURL URLWithString:[model.albums objectAtIndex:0]] placeholderImage:nil];
    
    
    cell.infotext.text = model.title;
    cell.infotext.font = [UIFont systemFontOfSize:15];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    cell.layer.transform=CATransform3DMakeScale(0.8, 0.8, 1);
//    [UIView animateWithDuration:1.25 animations:^{
//        cell.layer.transform=CATransform3DMakeScale(1, 1, 1);
//    }];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    DetailTableViewController * vc=[[DetailTableViewController alloc]initWithInfoModel:(infoModel *)[_dataSource objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
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
@end
