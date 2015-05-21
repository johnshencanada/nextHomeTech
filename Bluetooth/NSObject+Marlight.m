//
//  SerialGATT+Marlight.m
//  Marlight
//
//  Created by 杨 烽 on 13-11-15.
//  Copyright (c) 2013年 cdy. All rights reserved.
//

#import "NSObject+Marlight.h"
#import "Bulb.h"
#import "KIBlueCentralManager.h"
#import "Marlight-Prefix.pch"

//#define SERIAL_PERIPHERAL_SERVICE_UUID      @"FFF0"
//#define SERIAL_PERIPHERAL_CHAR_RECV_UUID    @"FFF1"

#define SERVICE_UUID [CBUUID UUIDWithString:SERIAL_PERIPHERAL_SERVICE_UUID]
#define CHAR_UUID [CBUUID UUIDWithString:SERIAL_PERIPHERAL_CHAR_RECV_UUID]

@implementation NSObject (Marlight)

- (void)send:(BlueToothPacket *)packet toOne:(KIPeripheral *)one {
    BLEPacket p = packet.packet;
    NSMutableData *data = [NSMutableData dataWithBytes:&p length:sizeof(p)];
    
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
//    for(int i=0;i<len;i++) {
//        NSLog(@"packet [%d] is : 0x%x",i, byteData[i]);
//    }
    
    NSLog(@"0x%x, %d", byteData[8], byteData[8]);
    
    free(byteData);
    
//    [self write:one data:data];
    
//    [KIProgressView show:NO];
    [[KIBlueCentralManager sharedInstance] connect:one timeout:5 complete:^(KIBlueCentralManager *centralManager, KIPeripheral *peripheral, NSError *error) {
        if (error) {
            [KIProgressView dismiss];
            return ;
        }
        [one writeValue:data forCharacteristicUUID:CHAR_UUID forServiceUUID:SERVICE_UUID complete:^(KIPeripheral *peripheral, CBService *service, CBCharacteristic *characteristic, NSError *error) {
            [KIProgressView dismiss];
        }];
    }];
    
}

- (void)send:(BlueToothPacket *)packet toP:(NSArray *)pList {
    BLEPacket p = packet.packet;
    NSMutableData *data = [NSMutableData dataWithBytes:&p length:sizeof(p)];
    
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    //    for(int i=0;i<len;i++) {
    //        NSLog(@"packet [%d] is : 0x%x",i, byteData[i]);
    //    }
    
    NSLog(@"0x%x, %d", byteData[8], byteData[8]);
    
    free(byteData);
    
    for (Bulb *b in pList) {
        [b.peripheral writeValue:data
  forCharacteristicUUID:CHAR_UUID
         forServiceUUID:SERVICE_UUID
               complete:^(KIPeripheral *peripheral, CBService *service, CBCharacteristic *characteristic, NSError *error) {
               }];
    }
    
//    [[KIBlueCentralManager sharedInstance] connectWithPeripherls:items timeout:5 complete:^(KIBlueCentralManager *centralManager, KIPeripheral *peripheral, NSError *error, BOOL finished) {
//        [peripheral writeValue:data
//           forCharacteristicUUID:CHAR_UUID
//                  forServiceUUID:SERVICE_UUID
//                        complete:^(KIPeripheral *peripheral, CBService *service, CBCharacteristic *characteristic, NSError *error) {
//                        }];
//
//    }];
}

- (void)sendColorPacket:(BlueToothColorPacket *)packet toOne:(KIPeripheral *)one {
    BLEColorPacket p = packet.packet;
    NSMutableData *data = [NSMutableData dataWithBytes:&p length:sizeof(p)];
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    for(int i=0;i<len;i++) {
//        NSLog(@"packet [%d] is : 0x%x  %d",i, byteData[i], byteData[i]);
    }
    free(byteData);
    
    [[KIBlueCentralManager sharedInstance] connect:one timeout:5 complete:^(KIBlueCentralManager *centralManager, KIPeripheral *peripheral, NSError *error) {
        [one writeValue:data forCharacteristicUUID:CHAR_UUID forServiceUUID:SERVICE_UUID complete:^(KIPeripheral *peripheral, CBService *service, CBCharacteristic *characteristic, NSError *error) {
//            NSLog(@"==== %@--%@", service, characteristic);
        }];
    }];
}

