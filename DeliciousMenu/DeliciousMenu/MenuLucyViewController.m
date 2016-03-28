//
//  MenuLucyViewController.m
//  DeliciousMenu
//
//  Created by tarena on 16/3/28.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "MenuLucyViewController.h"

@interface MenuLucyViewController ()
@end
@implementation MenuLucyViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    UIView *v1 = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    v1.backgroundColor = [UIColor redColor];
    [self.view addSubview:v1];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [v1.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}

@end
