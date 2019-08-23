//
//  Created by Deepesh on 24/02/16.
//  Copyright __MyCompanyName__ 2016. All rights reserved.
//

#ifndef UIDevice_Macros_h
#define UIDevice_Macros_h

#define CURRENT_DEVICE_VERSION_FLOAT  [[UIDevice currentDevice] systemVersion].floatValue
#define CURRENT_DEVICE_VERSION_STRING [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define IS_CAMERA_AVAILABLE [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]

#define FIX_IOS_7_EDGE_START_LAY_OUT_ISSUE     if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;

#define SET_BACKGROUND_COLOR     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:IS_IPHONE_5?@"mainBg":@"mainBg4"]]];

#define BACKGROUND_BG_IMAGE [UIImage imageNamed:IS_IPHONE_5?@"mainBg":@"mainBg4"]

#endif
