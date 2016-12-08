//
//  JHNAleartViewManger.m
//  MeiXieJiaApp
//
//  Created by cn.wz.jingzhi on 15/5/27.
//  Copyright (c) 2015年 MeiXieJia. All rights reserved.
//

#import "JHNAleartViewManger.h"
#define JHN_ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define JHN_ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface JHNAleartViewManger()
@property (nonatomic,strong) UIView *mainView;
@property (nonatomic,strong) UIButton *bgViewButton;

@end
@implementation JHNAleartViewManger
+ (JHNAleartViewManger *)initWithRootView:(UIView *)view
{
    JHNAleartViewManger *manger = [[JHNAleartViewManger alloc]init];
   
    [manger setRootView:view];
    return manger;
}
- (void)setRootView:(UIView *)rootView
{
    _rootView = rootView;
   
    if (_isOpen) {
            
        [_mainView setFrame:CGRectMake(0, JHN_ScreenHeight-_rootView.frame.size.height, JHN_ScreenWidth ,_rootView.frame.size.height)];
    }else{
        [_mainView setFrame:CGRectMake(0, JHN_ScreenHeight, JHN_ScreenWidth ,_rootView.frame.size.height)];
    }
     _rootView.translatesAutoresizingMaskIntoConstraints = NO;
    [_mainView addSubview:_rootView];
    [_mainView setBackgroundColor:_rootView.backgroundColor];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_mainView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_mainView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_mainView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_mainView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    constraint.active = YES;
    constraint1.active = YES;
    constraint2.active = YES;
    constraint3.active = YES;

}
- (void)setBaseView:(UIView *)baseView
{
    _baseView = baseView;
    [_mainView removeFromSuperview];
    [_baseView addSubview:_mainView];
}
- (void)setBaseView:(UIView *)baseView behindSubView:(UIView *)subView
{
    _baseView = baseView;
    [_mainView removeFromSuperview];
    [_baseView insertSubview:_mainView belowSubview:subView];
}
- (instancetype)init
{
    if (self = [super init]) {
      
        _isOpen = NO;
        _bgViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgViewButton setFrame:CGRectMake(0, 0, JHN_ScreenWidth, JHN_ScreenHeight)];
        [_bgViewButton setBackgroundColor:  [UIColor colorWithWhite:0 alpha:0.5]];
        [_bgViewButton addTarget:self action:@selector(bgAction) forControlEvents:UIControlEventTouchUpInside];
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, JHN_ScreenHeight, JHN_ScreenWidth ,200)];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        _baseView = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [_baseView addSubview:_mainView];
       
    }
     
    
    
   
    
    
    return self;
}
- (void)bgAction
{
    [self setIsOpen:NO];
}
- (void)removeBg{
    [UIView animateWithDuration:0.2 animations:^{
        [_mainView setFrame:CGRectMake(0, JHN_ScreenHeight, JHN_ScreenWidth, _mainView.frame.size.height)];
    } completion:^(BOOL finished) {
         [_bgViewButton removeFromSuperview];
        if (_delegate) {
            [_delegate aleartViewCloseAfter];
        }
    }];
   
}
- (void)addKeyWindow
{
    [_baseView insertSubview:_bgViewButton belowSubview:_mainView];
    [UIView animateWithDuration:0.2 animations:^{
        [_mainView setFrame:CGRectMake(0, JHN_ScreenHeight-_mainView.frame.size.height, JHN_ScreenWidth, _mainView.frame.size.height)];
        
    } completion:^(BOOL finished) {
        nil;
    }];
}
- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    if (_isOpen) {
        [self addKeyWindow];
    }else{
        [self removeBg];
    }
}
- (void)open
{
    [self setIsOpen:YES];
}
- (void)close
{
    [self setIsOpen:NO];
}
@end
