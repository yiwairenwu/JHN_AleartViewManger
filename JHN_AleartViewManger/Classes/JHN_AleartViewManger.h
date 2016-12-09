//
//  JHNAleartViewManger.h
//  JHN_AleartViewManger
//
//  Created by JHN on 15/5/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum JHN_AleartViewAnimateType
{
    JHN_AleartViewAnimationNone ,
    JHN_AleartViewAnimationShowFrombelow ,
    JHN_AleartViewAnimationFlash
    
} JHN_AleartViewAnimateType;
typedef void (^JHN_AleartViewAnimate) (UIView* aleartContentView);
@protocol JHN_AleartViewMangerDelegate
@required
@optional
- (void)aleartViewWillOpen:(UIView* )aleartContentView;
- (void)aleartViewDidOpen:(UIView* )aleartContentView;
- (void)aleartViewWillClose:(UIView* )aleartContentView;
- (void)aleartViewDidOClose:(UIView* )aleartContentView;
@end
@interface JHN_AleartViewManger : NSObject
@property (nonatomic,weak) NSObject <JHN_AleartViewMangerDelegate>* delegate;

@property (nonatomic,assign,readonly) BOOL isOpen;

+ (instancetype)initWithAleartContentView:(UIView *)aleartContentView;
//设置弹出内容
- (void)setAleartContentView:(UIView *)aleartContentView;
//设置弹出窗口所在View 默认[[[UIApplication sharedApplication] windows] objectAtIndex:0]
- (void)setParentView:(UIView *)parentView;
- (void)setParentView:(UIView *)parentView behindSubView:(UIView *)subView;
- (void)open;
- (void)openWith:(JHN_AleartViewAnimateType)aleartViewAnimateType;
- (void)close;
- (void)aleartViewWillOpen:(JHN_AleartViewAnimate)willOpen completion:(JHN_AleartViewAnimate)didOpen;
- (void)aleartViewWillClose:(JHN_AleartViewAnimate)willClose completion:(JHN_AleartViewAnimate)didClose;
@end
