//
//  ViewController.m
//  lengli_learn
//
//  Created by li leng on 2019/6/19.
//  Copyright © 2019 li leng. All rights reserved.
//

#import "ViewController.h"
#import "VcLifeCycleViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(aaa) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view.
}

- (void)aaa {
    VcLifeCycleViewController *vc = [[VcLifeCycleViewController alloc] initWithNibName:@"VcLifeCycleViewController" bundle:nil];
//    VcLifeCycleViewController *vc = [[VcLifeCycleViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
