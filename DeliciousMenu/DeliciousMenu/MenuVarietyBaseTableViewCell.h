//
//  MenuVarietyBaseTableViewCell.h
//  DeliciousMenu
//
//  Created by tarena on 16/3/23.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MenuVarietyCellButtonClickBlock)(void);
@interface MenuVarietyBaseTableViewCell : UITableViewCell
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UIButton *titleRightButton;
@property (nonatomic,copy) MenuVarietyCellButtonClickBlock menuVarietyCellButtonClickBlock ;
@end
