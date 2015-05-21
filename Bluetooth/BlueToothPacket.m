//
//  BlueToothPacket.m
//  Marlight
//
//  Created by 杨 烽 on 13-11-15.
//  Copyright (c) 2013年 cdy. All rights reserved.
//

#import "BlueToothPacket.h"

@implementation BlueToothPacket
@synthesize packet = _packet;

- (id)init {
    if (self = [super init]) {
        _packet.Head = 0xAA;
        _packet.Type = 0x0A;
        _packet.ID[0] = 0Xfc;
        _packet.ID[1] = 0X3a;
        _packet.ID[2] = 0X86;
        _packet.Group = 0x01;
        _packet.Length = 0x01;
        srand((int)time(0));
        _packet.RVar = random();
        _packet.Stop = 0x0d;
        [self updateCheckSum];
    }
    return self;
}

- (void)setCMD:(unsigned char)cmd {
    _packet.CMD = cmd;
    if (_packet.CMD != BLEPacketRGBCMD) {
    }
    [self updateCheckSum];
}

- (void)setGroud:(unsigned char)groud {
    _packet.Group = groud;
    [self updateCheckSum];
}

- (void)setData:(unsigned char)data {
    _packet.DATA[0] = data;
    [self updateCheckSum];
}

- (void)updateCheckSum {
    _packet.CheckSum = _packet.Type
                    + _packet.ID[0] + _packet.ID[1] + _packet.ID[2]
                    + _packet.Group
                    + _packet.CMD
                    + _packet.Length
                    + _packet.DATA[0]
                    + _packet.RVar + 0x55;
}

- (void)turnOn {
    [self setCMD:BLEPacketSwitchCMD];
    [self setData:kBLEDataTurnOn];
}

- (void)turnOff {
    [self setCMD:BLEPacketSwitchCMD];
    [self setData:kBLEDataTurnOff];
}

- (void)updateRGBMode:(unsigned char)mode {
    [self setCMD:BLEPacketRGBCMD];
    [self setData:mode];
}

- (void)lightIncrease {
    [self setCMD:BLEPacketLightCMD];
    [self setData:kBLEDataLightIncrease];
}

- (void)lightDecrease {
    [self setCMD:BLEPacketLightCMD];
    [self setData:kBLEDataLightDecrease];
}

- (void)lightTmpIncrease {
    [self setCMD:BLEPacketLightTmpCMD];
    [self setData:kBLEDataLightTmpIncrease];
}

- (void)lightTmpDecrease {
    [self setCMD:BLEPacketLightTmpCMD];
    [self setData:kBLEDataLightTmpDecrease];
}

- (void)updateLightValue:(unsigned char)value {
    [self setCMD:BLEPacketLightCMD];
    [self setData:value];
}

- (void)updateLightTmpValue:(unsigned char)value {
    [self setCMD:BLEPacketLightTmpCMD];
    [self setData:value];
}

@end

@implementation BlueToothColorPacket

- (id)init {
    if (self = [super init]) {
        _packet.Head = 0xAA;
        _packet.Type = 0x0A;
        _packet.ID[0] = 0Xfc;
        _packet.ID[1] = 0X3a;
        _packet.ID[2] = 0X86;
        _packet.Group = 0x01;
        _packet.Length = 0x06;
        srand((int)time(0));
        _packet.RVar = random();
        _packet.Stop = 0x0d;
        [self updateCheckSum];
    }
    return self;
}

- (void)setCMD:(unsigned char)cmd {
    _packet.CMD = cmd;
    if (_packet.CMD != BLEPacketRGBCMD) {
    }
    [self updateCheckSum];
}

- (void)setGroud:(unsigned char)groud {
    _packet.Group = groud;
    [self updateCheckSum];
}

- (void)updateCheckSum {
    _packet.CheckSum = _packet.Type
    + _packet.ID[0] + _packet.ID[1] + _packet.ID[2]
    + _packet.Group
    + _packet.CMD
    + _packet.Length
    + _packet.RVar + 0X55;
    for (int i=0; i<_packet.Length; i++) {
        _packet.CheckSum += _packet.DATA[i];
    }
}

- (void)control:(unsigned char)mode
              r:(unsigned char)r
              g:(unsigned char)g
              b:(unsigned char)b
              c:(unsigned char)c
              w:(unsigned char)w {
    [self setCMD:BLEPacketControlCMD];
    _packet.DATA[0] = mode;
    _packet.DATA[1] = r;
    _packet.DATA[2] = g;
    _packet.DATA[3] = b;
    _packet.DATA[4] = c;
    _packet.DATA[5] = w;
    [self updateCheckSum];
}

- (void)setR:(unsigned char)r
           g:(unsigned char)g
           b:(unsigned char)b {
    [self control:kBLEDataControlRGB r:r g:g b:b c:0x80 w:0x80];
}

- (void)setC:(unsigned char)c
           w:(unsigned char)w {
    [self control:kBLEDataControlCW r:0x80 g:0x80 b:0x80 c:c w:w];
}

