//
//  SerialGATT+Marlight.h
//  Marlight
//
//  Created by 杨 烽 on 13-11-15.
//  Copyright (c) 2013年 cdy. All rights reserved.
//

#import "BlueToothPacket.h"
#import "KIPeripheral.h"

@interface NSObject (Marlight)

- (void)send:(BlueToothPacket *)packet toOne:(KIPeripheral *)one;

- (void)send:(BlueToothPacket *)packet toP:(NSArray *)pList;

- (void)sendColorPacket:(BlueToothColorPacket *)packet toOne:(KIPeripheral *)one;

- (void)sendColorPacket:(BlueToothColorPacket *)packet toP:(NSArray *)pList;

- (void)sendTimerPacket:(BlueToothTimerPacket *)packet toOne:(KIPeripheral *)one;

- (void)sendTimerPacket:(BlueToothTimerPacket *)packet toP:(NSArray *)pList;

- (void)sendScenePacket:(BlueToothScenePacket *)packet toOne:(KIPeripheral *)one;

- (void)sendScenePacket:(BlueToothScenePacket *)packet toP:(NSArray *)pList;

@end
