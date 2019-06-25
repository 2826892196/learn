//
//  PromptBoxView.m
//  lengli_learn
//
//  Created by li leng on 2019/6/20.
//  Copyright © 2019 li leng. All rights reserved.
//

#import "PromptBoxView.h"
@interface PromptBoxView ()
@property (weak, nonatomic) IBOutlet UITextView *promptBoxTextView;

@end

@implementation PromptBoxView
+ (void)showPromptBoxViewWithPromptBoxStr:(NSString *)str {
    PromptBoxView *vc = [[PromptBoxView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    vc.promptBoxTextView.text = str;
    [vc showView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PromptBoxView" owner:self options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}

- (void)showView {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSEnumerator *frontToBackWindow = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindow) {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self];
                break;
            }
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
