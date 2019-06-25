//
//  TabBar.m
//  lengli_learn
//
//  Created by li leng on 2019/6/21.
//  Copyright © 2019 li leng. All rights reserved.
//

#import "TabBar.h"
#import "CustomTabBarButton.h"

@implementation TabBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item {
    CustomTabBarButton *btn = [CustomTabBarButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    
    btn.item = item;
    [btn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClickAction:(BaseTabBarButton *)sender {
    
}

- (void)layoutSubviews {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BaseTabBarButton *button = obj;
        CGFloat btnW = self.frame.size.width / self.subviews.count;
        CGFloat btnX = idx * btnW;
        CGFloat btnY = 0;
        CGFloat btnH = self.frame.size.height;
        
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        button.tag = idx;
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
