//
//  UIDevice+RRDKeychainIDFV.m
//  UUID+keychain
//
//  Created by helios on 2018/8/3.
//  Copyright © 2018年 helios. All rights reserved.
//

#import "UIDevice+RRDKeychainIDFV.h"

@implementation UIDevice (RRDKeychainIDFV)
+(NSString *)RRDKeychainIDFV
{
    return [[self currentDevice] RRDKeychainIDFV];
}

-(NSString *)RRDKeychainIDFV
{
    NSString *idfv = [self RRDgetIdfvFromKeyChain];
    
    if (idfv && idfv.length > 0 && [idfv isKindOfClass:[NSString class]]) {
        return idfv;
    }else
    {
        NSString *idfv = [[self identifierForVendor] UUIDString];
        idfv = [idfv stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self RRDsaveIdfvToKeyChain:idfv];
        return idfv;
    }
}


-(void)removeRRDKeychainIDFV
{
    NSString *keychainKey = [[NSBundle mainBundle] bundleIdentifier];
    keychainKey = [keychainKey stringByAppendingString:@".RRDIDFV"];
    [self RRDdelete:keychainKey];
}

+(void)removeRRDKeychainIDFV
{
    [[self currentDevice] removeRRDKeychainIDFV];
}


-(void)RRDsaveIdfvToKeyChain:(NSString *)idfv
{
    NSString *keychainKey = [[NSBundle mainBundle] bundleIdentifier];
    keychainKey = [keychainKey stringByAppendingString:@".RRDIDFV"];
    [self RRDsave:keychainKey data:idfv];
}

-(NSString *)RRDgetIdfvFromKeyChain
{
    NSString *keychainKey = [[NSBundle mainBundle] bundleIdentifier];
    keychainKey = [keychainKey stringByAppendingString:@".RRDIDFV"];
    NSString * idfv = [self load:keychainKey];
    return idfv;
}


- (NSMutableDictionary *)RRDgetKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}

- (void)RRDsave:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self RRDgetKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}

- (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self RRDgetKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}

- (void)RRDdelete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self RRDgetKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}

@end
