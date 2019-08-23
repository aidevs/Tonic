//
//  Created by Deepesh on 24/02/16.
//  Copyright __MyCompanyName__ 2016. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validate : NSObject
{
  
}

+ (BOOL)isNull:(NSString*)str;
+ (BOOL)isValidEmailId:(NSString*)email;
+ (BOOL)isValidMobileNumber:(NSString*)number;
+ (BOOL) isValidUserName:(NSString*)userName;
+ (BOOL) isValidPassword:(NSString*)password;
+ (BOOL) isValidAge:(NSString*)age;

+ (NSString *)trimTextField:(NSString*)value;

@end
