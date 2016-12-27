//
//  JHNAleartViewManger.m
//  JHN_AleartViewManger
//
//  Created by JHN on 15/5/27.
//

#import "JHN_AleartViewManger.h"
#define JHN_ScreenHeight CGRectGetHeight([self screenBounds])
#define JHN_ScreenWidth CGRectGetWidth([self screenBounds])
@interface JHN_AleartViewManger()
@property (nonatomic,strong) UIView *rootView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIButton *coverButton;
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
            
        [_containerView setFrame:CGRectMake(0, JHN_ScreenHeight-_aleartContentView.frame.size.height, JHN_ScreenWidth ,_aleartContentView.frame.size.height)];
    }else{
        [_containerView setFrame:CGRectMake(0, JHN_ScreenHeight, JHN_ScreenWidth ,_aleartContentView.frame.size.height)];
    }
     _aleartContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:_aleartContentView];
    [_containerView setBackgroundColor:_aleartContentView.backgroundColor];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_aleartContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_aleartContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_aleartContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:_aleartContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    constraint.active = YES;
    constraint1.active = YES;
    constraint2.active = YES;
    constraint3.active = YES;

}
- (void)setParentView:(UIView *)parentView
{
    _parentView = parentView;

}

- (instancetype)init
{
    if (self = [super init]) {
      
        _isOpen = NO;
        _rootView = [[UIView alloc] initWithFrame:[self screenBounds]];
        _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverButton setFrame:[self screenBounds]];
        [_coverButton setBackgroundColor:  [UIColor colorWithWhite:0 alpha:0]];
        [_coverButton addTarget:self action:@selector(coverAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, JHN_ScreenHeight, JHN_ScreenWidth ,200)];
        [_containerView setBackgroundColor:[UIColor whiteColor]];
        [_rootView addSubview:_coverButton];
        [_rootView addSubview:_containerView];
        _aleartViewAnimateType = JHN_AleartViewAnimationNone;
       
    }
     
    
    
   
    
    
    return self;
}
- (void)coverAction
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
    switch (_aleartViewAnimateType) {
            case JHN_AleartViewAnimationFlash:
        case JHN_AleartViewAnimationNone:
        {
            [UIView animateWithDuration:0.2 animations:^{
                [_containerView setFrame:CGRectMake(0, JHN_ScreenHeight, JHN_ScreenWidth, _containerView.frame.size.height)];
            } completion:^(BOOL finished) {
                
                
                if (_delegate &&  [_delegate respondsToSelector:@selector(aleartViewDidOClose:)]) {
                    
                    [_delegate aleartViewDidOClose:_aleartContentView];
                }
                if (_didClose) {
                    _didClose(_aleartContentView);
                }
                [_rootView removeFromSuperview];
            }];
        }
            break;
         case JHN_AleartViewAnimationShowFrombelow:
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                if (self.parentView !=nil) {
                    CATransform3D transform = CATransform3DIdentity;
                    transform.m34 = 1.0 / -900.0;
                    transform = CATransform3DScale(transform, 0.95, 0.95, 1);
                    transform = CATransform3DRotate(transform, 15.0*M_PI/180.0, 1, 0, 0);
                    transform = CATransform3DTranslate(transform, 0, 0, -100.0);
                    
                    self.parentView.layer.transform = transform;
                     [_containerView setFrame:CGRectMake(0, JHN_ScreenHeight, JHN_ScreenWidth, _containerView.frame.size.height)];
                }
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.3 animations:^{
                     self.parentView.layer.transform = CATransform3DIdentity;
                }completion:^(BOOL finished) {
                     [_rootView removeFromSuperview];
                }];
               
                
            }];
        }
            break;
        
    }
    
  
   
}
- (void)openAnimate
{
    [[self topView] addSubview:_rootView];
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
                [_containerView setFrame:CGRectMake(0, JHN_ScreenHeight-_containerView.frame.size.height, JHN_ScreenWidth, _containerView.frame.size.height)];
                
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
//            CGPoint tempPoint = _containerView.center;
//            _containerView.center = CGPointMake(JHN_ScreenWidth/2, tempPoint.y+JHN_ScreenHeight);
            [UIView animateWithDuration:0.3 animations:^{
               
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
                   [_containerView setFrame:CGRectMake(0, JHN_ScreenHeight-_containerView.frame.size.height, JHN_ScreenWidth, _containerView.frame.size.height)];
                }];
                
            }];
        }
            break;
        case JHN_AleartViewAnimationFlash:
        {
            [_containerView setFrame:CGRectMake(0, JHN_ScreenHeight-_containerView.frame.size.height, JHN_ScreenWidth, _containerView.frame.size.height)];
            CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            popAnimation.duration = 0.4;
            popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                    [NSValue valueWithCATransform3D:CATransform3DIdentity]];
            popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
            popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [_containerView.layer addAnimation:popAnimation forKey:nil];
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
    _aleartViewAnimateType = JHN_AleartViewAnimationNone;
    [self setIsOpen:YES];
}
- (void)close
{
    [self setIsOpen:NO];
}
-(UIView*)topView{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return  window;
}

- (CGRect)screenBounds
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGRectMake(0, 0, screenWidth, screenHeight);
}
@end
