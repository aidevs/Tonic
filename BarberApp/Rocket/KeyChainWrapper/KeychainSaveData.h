//
//  KeychainSaveData.h
//  PostiveConnections
//
//  Created by Pankaj Asudani on 10/02/15.
//  Copyright (c) 2015 Deepesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainSaveData : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
