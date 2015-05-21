//
//  BulbManager.m
//  Marlight
//
//  Created by 杨 烽 on 13-11-16.
//  Copyright (c) 2013年 cdy. All rights reserved.
//

#import "BulbManager.h"
#import "NSString+KIAdditions.h"

#define kName @"name"
#define kType @"type"
#define kBrigtness @"brigtness"
#define kRGBBrigtness @"kRGBBrigtness"
#define kRed @"red"
#define kGreen @"green"
#define kBlue @"blue"
#define kCCT @"cct"

@implementation BulbManager

+ (BulbManager *)sharedInstance {
    static BulbManager *BULB_MANAGER = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BULB_MANAGER = [[BulbManager alloc] init];
    });
    return BULB_MANAGER;
}

- (id)init {
    if (self = [super init]) {
        _bulbList = [[NSMutableDictionary alloc] init];
        _bulbAndGroupList = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSArray *)bulbListWithPeripherals:(NSArray *)peripherals {
    [_bulbList removeAllObjects];
    
    static NSArray *devices = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        devices = @[@"Tint B7"
                    ,@"Tint_B7"
                    ,@"Tint B7C"
                    ,@"Tint B7W"
                    ,@"Tint B7S"
                    ,@"Tint B9"
                    ,@"Tint_B9"
                    ,@"Tint B9C"
                    ,@"Tint B9W"
                    ,@"Tint B9S"
                    ,@"SML-c9"
                    ,@"SML-w7"
                    ,@"ledergb"
                    ,@"BeeWi SmartLite"
                    ,@"Strip_RGBC"
                    ,@"Strip S20"
                    ,@"S1"
                    ,@"Tint S2"
                    ,@"B710"
                    ,@"B720"
                    ,@"B730"
                    ,@"B910"
                    ,@"B930"
                    ,@"Strip B20"
                    ,@"K4"
                    ,@"P9"
                    ,@"H1"
                    ,@"B530"
                    ,@"SO-1"];
    });
    
    for (KIPeripheral *p in peripherals) {
        NSString *uuid = [p UUIDString];
        NSString *name = [p name];
        
        if (![devices containsObject:name]) {
            continue;
        }
    
        Bulb *bulb = [[Bulb alloc] init];
        [bulb setPeripheral:p];
        
        int type = DeviceTypeOfLightBulb;
        if ([name isEqualToString:@"Strip_RGBC"]
            || [name isEqualToString:@"Strip B20"]
            || [name isEqualToString:@"Strip S20"]
            || [name isEqualToString:@"S1"]) {
            type = DeviceTypeOfLedeStrip;
        } else if ([name isEqualToString:@"P9"]) {
            type = DeviceTypeOfSoundbox;
        } else if ([name isEqualToString:@"H1"]) {
            type = DeviceTypeOfLampHolder;
        }else if ([name isEqualToString:@"SO-1"]){
            type = DeviceTypeOfOutlet;
        }
        
        int colorModel = DeviceColorModelOfRGBCW;
        if ([name isEqualToString:@"Tint B7"]
            ||[name isEqualToString:@"Tint B9"]
            ||[name isEqualToString:@"SML-c9"]
            ||[name isEqualToString:@"ledergb"]
            ||[name isEqualToString:@"BeeWi SmartLite"]
            ||[name isEqualToString:@"Tint_B9"]
            ||[name isEqualToString:@"B710"]
            ||[name isEqualToString:@"B720"]
            ||[name isEqualToString:@"B730"]
            ||[name isEqualToString:@"B910"]
            ||[name isEqualToString:@"B930"]
            ||[name isEqualToString:@"B530"]) {
            colorModel = DeviceColorModelOfRGBCW;
        } else if ([name isEqualToString:@"Tint B7S"]
                   ||[name isEqualToString:@"Tint B9S"]
                   ||[name isEqualToString:@"SML-w7"]
                   ||[name isEqualToString:@"Tint_B7"]) {
            colorModel = DeviceColorModelOfCW;
        } else if ([name isEqualToString:@"Tint B7W"]
                   ||[name isEqualToString:@"Tint B9W"]
                   ||[name isEqualToString:@"K4"]
                   ||[name isEqualToString:@"P9"]) {
            colorModel = DeviceColorModelOfRGBW;
        } else if ([name isEqualToString:@"Tint B7C"]
                   ||[name isEqualToString:@"Tint B9C"]
                   ||[name isEqualToString:@"Strip_RGBC"]
                   ||[name isEqualToString:@"Strip B20"]
                   || [name isEqualToString:@"Strip S20"]
                   || [name isEqualToString:@"S1"]) {
            colorModel = DeviceColorModelOfRGBC;
        } else if ([name isEqualToString:@"H1"]) {
            colorModel = DeviceColorModelOfLampHolder;
        }
        
//        int cct = 0;
//        int brightness = 0;
//        int rgbBrightness = 0;
        
        if (uuid == nil) {
            uuid = [NSString stringWithFormat:@"%d", [p hash]];
        }
        
        if (uuid) {
            NSDictionary *info = [[self bulbInfoList] objectForKey:uuid];
            if (info) {
                NSString *tempName = [info objectForKey:kName];
                if (tempName && tempName.length > 0) {
                    name = [info objectForKey:kName];
                }
//                type = [[info objectForKey:kType] integerValue];
//                if (type == 0) {
//                    type = DeviceTypeOfLightBulb;
//                }
//                cct = [[info objectForKey:kCCT] integerValue];
//                brightness = [[info objectForKey:kBrigtness] integerValue];
//                rgbBrightness = [[info objectForKey:kRGBBrigtness] integerValue];
            }
            
            [bulb setUuid:uuid];
            [bulb setName:name];
            [bulb setType:type];
            [bulb setColorModel:colorModel];
//            [bulb setLightTmpValue:cct];
//            [bulb setLightValue:brightness];
//            [bulb setRGBLightValue:rgbBrightness];
            
            [_bulbList setObject:bulb forKey:uuid];
        }
    }
    return [_bulbList allValues];
}

