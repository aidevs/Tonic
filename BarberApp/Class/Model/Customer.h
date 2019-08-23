//
//  Customer.h
//  BarberApp
//
//  Created by Manan on 8/23/17.
//  Copyright © 2017 Deepesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject

@property (nonatomic,strong) NSString * appointment_id;
@property (nonatomic,strong) NSString * user_id;
@property (nonatomic,strong) NSString * image_url;
@property (nonatomic,strong) NSString * customer_name;

@end
