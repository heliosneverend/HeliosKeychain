//
//  UIDevice+RRDKeychainIDFV.h
//  UUID+keychain
//
//  Created by helios on 2018/8/3.
//  Copyright © 2018年 helios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (RRDKeychainIDFV)
- (NSString *)RRDKeychainIDFV;
+ (NSString *)RRDKeychainIDFV;
- (void)removeRRDKeychainIDFV;
+ (void)removeRRDKeychainIDFV;
@end
