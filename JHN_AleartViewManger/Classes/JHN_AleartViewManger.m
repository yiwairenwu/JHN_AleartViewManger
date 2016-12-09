//
//  JHNAleartViewManger.m
//  JHN_AleartViewManger
//
//  Created by JHN on 15/5/27.
//

#import "JHN_AleartViewManger.h"
#define JHN_ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define JHN_ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface JHN_AleartViewManger()
@property (nonatomic,strong) UIView *mainView;
@property (nonatomic,strong) UIButton *bgViewButton;
@property (nonatomic,strong) UIView *parentView;
@property (nonatomic,strong) UIView *aleartContentView;
@property (nonatomic,copy) JHN_AleartViewAnimate willOpen;
@property (nonatomic,copy) JHN_AleartViewAnimate didOpen;
@property (nonatomic,copy) JHN_AleartViewAnimate willClose;
@property (nonatomic,copy) JHN_AleartViewAnimate didClose;
@property (nonatomic,assign) JHN_AleartViewAnimateType aleartViewAnimateType;
@end
@implementation JHN_AleartViewManger
+ (instancetype)initWithAleartContentView:(UIView *)view
{
    JHN_AleartViewManger *manger = [[JHN_AleartViewManger alloc]init];
   
    [manger setAleartContentView:view];
    return manger;
}
- (void)setAleartContentView:(UIView *)aleartContentView
{
    _aleartContentView = aleartContentView;
   
    if (_isOpen) {
            
        [_mainView setFrame:CGRectMake(0, JHN_ScreenHeight-_aleartContentView.frame.size.height, JHN_ScreenWidth ,_aleartContentView.frame.size.height)];
    }else{
        [_mainView setFrame:CGRectMake(0, JHN_ScreenHeight, JHN_ScreenWidth ,_aleartContentView.frame.size.height)];
    }
     _aleartContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [_mainView addSubview:_aleartContentView];
    [_mainView setBackgroundColor:_aleartContentView.backgroundColor];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_aleartContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_mainView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_aleartContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_mainView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_aleartContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_mainView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:_aleartContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_mainView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    constraint.active = YES;
    constraint1.active = YES;
    constraint2.active = YES;
    constraint3.active = YES;

}
- (void)setParentView:(UIView *)parentView
{
    _parentView = parentView;
//    [_mainView removeFromSuperview];
//    [_parentView addSubview:_mainView];
}
- (void)setParentView:(UIView *)parentView behindSubView:(UIView *)subView
{
    _parentView = parentView;
//    [_mainView removeFromSuperview];
//    [_parentView insertSubview:_mainView belowSubview:subView];
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
    
        [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:_mainView];
        _aleartViewAnimateType = JHN_AleartViewAnimationNone;
       
    }
     
    
    
   
    
    
    return self;
}
- (void)bgAction
{
    [self setIsOpen:NO];
}
- (void)closeAnimate{
    if (_delegate &&  [_delegate respondsToSelector:@selector(aleartViewWillClose:)]) {
        [_delegate aleartViewWillClose:_aleartContentView];
    }
    if (_willClose) {
        _willClose(_aleartContentView);
    }
    [UIView animateWithDuration:0.2 animations:^{
        [_mainView setFrame:CGRectMake(0, JHN_ScreenHeight, JHN_ScreenWidth, _mainView.frame.size.height)];
    } completion:^(BOOL finished) {
         [_bgViewButton removeFromSuperview];
       
        if (_delegate &&  [_delegate respondsToSelector:@selector(aleartViewDidOClose:)]) {

            [_delegate aleartViewDidOClose:_aleartContentView];
        }
        if (_didClose) {
            _didClose(_aleartContentView);
        }
    }];
   
}
- (void)openAnimate
{
    
    if (_delegate &&  [_delegate respondsToSelector:@selector(aleartViewWillOpen:)]) {
        [_delegate aleartViewWillOpen:_aleartContentView];
    }
    if (_willOpen) {
        _willOpen(_aleartContentView);
    }
    switch (_aleartViewAnimateType) {
        case JHN_AleartViewAnimationNone:
        {
            [UIView animateWithDuration:0.2 animations:^{
                [_mainView setFrame:CGRectMake(0, JHN_ScreenHeight-_mainView.frame.size.height, JHN_ScreenWidth, _mainView.frame.size.height)];
                
            } completion:^(BOOL finished) {
                if (_delegate &&  [_delegate respondsToSelector:@selector(aleartViewDidOpen:)]) {
                    [_delegate aleartViewDidOpen:_aleartContentView];
                }
                if (_didOpen) {
                    _didOpen(_aleartContentView);
                }
            }];
        }
            break;
            
        case JHN_AleartViewAnimationShowFrombelow:
        {
            CGPoint tempPoint = _mainView.center;
            _mainView.center = CGPointMake(JHN_ScreenWidth/2, tempPoint.y+JHN_ScreenHeight);
            [UIView animateWithDuration:0.5 animations:^{
               
                if (self.parentView !=nil) {
                    CATransform3D transform = CATransform3DIdentity;
                    transform.m34 = 1.0 / -900.0;
                    transform = CATransform3DScale(transform, 0.95, 0.95, 1);
                    transform = CATransform3DRotate(transform, 15.0*M_PI/180.0, 1, 0, 0);
                    transform = CATransform3DTranslate(transform, 0, 0, -100.0);
                 
                    self.parentView.layer.transform = transform;
                  
                }
                
            } completion:^(BOOL finished) {
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    CATransform3D transform = CATransform3DIdentity;
                    transform.m34 = 1.0 / -900.0;
                    
                    transform = CATransform3DTranslate(transform, 0, self.parentView.frame.size.height * -0.08, 0);
                    transform = CATransform3DScale(transform, 0.8, 0.8, 1.0);
                    
                    self.parentView.layer.transform = transform;
                    if (_delegate &&  [_delegate respondsToSelector:@selector(aleartViewDidOpen:)]) {
                        [_delegate aleartViewDidOpen:_aleartContentView];
                    }
                    if (_didOpen) {
                        _didOpen(_aleartContentView);
                    }
                     _mainView.center = tempPoint;
                }];
                
            }];
        }
            break;
        case JHN_AleartViewAnimationFlash:
        {
            
        }
            break;
    }
    
    
}
- (void)aleartViewWillOpen:(JHN_AleartViewAnimate)willOpen completion:(JHN_AleartViewAnimate)didOpen
{
    _willOpen = willOpen;
    _didOpen = didOpen;

}
- (void)aleartViewWillClose:(JHN_AleartViewAnimate)willClose completion:(JHN_AleartViewAnimate)didClose
{
    _willClose = willClose;
    _didClose = didClose;
   
}
- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    if (_isOpen) {
        [self openAnimate];
    }else{
        [self closeAnimate];
    }
}
- (void)openWith:(JHN_AleartViewAnimateType)aleartViewAnimateType
{
    _aleartViewAnimateType = aleartViewAnimateType;
     [self setIsOpen:YES];
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
