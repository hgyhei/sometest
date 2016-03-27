//
//  MarkViewController.m
//  DeliciousMenu
//
//  Created by tarena on 16/3/22.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "MarkViewController.h"
#import <UIImageView+WebCache.h>
#import "PingInvertTransition.h"
#import "infoModel.h"
#import "MenuHomeViewController.h"
#import "DetailTableViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MarkCollectionLineLayout.h"
#import "MarkCollectionViewCell.h"
@interface MarkViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong,nonatomic) UICollectionView *collectionView;
@end
static NSString *const ID = @"image";
@implementation MarkViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_collectionView reloadData];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.delegate = self;
   self.title = @"收藏";
     [self setCollection];

}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        if ([toVC isKindOfClass:[MenuHomeViewController class]]) {
            PingInvertTransition *ping = [PingInvertTransition new];
            return ping;
        }
        else{
            
            return nil;
        }
        
        
        
    }
    else{
        return nil;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
      self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"iconfont-fanhui"highImage:@"iconfont-fanhui"];
   self.automaticallyAdjustsScrollViewInsets = YES;
  
   
     
}
- (void)setCollection{

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 66, self.view.width, self.view.height * 0.7) collectionViewLayout:[[MarkCollectionLineLayout alloc] init]];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:MarkCollectionViewIdentifier bundle:nil] forCellWithReuseIdentifier:MarkCollectionViewIdentifier];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height * 0.8 , self.view.width, self.view.height * 0.2)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:footerView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return favModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     MarkCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MarkCollectionViewIdentifier forIndexPath:indexPath];
   
    
    infoModel * model=(infoModel*)[favModels objectAtIndex:indexPath.row];
    [ cell.markImg sd_setImageWithURL:[NSURL URLWithString:[model.albums objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"tran"]];
//
//    cell.textLabel.text=model.title;
//    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    DetailTableViewController *vc=[[DetailTableViewController alloc]initWithInfoModel:(infoModel *)[favModels objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];

}






@end
