//
//  Bulb.m
//  Marlight
//
//  Created by 杨 烽 on 13-11-16.
//  Copyright (c) 2013年 cdy. All rights reserved.
//

#import "Bulb.h"

#import "BulbManager.h"

@interface Bulb ()
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation Bulb

@synthesize uuid = _uuid;
@synthesize name = _name;
@synthesize type = _type;
@synthesize peripheral      = _peripheral;

@synthesize switchStatus    = _switchStatus;
@synthesize rgbMode         = _rgbMode;
@synthesize lightValue      = _lightValue;
@synthesize lightTmpValue   = _lightTmpValue;

@synthesize RGBLightValue   = _RGBLightValue;

@synthesize group       = _group;

@synthesize items       = _items;

@synthesize sendable    = _sendable;

@synthesize model       = _model;

@synthesize colorModel  = _colorModel;

- (id)init {
    if (self = [super init]) {
        self.type = DeviceTypeOfLightBulb;
        self.lightTmpValue = -11;
        self.lightValue = 2;
        self.RGBLightValue = 2;
        self.rgbMode = 0;
        [self setSendable:YES];
        self.switchStatus = YES;
    }
    return self;
}

- (void)updateSendable {
    if (self.sendable == NO) {
        return ;
    }
    [self setSendable:NO];
    int interval = 100;
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    if (self.timer) {
        dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, interval*NSEC_PER_MSEC), interval*NSEC_PER_MSEC, NSEC_PER_MSEC);
        dispatch_source_set_event_handler(self.timer, ^{
            [self setSendable:YES];
            dispatch_source_cancel(self.timer);
        });
        dispatch_resume(self.timer);
    }
}


- (NSString *)status {
    if (self.switchStatus) {
        return @"Off";
    }
    return @"On";
}

- (UIImage *)image {
    if (self.type == DeviceTypeOfLightBulb) {
        return [UIImage imageNamed:@"lightbulb.png"];
    } else if (self.type == DeviceTypeOfHeadset) {
        return [UIImage imageNamed:@"headset.png"];
    } else if (self.type == DeviceTypeOfSoundbox) {
        return [UIImage imageNamed:@"soundbox.png"];
    } else if (self.type == DeviceTypeOfGroup) {
        return [UIImage imageNamed:@"group.png"];
    } else if (self.type == DeviceTypeOfLedeStrip) {
        return [UIImage imageNamed:@"lightbelt.png"];
    } else if (self.type == DeviceTypeOfLampHolder) {
        return [UIImage imageNamed:@"lightholder.png"];
    } else if (self.type == DeviceTypeOfOutlet){
        return [UIImage imageNamed:@"switch.png"];
    }
    return [UIImage imageNamed:@"lightbulb.png"];
}

- (UIImage *)highlightImage {
    if (self.type == DeviceTypeOfLightBulb) {
        return [UIImage imageNamed:@"lightbulb_hl.png"];
    } else if (self.type == DeviceTypeOfHeadset) {
        return [UIImage imageNamed:@"headset_hl.png"];
    } else if (self.type == DeviceTypeOfSoundbox) {
        return [UIImage imageNamed:@"soundbox_hl.png"];
    } else if (self.type == DeviceTypeOfGroup) {
        return [UIImage imageNamed:@"group_hl.png"];
    } else if (self.type == DeviceTypeOfLedeStrip) {
        return [UIImage imageNamed:@"lightbelt_hl.png"];
    } else if (self.type == DeviceTypeOfLampHolder) {
        return [UIImage imageNamed:@"lightholder_hl.png"];
    } else if (self.type == DeviceTypeOfOutlet){
        return [UIImage imageNamed:@"switchOn.png"];
    }
    return [UIImage imageNamed:@"lightbulb_hl.png"];
}

