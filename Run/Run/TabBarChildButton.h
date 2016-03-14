//
//  TabBarChildButton.h
//  Run
//
//  Created by tarena on 16/3/14.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TabBarChildButtonClickBlock) (void);
@interface TabBarChildButton : UIButton
@property(nonatomic,copy) TabBarChildButtonClickBlock tabbarchildbuttonclickblock;
@end
