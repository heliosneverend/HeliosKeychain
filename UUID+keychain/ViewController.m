//
//  ViewController.m
//  UUID+keychain
//
//  Created by helios on 2018/8/3.
//  Copyright © 2018年 helios. All rights reserved.
//

#import "ViewController.h"
#import "UIDevice+RRDKeychainIDFV.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40, 40)];
    label.font = [UIFont systemFontOfSize:16.0];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"设备唯一标识符:\n %@",[UIDevice RRDKeychainIDFV]];
    [self.view addSubview:label];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
