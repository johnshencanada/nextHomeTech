//
//  Device.h
//  Bluetooth
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define kCNCoinBLEServiceUUID @"3870cd80-fc9c-11e1-a21f-0800200c9a66"
#define kCNCoinBLEWriteCharacteristicUUID @"E788D73B-E793-4D9E-A608-2F2BAFC59A00"
#define kCNCoinBLEReadCharacteristicUUID @"4585C102-7784-40B4-88E1-3CB5C4FD37A3"
typedef enum {
    BLEPacketSwitchCMD      = 0X0A,//灯光开关控制 Length=1; 开灯DATA[0]=1;关灯DATA[0] = 0;
    BLEPacketRGBCMD         = 0X0B,//RGB切换模式	Length=1; DATA[0]为RGB模式值
    BLEPacketLightCMD       = 0X0C,//亮度调节命令	Length=1;亮度值DATA[0]
    BLEPacketControlCMD     = 0X0D,//调控模式    Length=6;DATA内容（MODE,R,G,B,C,W）
    BLEPacketLightTmpCMD    = 0X0E,//冷暖光调节	Length=1;冷暖光值DATA[0]
    BLEPacketSceneCMD       = 0X10,//场景模式选择	Length=1; DATA[0]为场景模式值
} BLEPacketCMD;

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

#pragma mark - Bluetooth Peripheral
@interface Device : NSObject
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) CBPeripheral *peripheral;
@property (strong,nonatomic) CBCentralManager *centralManager;


#pragma mark - Lede Characteristics
@property (strong,nonatomic) CBService *Lede_Service;
@property (strong,nonatomic) CBCharacteristic *Lede_Send_Characteristic;
@property (strong,nonatomic) CBCharacteristic *Lede_Read_Characteristic;
@property (strong,nonatomic) NSData *LedeOnData;
@property (strong,nonatomic) NSData *LedeOffData;
@property (strong,nonatomic) NSMutableData *LedeColorData;
@property (nonatomic, assign) BLEPacket packet;
@property (nonatomic, assign) BLEColorPacket colorPacket;


#pragma mark - ZhengGee Characteristics
@property (strong,nonatomic) CBCharacteristic *ZhengGeeCongigureCharacteristic;
@property (strong,nonatomic) CBCharacteristic *ZhengGeeOnOffCharacteristic;
@property (strong,nonatomic) CBCharacteristic *ZhengGeeReadCharacteristic;
@property (strong,nonatomic) CBCharacteristic *ZhengGeeWriteCharacteristic;
@property (strong,nonatomic) NSData *ZhengGeeOnData;
@property (strong,nonatomic) NSData *ZhengGeeOffData;
@property (strong,nonatomic) NSData *ZhengGeeConfigurationEnabledData;
@property (strong,nonatomic) NSData *ZhengGeeColorData;
@property (nonatomic) double ZhengGeebrightness;

#pragma mark - Coin's Characteristics
@property (strong,nonatomic) CBCharacteristic *CoinWriteCharacteristic;



@property (strong,nonatomic) NSString *room;
@property bool isOn;
@property bool isSelected;



#pragma mark - Configuration
-(void)startconfiguration;

#pragma mark - General Functions
-(void)turnOn;
-(void)turnOff;
-(void)sendColorR:(double)red G:(double)green B:(double)blue;
- (void)changeBrightness:(double)brightness WithRed:(double)red andGreen:(double)green andBlue:(double)blue brightness:(BOOL)bright;


#pragma mark - ZhengGee
- (void) changeZhengGeeColorWithRed:(double)red andGreen:(double)green andBlue:(double)blue;
- (void)changeZhengGeeBrightness:(double)brightness WithRed:(double)red andGreen:(double)green andBlue:(double)blue brightness:(BOOL)bright;
- (int)incrementBrightnessBy:(double)brightness;
- (int)decrementBrightnessBy:(double)brightness;

@end
