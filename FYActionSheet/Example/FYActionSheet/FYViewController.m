//
//  FYViewController.m
//  FYActionSheet
//
//  Created by yangfeiyu on 15-7-25.
//  Copyright (c) 2015年 NJJ. All rights reserved.
//

#import "FYViewController.H"
#import "FYActionSheet.h"

@interface FYViewController ()
@property (nonatomic, strong) FYActionSheet *actionSheet;
@property (nonatomic, strong) UIView *targetView;
@end

@implementation FYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FYActionSheet *actionSheet = [[FYActionSheet alloc] init];
    self.actionSheet = actionSheet;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 500, 100, 100)];
    [button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)tapButton {
    UILabel *targetView= [[UILabel alloc] init];
    [targetView setFrame:CGRectMake(30, 40, 100, 30)];
    targetView.text = @"fdsfdfd";
    targetView.backgroundColor = [UIColor purpleColor];
    [self.actionSheet showTargetView:targetView inView:self.view direction:FYActionSheetDirectionBottom edgeInset:300 animationDuration:0.25];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.actionSheet dismissActionSheetAnimated:YES];
}


@end