- (void)sendColorPacket:(BlueToothColorPacket *)packet toP:(NSArray *)pList {
    BLEColorPacket p = packet.packet;
    NSMutableData *data = [NSMutableData dataWithBytes:&p length:sizeof(p)];
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    for(int i=0;i<len;i++) {
        NSLog(@"packet [%d] is : 0x%x  %d",i, byteData[i], byteData[i]);
    }
    free(byteData);
    
    for (Bulb *b in pList) {
        [b.peripheral writeValue:data
           forCharacteristicUUID:CHAR_UUID
                  forServiceUUID:SERVICE_UUID
                        complete:^(KIPeripheral *peripheral, CBService *service, CBCharacteristic *characteristic, NSError *error) {
                            
                        }];
    }
}

- (void)sendTimerPacket:(BlueToothTimerPacket *)packet toOne:(KIPeripheral *)one {
    BLETimerPacket p = packet.packet;
    NSMutableData *data = [NSMutableData dataWithBytes:&p length:sizeof(p)];
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    for(int i=0;i<len;i++) {
        NSLog(@"packet [%d] is : 0x%x  %d",i, byteData[i], byteData[i]);
    }
    free(byteData);
    
    [[KIBlueCentralManager sharedInstance] connect:one timeout:5 complete:^(KIBlueCentralManager *centralManager, KIPeripheral *peripheral, NSError *error) {
        [one writeValue:data forCharacteristicUUID:CHAR_UUID forServiceUUID:SERVICE_UUID complete:^(KIPeripheral *peripheral, CBService *service, CBCharacteristic *characteristic, NSError *error) {
            
        }];
    }];
}

- (void)sendTimerPacket:(BlueToothTimerPacket *)packet toP:(NSArray *)pList {
    BLETimerPacket p = packet.packet;
    NSMutableData *data = [NSMutableData dataWithBytes:&p length:sizeof(p)];
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    for(int i=0;i<len;i++) {
        NSLog(@"packet [%d] is : 0x%x  %d",i, byteData[i], byteData[i]);
    }
    free(byteData);
    
    for (Bulb *b in pList) {
        [b.peripheral writeValue:data
           forCharacteristicUUID:CHAR_UUID
                  forServiceUUID:SERVICE_UUID
                        complete:^(KIPeripheral *peripheral, CBService *service, CBCharacteristic *characteristic, NSError *error) {
                            
                        }];
    }
}

- (void)sendScenePacket:(BlueToothScenePacket *)packet toOne:(KIPeripheral *)one {
    BLEScenePacket p = packet.packet;
    NSMutableData *data = [NSMutableData dataWithBytes:&p length:sizeof(p)];
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    for(int i=0;i<len;i++) {
        NSLog(@"packet [%d] is : 0x%x  %d",i, byteData[i], byteData[i]);
    }
    free(byteData);
    
    [[KIBlueCentralManager sharedInstance] connect:one timeout:5 complete:^(KIBlueCentralManager *centralManager, KIPeripheral *peripheral, NSError *error) {
        [one writeValue:data forCharacteristicUUID:CHAR_UUID forServiceUUID:SERVICE_UUID complete:^(KIPeripheral *peripheral, CBService *service, CBCharacteristic *characteristic, NSError *error) {
            
        }];
    }];
}

- (void)sendScenePacket:(BlueToothScenePacket *)packet toP:(NSArray *)pList {
    BLEScenePacket p = packet.packet;
    NSMutableData *data = [NSMutableData dataWithBytes:&p length:sizeof(p)];
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    for(int i=0;i<len;i++) {
        NSLog(@"packet [%d] is : 0x%x  %d",i, byteData[i], byteData[i]);
    }
    free(byteData);
    
    for (Bulb *b in pList) {
        [b.peripheral writeValue:data
           forCharacteristicUUID:CHAR_UUID
                  forServiceUUID:SERVICE_UUID
                        complete:^(KIPeripheral *peripheral, CBService *service, CBCharacteristic *characteristic, NSError *error) {
                            
                        }];
    }
}
    

@end
