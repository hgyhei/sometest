//
//  RunTabBarViewController.m
//  Run
//
//  Created by tarena on 16/3/14.
//  Copyright © 2016年 hgy. All rights reserved.
//

#define delta 120
#import "RunTabBarViewController.h"
#import "HWTabBar.h"
#import "UIView+Extension.h"

#import "TabBarChildButton.h"

@interface RunTabBarViewController ()
@property (nonatomic,strong) UIButton *mainButton;
@property(nonatomic,strong)NSMutableArray *items;
@end

@implementation RunTabBarViewController
-(NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    
    return _items;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    HWTabBar *tabBar = [[HWTabBar alloc] init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    [self setupCenterButton];
    
   
   
    
 
  }
- (void)setupCenterButton
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width * 0.5 - 22, self.view.height - 44, 44, 44)];;
    
    btn.layer.cornerRadius = 22;
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_delet"] forState:UIControlStateNormal];
    _mainButton = btn;
    
    [self.view addSubview:_mainButton];
    [_mainButton addTarget:self action:@selector(circleBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addChildButtonWithBackgroundImage:@"信息 40px" tag:0 block:^{
        NSLog(@"aaaa");
    }];
    [self addChildButtonWithBackgroundImage:@"信息 40px" tag:1 block:^{
        NSLog(@"bbbb");
    }];
    [self addChildButtonWithBackgroundImage:@"信息 40px" tag:2 block:^{
        NSLog(@"cccc");
    }];
    [self addChildButtonWithBackgroundImage:@"信息 40px" tag:3 block:^{
        NSLog(@"ddda");
    }];
    [self addChildButtonWithBackgroundImage:@"信息 40px" tag:4 block:^{
        NSLog(@"eeee");
    }];
}
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
   
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}

- (void)circleBtn
{
    

    BOOL show = CGAffineTransformIsIdentity(self.mainButton.transform);
    [UIView animateWithDuration:0.1f animations:^{
        if (show) {//代表transform未被改变
           
            
            self.mainButton.transform =CGAffineTransformMakeRotation(M_PI_2);
        }else{//恢复
            self.mainButton.transform =CGAffineTransformIdentity;
        }
        
    }];
    
    // 显示 items
    [self showItems:show];
    
}
- (void)showItems:(BOOL)show{
    
    for (TabBarChildButton *btn in self.items) {
       
        if (show) {
            
            CGFloat sinangle =  fabs(sin((btn.tag + 1) * 30 * M_PI / 180)) ;
            CGFloat cosangle =  cos((btn.tag + 1) * 30 * M_PI / 180);
            //重新设置每个按钮的x值
            CGFloat btnCenterX = self.mainButton.centerX - delta * cosangle;
            CGFloat btnCenterY = self.mainButton.centerY - delta * sinangle;
            // 最终显示的位置
            CGPoint showPosition = CGPointMake(btnCenterX, btnCenterY);
         [UIView animateWithDuration:0.5f animations:^{
              btn.center = showPosition;
         }];
        }
            else{
                     [UIView animateWithDuration:0.5f animations:^{
                         CABasicAnimation* rotationAnimation;
                         rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                         rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
                         rotationAnimation.duration = 0.05f;
                         rotationAnimation.cumulative = YES;
                         rotationAnimation.repeatCount = 5;
                         [btn.layer addAnimation:rotationAnimation forKey:nil];
            
//            [UIView animateWithDuration:0.5f delay:0.5f options:nil animations:^{
//                 btn.center = _mainButton.center;
//            } completion:nil];
//
//                         
                     } completion:^(BOOL finished) {
                       [UIView animateWithDuration:0.5 animations:^{
                           btn.center = _mainButton.center;
                       }];
                     }];
        }
     
       
    }
    
    
    
}


- (void)addChildButtonWithBackgroundImage:(NSString *)img tag:(NSUInteger)tag block:(TabBarChildButtonClickBlock)tabbarchildbuttonclickblock
{
    TabBarChildButton *btn = [[TabBarChildButton alloc]init];
    [btn setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    btn.tag = tag;
    btn.frame = self.mainButton.frame ;
    btn.tabbarchildbuttonclickblock = tabbarchildbuttonclickblock;
    [self.items addObject:btn];
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:_mainButton];
    [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)btnclick:(TabBarChildButton *)btn
{
    if (btn.tabbarchildbuttonclickblock) {
        btn.tabbarchildbuttonclickblock();
    }
}







@end