- (NSArray *)bulbList {
    return [_bulbList allValues];;
}

- (void)clean {
    [_bulbAndGroupList removeAllObjects];
    [_bulbList removeAllObjects];
}

- (Bulb *)bulbWithUUID:(NSString *)uuid {
    return [_bulbList objectForKey:uuid];
}

- (void)updateUUID:(NSString *)newUUID oldUUID:(NSString *)oldUUID {
    Bulb *b = [self bulbWithUUID:oldUUID];
    [_bulbList removeObjectForKey:oldUUID];
    if (b && newUUID) {
        [b setUuid:newUUID];
        [_bulbList setObject:b forKey:newUUID];
    }
}

- (Bulb *)bulbWithPeripheral:(KIPeripheral *)p {
    for (Bulb *b in [_bulbList allValues]) {
        if (b.peripheral == p) {
            return b;
        }
    }
    @try {
        if (p == nil) {
            return nil;
        }
        NSString *uuid = [p UUIDString];
        if (uuid && uuid.length <= 0) {
            return nil;
        }
        NSString *name = [p name];
        
        Bulb *bulb = [[Bulb alloc] init];
        [bulb setPeripheral:p];
        
        int type = DeviceTypeOfLightBulb;
        int cct = -11;
        int brightness = 0;
        int rgbBrightness = 0;
        
        int red = 0;
        int green = 0;
        int blue = 0;
        
        NSDictionary *info = [[self bulbInfoList] objectForKey:uuid];
        if (info) {
            name = [info objectForKey:kName];
            type = [[info objectForKey:kType] integerValue];
            if (type == 0) {
                type = DeviceTypeOfLightBulb;
            }
            cct = [[info objectForKey:kCCT] integerValue];
            brightness = [[info objectForKey:kBrigtness] integerValue];
            rgbBrightness = [[info objectForKey:kRGBBrigtness] integerValue];
            
            red = [[info objectForKey:kRed] intValue];
            green = [[info objectForKey:kGreen] intValue];
            blue = [[info objectForKey:kBlue] intValue];
        }
        
//        if (name == nil || name.length <=0) {
//            name = @"Unknow";
//        }
        
        [bulb setUuid:uuid];
        if (name) {
            [bulb setName:name];
        }
        [bulb setType:type];
        [bulb setLightTmpValue:cct];
        [bulb setLightValue:brightness];
        [bulb setRGBLightValue:rgbBrightness];
        
        [bulb setRed:red];
        [bulb setGreen:green];
        [bulb setBlue:blue];
        
        [_bulbList setObject:bulb forKey:uuid];
        return bulb;

    }
    @catch (NSException *exception) {
//        [KITipsView showMessage:exception.description];
    }
    @finally {
        
    }
    return nil;
}

- (void)removeBulb:(Bulb *)bulb {
    for (NSString *key in [_bulbList allKeys]) {
        if ([_bulbList objectForKey:key] == bulb) {
            [_bulbList removeObjectForKey:key];
            break;
        }
    }
}