- (void)turnOn {
    BlueToothPacket *packet = [[BlueToothPacket alloc] init];
    [packet setGroud:self.group];
    [packet turnOn];
    self.switchStatus = YES;
    [self send:packet];
    if (self.type == DeviceTypeOfGroup) {
        [[BulbManager sharedInstance] updateGroupPowerStatus:self.switchStatus forGroupName:self.name];
    }
}

- (void)turnOff {
    BlueToothPacket *packet = [[BlueToothPacket alloc] init];
    [packet setGroud:self.group];
    [packet turnOff];
    self.switchStatus = NO;
    [self send:packet];
    
    if (self.type == DeviceTypeOfGroup) {
        [[BulbManager sharedInstance] updateGroupPowerStatus:self.switchStatus forGroupName:self.name];
    }
}

- (void)switchLight {
    BlueToothPacket *packet = [[BlueToothPacket alloc] init];
    [packet setGroud:self.group];
    if (self.switchStatus) {
        [packet turnOff];
    } else {
        [packet turnOn];
    }
    [self send:packet];
    
    self.switchStatus = !self.switchStatus;
    
    if (self.type == DeviceTypeOfGroup) {
        [[BulbManager sharedInstance] updateGroupPowerStatus:self.switchStatus forGroupName:self.name];
    }
}

- (void)lightIncrease {
    BlueToothPacket *packet = [[BlueToothPacket alloc] init];
    [packet setGroud:self.group];
    [packet lightIncrease];
    [self send:packet];
    if (self.lightValue < 11) {
        self.lightValue++;
        [[BulbManager sharedInstance] setBrigtness:self.lightValue forUUID:self.uuid];
    }
}

- (void)lightDecrease {
    BlueToothPacket *packet = [[BlueToothPacket alloc] init];
    [packet setGroud:self.group];
    [packet lightDecrease];
    [self send:packet];
    if (self.lightValue > 2) {
        self.lightValue--;
        [[BulbManager sharedInstance] setBrigtness:self.lightValue forUUID:self.uuid];
    }
}
//增加亮度
- (void)RGBLightIncrease {
    BlueToothPacket *packet = [[BlueToothPacket alloc] init];
    [packet setGroud:self.group];
    [packet lightIncrease];
    [self send:packet];
    if (self.RGBLightValue < 11) {
        self.RGBLightValue++;
        [[BulbManager sharedInstance] setRGBBrigtness:self.RGBLightValue forUUID:self.uuid];
    }
}
//减少亮度
- (void)RGBLightDecrease {
    BlueToothPacket *packet = [[BlueToothPacket alloc] init];
    [packet setGroud:self.group];
    [packet lightDecrease];
    [self send:packet];
    if (self.RGBLightValue > 2) {
        self.RGBLightValue--;
        [[BulbManager sharedInstance] setRGBBrigtness:self.RGBLightValue forUUID:self.uuid];
    }
}

- (void)lightTmpIncrease {
    BlueToothPacket *packet = [[BlueToothPacket alloc] init];
    [packet setGroud:self.group];
    [packet lightTmpIncrease];
    [self send:packet];
    self.lightTmpValue = MIN(-2, self.lightTmpValue);
    if (self.lightTmpValue > -11) {
        self.lightTmpValue--;
        [[BulbManager sharedInstance] setCCT:self.lightTmpValue forUUID:self.uuid];
    }
}

- (void)lightTmpDecrease {
    BlueToothPacket *packet = [[BlueToothPacket alloc] init];
    [packet setGroud:self.group];
    [packet lightTmpDecrease];
    [self send:packet];
    if (self.lightTmpValue >= 0) {
        self.lightTmpValue *= -1;
    }
    self.lightTmpValue = MAX(-11, self.lightTmpValue);
    if (self.lightTmpValue < -2) {
        self.lightTmpValue++;
        [[BulbManager sharedInstance] setCCT:self.lightTmpValue forUUID:self.uuid];
    }
}

