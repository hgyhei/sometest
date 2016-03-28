//
//  MenuConst.m
//  DeliciousMenu
//
//  Created by hgy on 16/3/22.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "MenuConst.h"

@implementation MenuConst

NSString * const OpenID=@"JHdb05e45abe21dab35da0661d7bb1397d";
NSString * const APPID=@"46";
NSString * const Method_Get=@"GET";
NSString * const Method_Post=@"POST";

NSMutableArray * SearchArray;
NSMutableArray * favSource;
NSMutableArray * favModels;
UIImage * defaultImage ;
FMDatabase * db;
//API
//菜谱大全
NSString *const API_query=@"http://apis.juhe.cn/cook/query.php";
//查看菜谱的所有分类，如菜系、口味等
NSString *const API_category=@"http://apis.juhe.cn/cook/category";
//按标签检索菜谱
NSString *const API_queryByTag=@"http://apis.juhe.cn/cook/index";
//按菜谱ID查看详细
NSString *const API_queryByID=@"http://apis.juhe.cn/cook/queryid";

CGFloat  const  MarkCollectionItemWidth = 250;
CGFloat  const  DetailTableViewHeaderViewHeight = 250;


NSString *const MenuFirstViewControllerNotification=@"MenuFirstViewControllerNotification";
NSString *const MenuLeftReuseIdentifier = @"MenuLeftTableViewCell";
NSString *const InfoCollectionreuseIdentifier = @"InfoCollectionViewCell";
NSString *const StepViewreuseIdentifier = @"StepTableViewCell";
NSString *const BurViewreuseIdentifier = @"BurTableViewCell";
NSString *const FirstVarietyMenuIdentifier = @"FirstVarietyMenuTableViewCell";
NSString *const SecondVarietyMenuIdentifier = @"SecondVarityTableViewCell";
NSString *const VarietyDetailCollectionViewIdentifier =  @"VarietyDetailCollectionViewCell";
NSString *const MarkCollectionViewIdentifier =  @"MarkCollectionViewCell";

@end
