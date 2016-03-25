//
//  MenuHomeViewController.m
//  DeliciousMenu
//
//  Created by tarena on 16/3/25.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "MenuHomeViewController.h"
#import "SearchViewController.h"
#import "MarkViewController.h"
#import "PingTransition.h"
@implementation MenuHomeViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupNarItem];
    
}
- (void)setupNarItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-07xiangyou"] style:UIBarButtonItemStyleDone target:self action:@selector(search)];
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-07xiangyou"] style:UIBarButtonItemStylePlain target:self action:@selector(mark)];
}
- (void)search{
        SearchViewController *search = [[SearchViewController alloc]init];
        [self.navigationController pushViewController:search animated:YES];
    NSLog(@"search");
}
- (void)mark{
    MarkViewController *mark = [[MarkViewController alloc]init];
    [self.navigationController pushViewController:mark animated:YES];
    
}
#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        
        PingTransition *ping = [PingTransition new];
        return ping;
    }else{
        return nil;
    }
}
@end