- (void)updateLightValue:(unsigned char)value {
    if (self.lightValue != value) {
        BlueToothPacket *packet = [[BlueToothPacket alloc] init];
        [packet setGroud:self.group];
        [packet updateLightValue:value];
        [self send:packet];
        self.lightValue = value;
        
        [[BulbManager sharedInstance] setBrigtness:self.lightValue forUUID:self.uuid];
    }
}

- (void)updateRGBLightValue:(unsigned char)value {
    if (self.RGBLightValue != value) {
        BlueToothPacket *packet = [[BlueToothPacket alloc] init];
        [packet setGroud:self.group];
        [packet updateLightValue:value];
        [self send:packet];
        self.RGBLightValue = value;
        
        [[BulbManager sharedInstance] setRGBBrigtness:self.RGBLightValue forUUID:self.uuid];
    }
}

- (void)updateLightTmpValue:(int)value {
    if (self.lightTmpValue != value) {
        BlueToothPacket *packet = [[BlueToothPacket alloc] init];
        [packet setGroud:self.group];
        value = ABS(value);
        [packet updateLightTmpValue:value];
        [self send:packet];
        self.lightTmpValue = value;
        
        [[BulbManager sharedInstance] setCCT:-self.lightTmpValue forUUID:self.uuid];
    }
}

- (void)RGBModeIncrease {
    self.rgbMode++;
    if (self.rgbMode > 12) {
        self.rgbMode = 1;
    }
    
//    if (self.rgbMode <= 7) {
//        self.isUpdateCircleImageView = YES;
//    }
//    else
//    {
//        self.isUpdateCircleImageView = NO;
//    }
    
    BlueToothPacket *packet = [[BlueToothPacket alloc] init];
    [packet setGroud:self.group];
    [packet updateRGBMode:self.rgbMode];
    [self send:packet];
}

- (void)RGBModeDecrease {
    self.rgbMode--;
    if (self.rgbMode < 1) {
        self.rgbMode = 12;
    }
    
//    if (self.rgbMode <= 7) {
//        self.isUpdateCircleImageView = YES;
//    }
//    else
//    {
//        self.isUpdateCircleImageView = NO;
//    }
    
    BlueToothPacket *packet = [[BlueToothPacket alloc] init];
    [packet setGroud:self.group];
    [packet updateRGBMode:self.rgbMode];
    [self send:packet];
}

- (void)updateRGBMode:(int)mode {
    self.rgbMode = mode;
    
    BlueToothPacket *packet = [[BlueToothPacket alloc] init];
    [packet setGroud:self.group];
    [packet updateRGBMode:self.rgbMode];
    [self send:packet];
}

- (void)setR:(unsigned char)r
           g:(unsigned char)g
           b:(unsigned char)b {
    [self setModel:DeviceModelOfRGB];
    
    if (r != 0x80 && g != 0x80 && b != 0x80) {
        [self setRed:r];
        [self setGreen:g];
        [self setBlue:b];
        
        [[BulbManager sharedInstance] setR:r g:g b:b forUUID:self.uuid];
    }
    
    BlueToothColorPacket *packet = [[BlueToothColorPacket alloc] init];
    [packet setGroud:self.group];
    [packet setR:r g:g b:b];
    [self sendColor:packet];
}

- (void)setC:(unsigned char)c
           w:(unsigned char)w {
    [self setModel:DeviceModelOfWhite];
    BlueToothColorPacket *packet = [[BlueToothColorPacket alloc] init];
    [packet setGroud:self.group];
    [packet setC:c w:w];
    [self sendColor:packet];
}


- (void)send:(BlueToothPacket *)packet {
    [packet setGroud:self.group];
    if (packet.packet.CMD != BLEPacketRGBCMD) {
        self.rgbMode = 0;
    }
    if (self.type == DeviceTypeOfGroup) {
        [self send:packet toP:self.items];
    } else {
//        if (self.sendable) {
            [self updateSendable];
            [self send:packet toOne:self.peripheral];
//        }
    }
}

