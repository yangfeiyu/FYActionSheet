//
//  FYActionSheet.m
//  FYActionSheet
//
//  Created by yangfeiyu on 15-7-25.
//  Copyright (c) 2015年 NJJ. All rights reserved.
//

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:((CGFloat)((r)/255.0)) green:((CGFloat)((g)/255.0)) blue:((CGFloat)((b)/255.0)) alpha:((CGFloat)((a)))]

#import "FYActionSheet.h"

@interface FYActionSheet ()
@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) NSInteger edgeInset;
@property (nonatomic, strong) NSLayoutConstraint *marginEdgeConstraint;    // 距离上边界或者下边界的约束
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *centerXConstraint;
@property (nonatomic, assign) FYActionSheetDirection direction;
@property (nonatomic, assign) NSInteger targetViewHeight;
@property (nonatomic, assign) NSInteger targetViewWidth;
@property (nonatomic, assign) NSTimeInterval duration;
@end

@implementation FYActionSheet

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - public methods
- (void)showTargetView:(UIView *)targetView inView:(UIView *)containerView direction:(FYActionSheetDirection)direction edgeInset:(CGFloat)edgeInset animationDuration:(NSTimeInterval)duration {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    void (^completion)(void) = ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    };
    
    self.direction = direction;
    self.edgeInset = edgeInset;
    self.duration = duration;
    self.containerView = containerView;
    [self.containerView addSubview:self];
    
    self.targetView = targetView;
    self.targetView.translatesAutoresizingMaskIntoConstraints = NO;
    self.targetViewHeight = CGRectGetHeight(self.targetView.bounds);
    self.targetViewWidth = CGRectGetWidth(self.targetView.bounds);
    [self addSubview:self.targetView];
    [self setupTargetViewConstraints];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self}]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self}]];
    
    self.hidden = NO;
    [self layoutForVisible:NO];
    [UIView animateWithDuration:self.duration animations:^{
        [self layoutForVisible:YES];
    } completion:^(BOOL finished) {
        completion();
    }];
}

- (void)dismissActionSheetAnimated:(BOOL)animated {
    if (self.hidden) {
        return;
    }
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    __weak typeof(self) weakSelf = self;
    void (^completion)(void) = ^{
        weakSelf.containerView = nil;
        weakSelf.hidden = YES;
        [weakSelf removeFromSuperview];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    };
    
    if (animated) {
        [UIView animateWithDuration:self.duration animations:^{
            [self layoutForVisible:NO];
        } completion:^(BOOL finished) {
            completion();
        }];
    } else {
        [self layoutForVisible:NO];
        completion();
    }
}

#pragma mark - privates
- (void)layoutForVisible:(BOOL)visible {
    switch (self.direction) {
        case FYActionSheetDirectionTop: {
            if (visible) {
                self.marginEdgeConstraint.constant = self.edgeInset;
                self.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
            } else {
                self.backgroundColor = [UIColor clearColor];
                self.marginEdgeConstraint.constant = self.targetViewHeight - self.edgeInset;
            }
            break;
        }
            
        case FYActionSheetDirectionBottom: {
            if (visible) {
                self.marginEdgeConstraint.constant = -self.edgeInset;
                self.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
            } else {
                self.backgroundColor = [UIColor clearColor];
                self.marginEdgeConstraint.constant = self.targetViewHeight + self.edgeInset;
            }
            break;
        }
        default:
            break;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setupTargetViewConstraints {
    switch (self.direction) {
        case FYActionSheetDirectionTop: {
            self.marginEdgeConstraint = [NSLayoutConstraint constraintWithItem:self.targetView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.targetView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.targetViewHeight];
            self.widthConstraint = [NSLayoutConstraint constraintWithItem:self.targetView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.targetViewWidth];
            self.centerXConstraint = [NSLayoutConstraint constraintWithItem:self.targetView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
            break;
        }
        case FYActionSheetDirectionBottom: {
            self.marginEdgeConstraint = [NSLayoutConstraint constraintWithItem:self.targetView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.targetView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.targetViewHeight];
            self.widthConstraint = [NSLayoutConstraint constraintWithItem:self.targetView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.targetViewWidth];
            self.centerXConstraint = [NSLayoutConstraint constraintWithItem:self.targetView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
            break;
        }
        default:
            break;
    }
    [self addConstraints:@[self.marginEdgeConstraint, self.heightConstraint, self.widthConstraint, self.centerXConstraint]];
    
}

@end
