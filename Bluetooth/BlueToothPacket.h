//
//  BlueToothPacket.h
//  Marlight
//
//  Created by 杨 烽 on 13-11-15.
//  Copyright (c) 2013年 cdy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BLEPacketSwitchCMD      = 0X0A,//灯光开关控制 Length=1; 开灯DATA[0]=1;关灯DATA[0] = 0;
    BLEPacketRGBCMD         = 0X0B,//RGB切换模式	Length=1; DATA[0]为RGB模式值
    BLEPacketLightCMD       = 0X0C,//亮度调节命令	Length=1;亮度值DATA[0]
    BLEPacketControlCMD     = 0X0D,//调控模式    Length=6;DATA内容（MODE,R,G,B,C,W）
    BLEPacketLightTmpCMD    = 0X0E,//冷暖光调节	Length=1;冷暖光值DATA[0]
    BLEPacketSceneCMD       = 0X10,//场景模式选择	Length=1; DATA[0]为场景模式值
} BLEPacketCMD;

//开
#define kBLEDataTurnOn 0x01
//关
#define kBLEDataTurnOff 0X00

//RGB切换模式
//红	绿	蓝	黄	粉红	淡蓝	RGB渐变	RGB自动转换	七彩自动转换	白
#define kBLEDataRGBRed              1
#define kBLEDataRGBGreen            2
#define kBLEDataRGBBlue             3
#define kBLEDataRGBYellow           4
#define kBLEDataRGBPink             5
#define kBLEDataRGBLightBlue        6
#define kBLEDataRGBShade            7
#define kBLEDataRGBAutoTransfer     8
#define kBLEDataRGBAutoTransfer2    9
#define kBLEDataRGBWhite            10

#define kIncrease 0x01
#define kDecrease 0x00

//增加亮度
#define kBLEDataLightIncrease   kIncrease
//减少亮度
#define kBLEDataLightDecrease   kDecrease

//调控模式
#define kBLEDataControlRGB  0X01
#define kBLEDataControlCW   0X02

//增加冷暖光比例
#define kBLEDataLightTmpIncrease    kIncrease
//减少冷暖光比例
#define kBLEDataLightTmpDecrease    kDecrease

//场景模式- 定时	起床	睡眠	夜晚(无)	会议(无)	阅读(无)	娱乐(无)
#define kBLEDataSceneTiming         0X01
#define kBLEDataSceneWakeUp         0X02
#define kBLEDataSceneSleep          0X03
#define kBLEDataSceneNight          0X04
#define kBLEDataSceneMeeting        0X05
#define kBLEDataSceneReading        0X06
#define kBLEDataSceneRecreation     0X07

#pragma mark ****************************************
#pragma mark 【BlueToothPacket】
#pragma mark ****************************************

typedef struct {
    unsigned char Head;//0001:up;0010:down;0011:left;0100:right;0101:center
    unsigned char Type;
    unsigned char ID[3];
    unsigned char Group;
    unsigned char CMD;
    unsigned char Length;
    unsigned char DATA[1];
    unsigned char RVar;
    unsigned char CheckSum;
    unsigned char Stop;
} BLEPacket;

@interface BlueToothPacket : NSObject {
    BLEPacket  _packet;
}

@property (nonatomic, assign) BLEPacket packet;

- (void)setCMD:(unsigned char)cmd;

- (void)setGroud:(unsigned char)groud;

- (void)setData:(unsigned char)data;

- (void)turnOn;

- (void)turnOff;

- (void)updateRGBMode:(unsigned char)mode;

- (void)lightIncrease;

- (void)lightDecrease;

- (void)lightTmpIncrease;

- (void)lightTmpDecrease;

- (void)updateLightValue:(unsigned char)value;

- (void)updateLightTmpValue:(unsigned char)value;

@end

#pragma mark ****************************************
#pragma mark 【BlueToothColorPacket】
#pragma mark ****************************************

typedef struct {
    unsigned char Head;//0001:up;0010:down;0011:left;0100:right;0101:center
    unsigned char Type;
    unsigned char ID[3];
    unsigned char Group;
    unsigned char CMD;
    unsigned char Length;
    unsigned char DATA[6];
    unsigned char RVar;
    unsigned char CheckSum;
    unsigned char Stop;
} BLEColorPacket;

@interface BlueToothColorPacket : NSObject  {
    BLEColorPacket  _packet;
}

@property (nonatomic, assign) BLEColorPacket packet;

- (void)setCMD:(unsigned char)cmd;

- (void)setGroud:(unsigned char)groud;

- (void)control:(unsigned char)mode
              r:(unsigned char)r
              g:(unsigned char)g
              b:(unsigned char)b
              c:(unsigned char)c
              w:(unsigned char)w;

- (void)setR:(unsigned char)r
           g:(unsigned char)g
           b:(unsigned char)b;

- (void)setC:(unsigned char)c
           w:(unsigned char)w;

@end

#pragma mark ****************************************
#pragma mark 【BlueToothTimerPacket】
#pragma mark ****************************************

typedef struct {
    unsigned char Head;//0001:up;0010:down;0011:left;0100:right;0101:center
    unsigned char Type;
    unsigned char ID[3];
    unsigned char Group;
    unsigned char CMD;
    unsigned char Length;
    unsigned char DATA[9];
    unsigned char RVar;
    unsigned char CheckSum;
    unsigned char Stop;
} BLETimerPacket;

@interface BlueToothTimerPacket : NSObject {
    BLETimerPacket  _packet;
}

@property (nonatomic, assign) BLETimerPacket packet;

- (void)setCMD:(unsigned char)cmd;

- (void)setGroud:(unsigned char)groud;

- (void)setTimerOn:(unsigned char)hour minute:(unsigned char)minute;

- (void)setTimerOff:(unsigned char)hour minute:(unsigned char)minute;

- (void)setWakeUp:(unsigned char)hour minute:(unsigned char)minute;

@end

#pragma mark ****************************************
#pragma mark 【BlueToothScenePacket】
#pragma mark ****************************************

typedef struct {
    unsigned char Head;//0001:up;0010:down;0011:left;0100:right;0101:center
    unsigned char Type;
    unsigned char ID[3];
    unsigned char Group;
    unsigned char CMD;
    unsigned char Length;
    unsigned char DATA[2];
    unsigned char RVar;
    unsigned char CheckSum;
    unsigned char Stop;
} BLEScenePacket;

@interface BlueToothScenePacket : NSObject {
    BLEScenePacket _packet;
}

@property (nonatomic, assign) BLEScenePacket packet;

- (void)setCMD:(unsigned char)cmd;

- (void)setGroud:(unsigned char)groud;

- (void)setNight;

- (void)setSleep;

- (void)setRecreation;

@end
