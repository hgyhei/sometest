//
//  MenuSingleView.h
//  DeliciousMenu
//
//  Created by tarena on 16/3/23.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MenuSingleViewButtonClickBlock)(void);
@interface MenuSingleView : UIView
@property (nonatomic,copy) NSString *buttonImg;
@property (nonatomic,copy) NSString *descText;
@property (nonatomic,copy) MenuSingleViewButtonClickBlock menuSingleViewButtonClickBlock;
- (void)buildView;
@end
