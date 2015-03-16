//
//  BlePeripheral.h
//  dmcmrClient
//
//  Created by ryu on 2015/03/07.
//  Copyright (c) 2015年 hanahana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BlePeripheral : NSObject<CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableService *service;
@property (strong, nonatomic) CBCharacteristic *characteristic;

-(BlePeripheral*)init:(NSString*)user_id;

@end
