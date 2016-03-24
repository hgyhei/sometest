//
//  UIButton+ClickBlock.h
//  DeliciousMenu
//
//  Created by tarena on 16/3/24.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ButtonClickBlock)(void);
@interface UIButton (ClickBlock)
@property(nonatomic,copy) ButtonClickBlock buttonClickBlock;
@end
