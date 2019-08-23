//
//  Created by Deepesh on 24/02/16.
//  Copyright __MyCompanyName__ 2016. All rights reserved.



#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"
#import "KeychainSaveData.h"

@interface Config : NSObject {

}

//configuration section...

extern  NSString		*SiteURL;
extern  NSString		*SiteAPIURL;

extern  NSString        *isChat;
extern  NSString        *isLogin;
extern  NSString        *isChatVC;
extern  NSString        *DatabaseName;
extern  NSString        *DatabasePath;

extern  NSString        *sid;


extern  KeychainSaveData *keychainItemWrapper;



@end
