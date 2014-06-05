//
//  hanaAppDelegate.m
//  dmcmrClient
//
//  Created by ryu on 2014/06/02.
//  Copyright (c) 2014年 hanahana. All rights reserved.
//

#import "hanaAppDelegate.h"

#define SERVICE_UUID @"48596A53-8DF0-4BEE-A4DD-8CB2DFBC4D20"
#define CHARACTERISTIC_UUID @"2B6B1035-28B8-4BD4-ACB2-538D350E9DFF"


@implementation hanaAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"dataaaaaaa2222");
    
    
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    //サービスとキャラクタリスティックを構築する
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:CHARACTERISTIC_UUID];
    characteristic = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID
                                                        properties:CBCharacteristicPropertyRead
                                                             value:nil permissions:CBAttributePermissionsReadable];
    CBUUID *serviceUUID = [CBUUID UUIDWithString:SERVICE_UUID];
    service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
    service.characteristics = @[characteristic];
    
    
    NSLog(@"dataaaaaaa3333");
    
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    

}

//Bluetoothの状態が変更されるとコールされる
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"State Updated");
    
    if(peripheral.state == CBPeripheralManagerStatePoweredOn){
        NSLog(@"ready");
        
        [peripheralManager addService:service];
    }
}

//サービスがペリファレルに追加されるとコールされる。
-(void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    if(error) {
        NSLog(@"Error adding Service:%@",[error localizedDescription]);
    }
    else{
        NSLog(@"Adding Service Successful");
        
        [self startAdvertisingTouched];
        
    }
}

-(void)startAdvertisingTouched
{
    NSLog(@"startAdvertisingTouched");
    
    
    //アドバタイズを開始する
    [peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[service.UUID],
                                           CBAdvertisementDataLocalNameKey:@"HelloPeripheral"}];
}

-(void)stopAdvertisingTouched
{
    //アドバタイズを停止する
    [peripheralManager stopAdvertising];
}

//アドバタイズが開始されるとコールされる
-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    if(error){
        NSLog(@"Error Advertising:%@",[error localizedDescription]);
    }
    else{
        NSLog(@"Starting Advertising Successful");
    }
}

//そして、最後にセントラルからの接続と要求を受けて、結果をセントラルに返す処理です。
//セントラルから要求を受けると、peripheralManager:didReceiveReadRequest:がコールされます。
-(void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    NSLog(@"Request received: %@ request = %@",request.characteristic.UUID.description,request.central.UUID);
    //キャラクタリスティックのUUIDが一致する場合
    if([request.characteristic.UUID isEqual:characteristic.UUID]) {
        request.value = [@"Hello!" dataUsingEncoding:NSUTF8StringEncoding];
        [peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
        return;
    }
    
    [peripheralManager respondToRequest:request withResult:CBATTErrorAttributeNotFound];
}











- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
