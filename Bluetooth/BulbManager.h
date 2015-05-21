//
//  BulbManager.h
//  Marlight
//
//  Created by 杨 烽 on 13-11-16.
//  Copyright (c) 2013年 cdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bulb.h"
#import "KIPeripheral.h"

@interface BulbManager : NSObject {
    NSMutableDictionary *_bulbList;
    NSMutableDictionary *_bulbInfoList;
    
    NSMutableDictionary *_bulbAndGroupList;
    NSMutableDictionary *_groupInfoList;
    
    NSMutableDictionary *_groupPowerStatus;
}

+ (BulbManager *)sharedInstance;

- (NSArray *)bulbListWithPeripherals:(NSArray *)peripherals;

- (NSArray *)bulbList;

- (void)clean;

- (Bulb *)bulbWithUUID:(NSString *)uuid;

- (void)updateUUID:(NSString *)newUUID oldUUID:(NSString *)oldUUID;

- (Bulb *)bulbWithPeripheral:(KIPeripheral *)peripheral;

- (void)removeBulb:(Bulb *)bulb;

- (void)setName:(NSString *)name forUUID:(NSString *)uuid;

- (void)setType:(int)type forUUID:(NSString *)uuid;

- (void)setCCT:(int)cct forUUID:(NSString *)uuid;

- (void)setBrigtness:(int)brigtness forUUID:(NSString *)uuid;

- (void)setR:(int)r g:(int)g b:(int)b forUUID:(NSString *)uuid;

- (void)setRGBBrigtness:(int)brigtness forUUID:(NSString *)uuid;

- (void)updateGroupName:(NSString *)name withOld:(NSString *)oldName;

- (void)addGroup:(NSString *)name;

- (void)deleteGroup:(NSString *)name;

- (void)addBulb:(Bulb *)bulb toGroup:(NSString *)name;

- (void)removeBulb:(Bulb *)bulb fromGroup:(NSString *)name;

- (NSArray *)groupNameList;

- (void)updateGroupPowerStatus:(BOOL)status forGroupName:(NSString *)name;

- (NSArray *)bulbAndGroupListWithPeripherals:(NSArray *)peripherals;

- (void)synch;

@end