- (void)setName:(NSString *)name forUUID:(NSString *)uuid {
    NSMutableDictionary *item = [self bulbForUUID:uuid];
    
    Bulb *bulb = [self bulbWithUUID:uuid];
    
    if (bulb) {
        if (name && name.length > 0) {
            [bulb setName:name];
            [item setObject:name forKey:kName];
        }
        if (item && uuid) {
            [[self bulbInfoList] setObject:item forKey:uuid];
        }
        [self synch];
    }
}

- (void)setType:(int)type forUUID:(NSString *)uuid {
    NSMutableDictionary *item = [self bulbForUUID:uuid];
    
    Bulb *bulb = [self bulbWithUUID:uuid];
    [bulb setType:type];
    
    [item setObject:[NSNumber numberWithInt:type] forKey:kType];
    if (item && uuid) {
        [[self bulbInfoList] setObject:item forKey:uuid];
    }
    [self synch];
}

- (void)setCCT:(int)cct forUUID:(NSString *)uuid {
    NSMutableDictionary *item = [self bulbForUUID:uuid];
    
    Bulb *bulb = [self bulbWithUUID:uuid];
    
    [bulb setLightTmpValue:cct];
    
//    if (bulb && bulb.type != DeviceTypeOfGroup) {
        [item setObject:[NSNumber numberWithInt:cct] forKey:kCCT];
        if (item && uuid) {
            [[self bulbInfoList] setObject:item forKey:uuid];
        }
//    }
    
    [self synch];
}

- (void)setBrigtness:(int)brigtness forUUID:(NSString *)uuid {
    NSMutableDictionary *item = [self bulbForUUID:uuid];
    
    Bulb *bulb = [self bulbWithUUID:uuid];
    [bulb setLightValue:brigtness];
//    if (bulb && bulb.type != DeviceTypeOfGroup) {
        [item setObject:[NSNumber numberWithInt:brigtness] forKey:kBrigtness];
        if (item && uuid) {
            [[self bulbInfoList] setObject:item forKey:uuid];
        }
//    }
    [self synch];
}

- (void)setR:(int)r g:(int)g b:(int)b forUUID:(NSString *)uuid {
    NSMutableDictionary *item = [self bulbForUUID:uuid];
    
    [item setObject:@(r) forKey:kRed];
    [item setObject:@(g) forKey:kGreen];
    [item setObject:@(b) forKey:kGreen];
    
    if (item && uuid) {
        [[self bulbInfoList] setObject:item forKey:uuid];
    }
    
    [self synch];
}

- (void)setRGBBrigtness:(int)brigtness forUUID:(NSString *)uuid {
    NSMutableDictionary *item = [self bulbForUUID:uuid];
    
    Bulb *bulb = [self bulbWithUUID:uuid];
    [bulb setRGBLightValue:brigtness];
//    if (bulb && bulb.type != DeviceTypeOfGroup) {
        [item setObject:[NSNumber numberWithInt:brigtness] forKey:kRGBBrigtness];
        if (item && uuid) {
            [[self bulbInfoList] setObject:item forKey:uuid];
        }
//    }
    [self synch];
}

- (NSString *)filePath {
    static NSString *path = nil;
    if (path == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"bulb.plist"];
    }
    return path;
}

- (NSMutableDictionary *)bulbInfoList {
    if (_bulbInfoList == nil) {
        _bulbInfoList = [[NSMutableDictionary alloc] initWithContentsOfFile:[self filePath]];
        if (_bulbInfoList == nil) {
            _bulbInfoList = [[NSMutableDictionary alloc] init];
        }
    }
    return _bulbInfoList;
}

- (NSMutableDictionary *)bulbForUUID:(NSString *)uuid {
    NSMutableDictionary *item = [[self bulbInfoList] objectForKey:uuid];
    if (item == nil) {
        item = [[NSMutableDictionary alloc] init];
    }
    return item;
}

- (void)updateGroupName:(NSString *)name withOld:(NSString *)oldName {
    if (name == nil) {
        return ;
    }
    NSMutableArray *items = [[self groupInfoList] objectForKey:oldName];
    if (items == nil) {
        items = [[NSMutableArray alloc] init];
    }
    [[self groupInfoList] setObject:items forKey:name];
    
    [[self groupInfoList] removeObjectForKey:oldName];
    
    [self synch];
}

- (void)addGroup:(NSString *)name {
    if (name == nil) {
        return ;
    }
    [[self groupInfoList] setObject:[[NSMutableArray alloc] init]
                             forKey:name];
    [self synch];
}

- (void)deleteGroup:(NSString *)name {
    [[self groupInfoList] removeObjectForKey:name];
    [self synch];
}

