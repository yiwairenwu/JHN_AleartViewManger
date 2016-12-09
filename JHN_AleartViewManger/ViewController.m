//
//  ViewController.m
//  JHN_AleartViewManger
//
//  Created by Coco on 2016/11/24.
//  Copyright © 2016年 Coco. All rights reserved.
//

#import "ViewController.h"
#import "JHN_AleartViewManger.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *aleartView;
@property (strong, nonatomic) IBOutlet UIView *disView;
@property (nonatomic,strong) JHN_AleartViewManger *manger;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _manger = [JHN_AleartViewManger initWithAleartContentView:_aleartView];
    [_manger aleartViewWillOpen:^(UIView *aleartContentView) {
        NSLog(@"willOpen");
    } completion:^(UIView *aleartContentView) {
        NSLog(@"didOpen");
    }];
    [_manger aleartViewWillClose:^(UIView *aleartContentView) {
        NSLog(@"willClose");
    } completion:^(UIView *aleartContentView) {
        NSLog(@"didClose");
    }];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)oneAction:(UIButton *)sender {
    [_manger setParentView:self.view];
   
    [_manger openWith:JHN_AleartViewAnimationShowFrombelow];
    
}
- (IBAction)twoAction:(UIButton *)sender {
    [_manger setParentView:self.view behindSubView:self.disView];
  
    [_manger open];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
