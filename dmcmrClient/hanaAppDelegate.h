//
//  hanaAppDelegate.h
//  dmcmrClient
//
//  Created by ryu on 2014/06/02.
//  Copyright (c) 2014年 hanahana. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BlePeripheral.h"

@interface hanaAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BlePeripheral *ble;



@end
