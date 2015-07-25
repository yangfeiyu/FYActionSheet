//
//  FYActionSheet.h
//  FYActionSheet
//
//  Created by yangfeiyu on 15-7-25.
//  Copyright (c) 2015年 NJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FYActionSheetDirection) {
    FYActionSheetDirectionTop,
    FYActionSheetDirectionBottom,
};

@interface FYActionSheet : UIView

- (void)showTargetView:(UIView *)targetView inView:(UIView *)containerView direction:(FYActionSheetDirection)direction edgeInset:(CGFloat)inset animationDuration:(NSTimeInterval)duration;

- (void)dismissActionSheetAnimated:(BOOL)animated;

@end
