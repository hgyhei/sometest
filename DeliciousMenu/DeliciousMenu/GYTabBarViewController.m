//
//  GYTabBarViewController.m
//  tabbar
//
//  Created by hgy on 16/2/18.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "GYTabBarViewController.h"
#import "GYNavigationController.h"
#import "MarkViewController.h"
#import "CalendarViewController.h"
#import "UIButton+Extension.h"
#import "ViewController.h"
#import "SearchViewController.h"
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
@interface GYTabBarViewController ()

@end
@implementation GYTabBarViewController
-(void)initConst{
    defaultImage=[UIImage imageNamed:@"tran"];
    //收藏数据
    favSource=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"fav"]];
    favModels=[NSMutableArray array];
    if (favSource) {
        for (NSData * item in favSource) {
            [favModels addObject:[NSKeyedUnarchiver unarchiveObjectWithData:item]];
        }
    }else{
        favSource=[NSMutableArray array];
        
    }
}
-(void)initDB{
    // 首先获取iPhone上Sqlite3的数据库文件的地址
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Cache"];
//    NSLog(@"%@",path);
    /*
     1、当数据库文件不存在时，fmdb会自己创建一个。
     2、 如果你传入的参数是空串：@"" ，则fmdb会在临时文件目录下创建这个数据库，数据库断开连接时，数据库文件被删除。
     3、如果你传入的参数是 NULL，则它会建立一个在内存中的数据库，数据库断开连接时，数据库文件被删除。
     */
    
    db=[FMDatabase databaseWithPath:path];
    [db open];
    //如果表不存在,创建
    if(![self isTableOK:@"T_Url"]){
        NSLog(@"表不存在");
        
        //创建URL表
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS 'T_Url' ('id' INTEGER PRIMARY KEY AUTOINCREMENT, 'url' TEXT)";
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
            return;
        } else {
            NSLog(@"success to creating db table <T_Url>");
        }
        
        sqlCreateTable=@"CREATE TABLE IF NOT EXISTS 'T_Cook' ('id' TEXT PRIMARY KEY, 'uid' INTEGER ,'title' TEXT,'tags' TEXT,'imtro' TEXT,'ingredients' TEXT, 'burden' TEXT,'albums' TEXT, 'steps' INTEGER)";
        res=[db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
            return;
        } else {
            NSLog(@"success to creating db table <T_Cook>");
        }
        
        sqlCreateTable=@"CREATE TABLE IF NOT EXISTS 'T_Step' ( 'id' INTEGER PRIMARY KEY AUTOINCREMENT,'img' TEXT,'step' TEXT, 'xh' INTEGER,'cookId' TEXT)";
        res=[db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
            return;
        } else {
            NSLog(@"success to creating db table <T_Step>");
        }
        
        
    }
    
    //历史记录表
    if(![self isTableOK:@"T_History"]){
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS 'T_History' ('id' INTEGER PRIMARY KEY AUTOINCREMENT, 'cookId' TEXT)";
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
            return;
        } else {
            NSLog(@"success to creating db table <T_History>");
        }
    }
    [db close];
}

// 判断是否存在表
- (BOOL) isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
 
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
 
    [self initConst];
    [self initDB];
    
    
    [[JHOpenidSupplier shareSupplier] registerJuheAPIByOpenId:OpenID];

    self.view.backgroundColor = [UIColor whiteColor];

    ViewController *home = [[ViewController alloc]init];
    [self addChildVc:home title:@"菜谱大师" image:@"home" selectedImage:@"home"];
    SearchViewController *search = [[SearchViewController alloc]init];
    [self addChildVc:search title:@"搜索" image:@"home" selectedImage:@"home"];
    MarkViewController *mark = [[MarkViewController alloc]init];
    [self addChildVc:mark title:@"收藏" image:@"home" selectedImage:@"home"];
    CalendarViewController *calendar = [[CalendarViewController alloc]init];
     [self addChildVc:calendar title:@"浏览" image:@"home" selectedImage:@"home"];
}


- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title;
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
//    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
//    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
//    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
  
    
 
    [self addChildViewController:nav];
}
//- (void)viewWillAppear:(BOOL)animated
//{
//   [super viewWillAppear:animated];
//    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
//    
//    statusBarView.backgroundColor=[UIColor redColor];
//    
//    [self.view addSubview:statusBarView];
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//   
//}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleBlackOpaque;
//}
@end
