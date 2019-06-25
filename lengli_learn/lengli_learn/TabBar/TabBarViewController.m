//
//  TabBarViewController.m
//  lengli_learn
//
//  Created by li leng on 2019/6/20.
//  Copyright © 2019 li leng. All rights reserved.
//

#import "TabBarViewController.h"
#import "TabBar.h"

#import "VcLifeCycleViewController.h"
#import "ViewController.h"

@interface TabBarViewController ()
@property (nonatomic, strong) TabBar *customTabBar;
@end

@implementation TabBarViewController
- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    for (UIView *child in self.tabBar.subviews) {
//        if ([child isKindOfClass:[UIControl class]]) {
//            [child removeFromSuperview];
//        }
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBar.backgroundColor = [UIColor whiteColor];
//    [self setupTabBar];
//    [self setupChildView];
    // Do any additional setup after loading the view.
}

- (void)setupTabBar {
    TabBar *tabBar = [[TabBar alloc] init];
    tabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:tabBar];
    self.customTabBar = tabBar;
}

- (void)setupChildView {
    VcLifeCycleViewController *a = [[VcLifeCycleViewController alloc] init];
    [self setupChildViewController:a title:@"111" imageName:@"NavigationClose" selectedImageName:@"NavigationClose"];
    
    ViewController *b = [[ViewController alloc] init];
    [self setupChildViewController:b title:@"222" imageName:@"NavigationClose" selectedImageName:@"NavigationClose"];
}

- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

- (UIImage*)createImageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