- (void)sendColor:(BlueToothColorPacket *)packet {
    [packet setGroud:self.group];
    if (packet.packet.CMD != BLEPacketRGBCMD) {
        self.rgbMode = 0;
    }
    
    if (self.type == DeviceTypeOfGroup) {
        [self sendColorPacket:packet toP:self.items];
    } else {
        if (self.sendable && self.switchStatus) {
            [self updateSendable];
            [self sendColorPacket:packet toOne:self.peripheral];
        }
    }
}

- (void)setTimerOn:(unsigned char)hour minute:(unsigned char)minute {
    BlueToothTimerPacket *packet = [[BlueToothTimerPacket alloc] init];
    [packet setGroud:self.group];
    [packet setTimerOn:hour minute:minute];
    if (packet.packet.CMD != BLEPacketRGBCMD) {
        self.rgbMode = 0;
    }
    
    if (self.type == DeviceTypeOfGroup) {
        [self sendTimerPacket:packet toP:self.items];
    } else {
//        if (self.sendable) {
            [self updateSendable];
            [self sendTimerPacket:packet toOne:self.peripheral];
//        }
    }
}

- (void)setTimerOff:(unsigned char)hour minute:(unsigned char)minute {
    BlueToothTimerPacket *packet = [[BlueToothTimerPacket alloc] init];
    [packet setGroud:self.group];
    [packet setTimerOff:hour minute:minute];
    if (packet.packet.CMD != BLEPacketRGBCMD) {
        self.rgbMode = 0;
    }
    if (self.type == DeviceTypeOfGroup) {
        [self sendTimerPacket:packet toP:self.items];
    } else {
//        if (self.sendable) {
            [self updateSendable];
            [self sendTimerPacket:packet toOne:self.peripheral];
//        }
    }
}

- (void)setWakeUp:(unsigned char)hour minute:(unsigned char)minute {
    BlueToothTimerPacket *packet = [[BlueToothTimerPacket alloc] init];
    [packet setGroud:self.group];
    [packet setWakeUp:hour minute:minute];
    if (packet.packet.CMD != BLEPacketRGBCMD) {
        self.rgbMode = 0;
    }
    if (self.type == DeviceTypeOfGroup) {
        [self sendTimerPacket:packet toP:self.items];
    } else {
        if (self.sendable) {
            [self updateSendable];
            [self sendTimerPacket:packet toOne:self.peripheral];
        }
    }
}

- (void)setNight {
    BlueToothScenePacket *packet = [[BlueToothScenePacket alloc] init];
    [packet setGroud:self.group];
    [packet setNight];
    if (packet.packet.CMD != BLEPacketRGBCMD) {
        self.rgbMode = 0;
    }
    if (self.type == DeviceTypeOfGroup) {
        [self sendScenePacket:packet toP:self.items];
    } else {
        if (self.sendable) {
            [self updateSendable];
            [self sendScenePacket:packet toOne:self.peripheral];
        }
    }
}

- (void)setSleep {
    BlueToothScenePacket *packet = [[BlueToothScenePacket alloc] init];
    [packet setGroud:self.group];
    [packet setSleep];
    if (packet.packet.CMD != BLEPacketRGBCMD) {
        self.rgbMode = 0;
    }
    if (self.type == DeviceTypeOfGroup) {
        [self sendScenePacket:packet toP:self.items];
    } else {
        if (self.sendable) {
            [self updateSendable];
            [self sendScenePacket:packet toOne:self.peripheral];
        }
    }
}

- (void)setRecreation {
    BlueToothScenePacket *packet = [[BlueToothScenePacket alloc] init];
    [packet setGroud:self.group];
    [packet setRecreation];
    if (packet.packet.CMD != BLEPacketRGBCMD) {
        self.rgbMode = 0;
    }
    if (self.type == DeviceTypeOfGroup) {
        [self sendScenePacket:packet toP:self.items];
    } else {
        if (self.sendable) {
            [self updateSendable];
            [self sendScenePacket:packet toOne:self.peripheral];
        }
    }
}

@end
