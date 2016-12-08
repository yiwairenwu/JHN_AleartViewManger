//
//  JHNAleartViewManger.h
//  MeiXieJiaApp
//
//  Created by cn.wz.jingzhi on 15/5/27.
//  Copyright (c) 2015年 MeiXieJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JHNAleartViewMangerDelegate

- (void)aleartViewCloseAfter;


@end
@interface JHNAleartViewManger : NSObject
@property (nonatomic,assign)id<JHNAleartViewMangerDelegate> delegate;
@property (nonatomic,strong) UIView *rootView;
@property (nonatomic,assign,readonly) BOOL isOpen;
@property (nonatomic,strong) UIView *baseView;
+ (JHNAleartViewManger *)initWithRootView:(UIView *)view;
- (void)setBaseView:(UIView *)baseView behindSubView:(UIView *)subView;
- (void)open;
- (void)close;
@end