@end

@implementation BlueToothTimerPacket

@synthesize packet = _packet;

- (id)init {
    if (self = [super init]) {
        _packet.Head = 0xAA;
        _packet.Type = 0x0A;
        _packet.ID[0] = 0Xfc;
        _packet.ID[1] = 0X3a;
        _packet.ID[2] = 0X86;
        _packet.Group = 0x01;
        _packet.Length = 0x09;
        srand((int)time(0));
        _packet.RVar = random();
        _packet.Stop = 0x0d;
        [self updateCheckSum];
    }
    return self;
}

- (void)setCMD:(unsigned char)cmd {
    _packet.CMD = cmd;
    if (_packet.CMD != BLEPacketRGBCMD) {
    }
    [self updateCheckSum];
}

- (void)setGroud:(unsigned char)groud {
    _packet.Group = groud;
    [self updateCheckSum];
}

- (void)updateCheckSum {
    _packet.CheckSum = _packet.Type
    + _packet.ID[0] + _packet.ID[1] + _packet.ID[2]
    + _packet.Group
    + _packet.CMD
    + _packet.Length
    + _packet.RVar + 0X55;
    for (int i=0; i<_packet.Length; i++) {
        _packet.CheckSum += _packet.DATA[i];
    }
}

- (void)set:(unsigned char)type
      groud:(unsigned char)group
    subType:(unsigned char)subType
       hour:(unsigned char)hour
     minute:(unsigned char)minute
     second:(unsigned char)second {
    [self setCMD:BLEPacketSceneCMD];
    
    NSDate *date = [NSDate date];
    
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:date];
//    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *h = [dateFormatter stringFromDate:date];
    _packet.DATA[5] = [h intValue];
    [dateFormatter setDateFormat:@"mm"];
    NSString *m = [dateFormatter stringFromDate:date];
    _packet.DATA[4] = [m intValue];
    [dateFormatter setDateFormat:@"ss"];
    NSString *s = [dateFormatter stringFromDate:date];
    _packet.DATA[3] = [s intValue];
    
    NSLog(@"%@:%@:%@", h, m, s);
    
    _packet.DATA[0] = type;
    _packet.DATA[1] = group;
    _packet.DATA[2] = subType;
    _packet.DATA[6] = second;
    _packet.DATA[7] = minute;
    _packet.DATA[8] = hour;
    
    [self updateCheckSum];
}

- (void)setTimerOn:(unsigned char)hour minute:(unsigned char)minute {
    [self set:kBLEDataSceneTiming groud:0x02 subType:0X01 hour:hour minute:minute second:0x05];
}

- (void)setTimerOff:(unsigned char)hour minute:(unsigned char)minute {
    [self set:kBLEDataSceneTiming groud:0x02 subType:0X02 hour:hour minute:minute second:0x05];
}

- (void)setWakeUp:(unsigned char)hour minute:(unsigned char)minute {
    [self set:kBLEDataSceneWakeUp groud:0x02 subType:0x01 hour:hour minute:minute second:0x05];
}

@end

@implementation BlueToothScenePacket

- (id)init {
    if (self = [super init]) {
        _packet.Head = 0xAA;
        _packet.Type = 0x0A;
        _packet.ID[0] = 0Xfc;
        _packet.ID[1] = 0X3a;
        _packet.ID[2] = 0X86;
        _packet.Group = 0x01;
        _packet.Length = 0x02;
        srand((int)time(0));
        _packet.RVar = random();
        _packet.Stop = 0x0d;
        [self updateCheckSum];
    }
    return self;
}

- (void)setCMD:(unsigned char)cmd {
    _packet.CMD = cmd;
    if (_packet.CMD != BLEPacketRGBCMD) {
    }
    [self updateCheckSum];
}

- (void)setGroud:(unsigned char)groud {
    _packet.Group = groud;
    [self updateCheckSum];
}

- (void)updateCheckSum {
    _packet.CheckSum = _packet.Type
    + _packet.ID[0] + _packet.ID[1] + _packet.ID[2]
    + _packet.Group
    + _packet.CMD
    + _packet.Length
    + _packet.RVar + 0X55;
    for (int i=0; i<_packet.Length; i++) {
        _packet.CheckSum += _packet.DATA[i];
    }
}

- (void)setNight {
    [self setCMD:BLEPacketSceneCMD];
    _packet.DATA[0] = kBLEDataSceneNight;
    _packet.DATA[1] = 0X04;
    [self updateCheckSum];
}

- (void)setSleep {
    [self setCMD:BLEPacketSceneCMD];
    _packet.DATA[0] = kBLEDataSceneSleep;
    _packet.DATA[1] = 0X03;
    [self updateCheckSum];
}

- (void)setRecreation {
    [self setCMD:BLEPacketSceneCMD];
    _packet.DATA[0] = kBLEDataSceneRecreation;
    _packet.DATA[1] = 0X07;
    [self updateCheckSum];
}

@end