- (void)addBulb:(Bulb *)bulb toGroup:(NSString *)name {
    if (bulb.uuid && bulb.uuid.length > 0 && name && name.length > 0) {
        NSMutableArray *items = [self groupItems:name];
        if (items == nil) {
            items = [[NSMutableArray alloc] init];
        }
        [items addObject:bulb.uuid];
        if (items != nil && name != nil) {
            [[self groupInfoList] setObject:items forKey:name];
        }
        [self synch];
    }
}

- (void)removeBulb:(Bulb *)bulb fromGroup:(NSString *)name {
    if (bulb.uuid && bulb.uuid.length > 0 && name && name.length > 0) {
        NSMutableArray *items = [self groupItems:name];
        if (items != nil && name != nil) {
            [items removeObject:bulb.uuid];
            [[self groupInfoList] setObject:items forKey:name];
            [self synch];
        }
    }
}

- (NSArray *)groupNameList {
    return [[self groupInfoList] allKeys];
}

- (NSMutableDictionary *)groupPowerStatus {
    if (_groupPowerStatus == nil) {
        _groupPowerStatus = [[NSMutableDictionary alloc] init];
    }
    return _groupPowerStatus;
}

- (void)updateGroupPowerStatus:(BOOL)status forGroupName:(NSString *)name {
    if (name == nil) {
        return ;
    }
    [[self groupPowerStatus] setObject:[NSNumber numberWithBool:status] forKey:name];
}

- (NSArray *)bulbAndGroupListWithPeripherals:(NSArray *)peripherals {
    [_bulbAndGroupList removeAllObjects];
    for (NSString *name in [[self groupInfoList] allKeys]) {
        Bulb *b = [[Bulb alloc] init];
        [b setName:name];
        [b setType:DeviceTypeOfGroup];
        
        //判断外设是否智能插座产品
        if ([name isEqualToString:@"SO-1"]) {
            [b setType:DeviceTypeOfOutlet];
        }
        
        b.items = [[NSMutableArray alloc] init];
        [_bulbAndGroupList setObject:b forKey:name];
        b.uuid = b.name;
        
        int cct = -11;
        int brightness = 0;
        int rgbBrightness = 0;
        
        BOOL power = [[[self groupPowerStatus] objectForKey:name] boolValue];
        
        NSDictionary *info = [[self bulbInfoList] objectForKey:b.uuid];
        if (info) {
            cct = [[info objectForKey:kCCT] integerValue];
            brightness = [[info objectForKey:kBrigtness] integerValue];
            rgbBrightness = [[info objectForKey:kRGBBrigtness] integerValue];
        }
        [b setSwitchStatus:power];
//        [b setLightTmpValue:cct];
//        [b setLightValue:brightness];
//        [b setRGBLightValue:rgbBrightness];
    }
    
    [self bulbListWithPeripherals:peripherals];
    
    NSMutableDictionary *bulbList = [[NSMutableDictionary alloc] initWithDictionary:_bulbList];
    NSArray *groupNameList = [[self groupInfoList] allKeys];
    
    for (NSString *name in groupNameList) {
        NSArray *uuids = [[self groupInfoList] objectForKey:name];
        for (NSString *uuid in uuids) {
            Bulb *b = [bulbList objectForKey:uuid];
            if (b) {
                Bulb *g = [_bulbAndGroupList objectForKey:name];
                if (g == nil) {
                    g = [[Bulb alloc] init];
                    [g setType:DeviceTypeOfGroup];
                }
                NSMutableArray *items = [g items];
                if (items == nil) {
                    items = [[NSMutableArray alloc] init];
                }
                
                [items addObject:b];
                
                [g setItems:items];
                
                [_bulbAndGroupList setObject:g forKey:name];
                
                [bulbList removeObjectForKey:b.uuid];
            }
        }
    }
    
    [_bulbAndGroupList addEntriesFromDictionary:bulbList];
    
    return [_bulbAndGroupList allValues];
}

- (NSString *)groupFilePath {
    static NSString *path = nil;
    if (path == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"group.plist"];
    }
    return path;
}

- (NSMutableArray *)groupItems:(NSString *)name {
    if (name == nil && name.length <= 0) {
        return nil;
    }
    NSMutableArray *items = [[self groupInfoList] objectForKey:name];
    return items;
}

- (NSMutableDictionary *)groupInfoList {
    if (_groupInfoList == nil) {
        _groupInfoList = [[NSMutableDictionary alloc] initWithContentsOfFile:[self groupFilePath]];
        if (_groupInfoList == nil) {
            _groupInfoList = [[NSMutableDictionary alloc] init];
        }
    }
    return _groupInfoList;
}

- (void)synch {
    [[self bulbInfoList] writeToFile:[self filePath] atomically:YES];
    [[self groupInfoList] writeToFile:[self groupFilePath] atomically:YES];
}

@end
