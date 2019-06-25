//
//  VcLifeCycleViewController.m
//  lengli_learn
//
//  Created by li leng on 2019/6/20.
//  Copyright © 2019 li leng. All rights reserved.
//

#import "VcLifeCycleViewController.h"
#import "PromptBoxView.h"

@interface VcLifeCycleViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation VcLifeCycleViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSString *detail = @"除了从故事面板初始化其余都走这个方法";
    [self.dataArray addObject:@{@"title" : NSStringFromSelector(_cmd), @"detail" : detail}];
    [self.myTableView reloadData];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSString *detail = @"从故事面板初始化走这个方法";
    [self.dataArray addObject:@{@"title" : NSStringFromSelector(_cmd), @"detail" : detail}];
    [self.myTableView reloadData];
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)awakeFromNib {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSString *detail = @"xib加载结束";
    [self.dataArray addObject:@{@"title" : NSStringFromSelector(_cmd), @"detail" : detail}];
    [self.myTableView reloadData];
    [super awakeFromNib];
}

- (void)loadView {
    [super loadView];
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSString *detail = @"loadview方法在不使用代码创建控价的时候禁止使用 会创建空的view 如果创建视图使用initWithNibName:bundle:不会创建新的view";
    [self.myTableView reloadData];
    [self.dataArray addObject:@{@"title" : NSStringFromSelector(_cmd), @"detail" : detail}];
}

- (void)viewDidLoad {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSString *detail = @"视图加载结束";
    [self.dataArray addObject:@{@"title" : NSStringFromSelector(_cmd), @"detail" : detail}];
    [super viewDidLoad];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableviewcell"];
    [self.myTableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSString *detail = @"即将布局子控件";
    [self.dataArray addObject:@{@"title" : NSStringFromSelector(_cmd), @"detail" : detail}];
    [super viewWillLayoutSubviews];
    [self.myTableView reloadData];
}

- (void)viewDidLayoutSubviews {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSString *detail = @"子控件布局结束";
    [self.dataArray addObject:@{@"title" : NSStringFromSelector(_cmd), @"detail" : detail}];
    [super viewDidLayoutSubviews];
    [self.myTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewcell"];
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [PromptBoxView showPromptBoxViewWithPromptBoxStr:self.dataArray[indexPath.row][@"detail"]];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
