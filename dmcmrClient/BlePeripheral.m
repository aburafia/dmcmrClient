//
//  BlePeripheral.m
//  dmcmrClient
//
//  Created by ryu on 2015/03/07.
//  Copyright (c) 2015年 hanahana. All rights reserved.
//

#import "BlePeripheral.h"

@implementation BlePeripheral

-(BlePeripheral*)init:(NSString*)user_id{
    
    NSLog(@"BlePeripheral::init finish userid=%@",user_id);
    
    //ペリフェラルを構築する
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        
    //自分自身のIDをbyteでわたす
    NSData *myuid = [user_id dataUsingEncoding:NSUTF8StringEncoding];
        
    //キャラクタリスティック（特性？）を構築する
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:CHARACTERISTIC_UUID];
    _characteristic = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID
                                                        properties:CBCharacteristicPropertyRead
                                                            value:myuid
                                                    permissions:CBAttributePermissionsReadable];
        
    //サービスを構築して、特性を埋め込む
    CBUUID *serviceUUID = [CBUUID UUIDWithString:SERVICE_UUID];
    _service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
    _service.characteristics = @[_characteristic];
    
    NSLog(@"BlePeripheral::init finish");
    
    return self;
}

//Bluetoothの状態が変更されるとコールされる
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"BlePeripheral::State Updated");
    
    if(peripheral.state == CBPeripheralManagerStatePoweredOn){
        NSLog(@"BlePeripheral::ready");
        
        [_peripheralManager addService:_service];
    }
}

//サービスがペリファレルに追加されるとコールされる。
-(void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    if(error) {
        NSLog(@"BlePeripheral::Error adding Service:%@",[error localizedDescription]);
    }
    else{
        NSLog(@"BlePeripheral::Adding Service Successful");
        
        [self startAdvertisingTouched];
    }
}
-(void)startAdvertisingTouched
{
    NSLog(@"BlePeripheral::startAdvertisingTouched");
    
    //アドバタイズを開始する
    [_peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[_service.UUID],
                                          CBAdvertisementDataLocalNameKey:@"HelloPeripheral"}];
}

-(void)stopAdvertisingTouched
{
    NSLog(@"BlePeripheral::stopAdvertisingTouched");
    
    //アドバタイズを停止する
    [_peripheralManager stopAdvertising];
}

//アドバタイズが開始されるとコールされる
-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    if(error){
        NSLog(@"BlePeripheral::Error Advertising:%@",[error localizedDescription]);
    }
    else{
        NSLog(@"BlePeripheral::Starting Advertising Successful");
    }
}

/*
 
 //ここはreadの値が変わるのが前提。
 //現在valueに最初からmyidをいれてるから、managerからreadされても、このイベントは発生しない
 //仕様的にだからいらないとおもう。
 
 
 
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
 */




@end
