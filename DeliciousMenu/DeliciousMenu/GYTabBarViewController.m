//
//  GYTabBarViewController.m
//  tabbar
//
//  Created by hgy on 16/2/18.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "GYTabBarViewController.h"
#import "MarkViewController.h"
#import "CalendarViewController.h"
#import "UIButton+Extension.h"
#import "SearchViewController.h"
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import <WMPageController.h>
#import "MenufirstViewController.h"
#import "MenuSecondViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MenuHomeViewController.h"
@interface GYTabBarViewController ()
@property (nonatomic,strong) WMPageController *page;
@property (nonatomic,strong) NSMutableArray *controllersArray;
@end
@implementation GYTabBarViewController
- (NSMutableArray *)controllersArray{
    if (!_controllersArray) {
        _controllersArray = [NSMutableArray array];
    }
    return _controllersArray;
}


- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
    [self initConst];
    [self initDB];
    [self initNotificationCenter];
    [self setupTabBar];
    
    [[JHOpenidSupplier shareSupplier] registerJuheAPIByOpenId:OpenID];

    self.view.backgroundColor = [UIColor whiteColor];
    MenuHomeViewController *page = [self p_defaultController];
    [self addChildVc:page title:@"主页" image:@"home" selectedImage:@"home"];
    _page = page;
 
    SearchViewController *search = [[SearchViewController alloc]init];
    [self addChildVc:search title:@"搜索" image:@"home" selectedImage:@"home"];
    CalendarViewController *mark = [[CalendarViewController alloc]init];
    [self addChildVc:mark title:@"浏览" image:@"home" selectedImage:@"home"];
   
   
}
- (void)initConst{
    defaultImage = [UIImage imageNamed:@"coffee"];
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
- (void)initDB{
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
- (void)initNotificationCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MenuFirstViewFooterClick) name:MenuFirstViewControllerNotification object:nil];
}
- (void)setupTabBar
{
    CGFloat buttonWidth = 60;
    
    CGFloat margin = (self.view.width - 3 * (buttonWidth)) / 4;
    for (int i= 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc]init];
        CGFloat btnx = (margin) * (i + 1)+  buttonWidth * i;
        CGFloat btny = self.view.height - buttonWidth - 10;
        
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d",i]] forState:UIControlStateNormal];
        btn.tag = i;
        btn.frame = CGRectMake(btnx, btny, buttonWidth, buttonWidth);
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}
- (void)MenuFirstViewFooterClick{
    _page.selectIndex = 1;
}
- (MenuHomeViewController *)p_defaultController {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        Class vcClass;
        NSString *title;
        switch (i % 3) {
            case 0:
                vcClass = [MenufirstViewController class];
                
                title = @"菜式菜品";
                break;
            case 1:
                vcClass = [MenuSecondViewController class];
                title = @"分类";
                break;
            default:
                vcClass = [MarkViewController class];
                title = @"Fluency";
                break;
        }
        [viewControllers addObject:vcClass];
        [titles addObject:title];
    }
    MenuHomeViewController *pageVC = [[MenuHomeViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    
  
   
    pageVC.menuItemWidth = 85;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title;
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
   
    [self addChildViewController:nav];
    [self.controllersArray addObject:nav];
}

- (void)btnClick:(UIButton *)btn

{
    UINavigationController *nav = [self.controllersArray objectAtIndex:btn.tag];
   
    [nav popToRootViewControllerAnimated:YES];
    self.selectedIndex = btn.tag;
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [self.tabBar setHidden:YES];
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
