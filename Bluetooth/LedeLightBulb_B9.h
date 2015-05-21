//
//  Bulb.h
//  Marlight
//
//  Created by 杨 烽 on 13-11-16.
//  Copyright (c) 2013年 cdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef enum {
    DeviceTypeOfLightBulb = 1,
    DeviceTypeOfHeadset = 2,
    DeviceTypeOfSoundbox = 3,
    DeviceTypeOfGroup = 4,
    DeviceTypeOfLedeStrip = 5,
    DeviceTypeOfLampHolder = 6,
    DeviceTypeOfOutlet = 7,
} DeviceType;

typedef enum {
    DeviceModelOfUnknow,
    DeviceModelOfWhite,
    DeviceModelOfRGB,
} DeviceModel;


typedef enum {
    DeviceColorModelOfRGBCW = 1,//颜色RGBCW的产品拥有全部功能。
    DeviceColorModelOfCW = 2,//颜色CW的产品不带彩色功能，色温可调，只能进入white界面。
    DeviceColorModelOfRGBW = 3,// 颜色RGBW的产品为彩色单色温，色温不可调， 隐藏cct功能。
    DeviceColorModelOfRGBC = 4,
    DeviceColorModelOfLampHolder = 5, //只有开关、定时、睡眠和调亮度的功能
} DeviceColorModel;

@interface Bulb : NSObject {
    NSString        *_uuid;
    NSString        *_name;
    int             _type;
    KIPeripheral    *_peripheral;
    
    BOOL            _switchStatus;
    int             _rgbMode;
    int             _lightValue;
    int             _lightTmpValue;
    
    int             _RGBLightValue;
    
    unsigned char   _group;
    
    NSMutableArray  *_items;
    
    BOOL            _sendable;
    
    DeviceModel     _model;
    
    DeviceColorModel    _colorModel;
}

@property (copy, nonatomic) NSString      *uuid;
@property (copy, nonatomic) NSString      *name;
@property (assign, nonatomic) int           type;
@property (strong, nonatomic) KIPeripheral  *peripheral;

@property (assign, nonatomic) BOOL          switchStatus;
@property (assign, nonatomic) int           rgbMode;
@property (assign, nonatomic) int           lightValue;
@property (assign, nonatomic) int           lightTmpValue;

@property (assign, nonatomic) int red;
@property (assign, nonatomic) int green;
@property (assign, nonatomic) int blue;

@property (assign, nonatomic) int           RGBLightValue;

@property (assign, nonatomic) unsigned char group;
@property (strong, nonatomic) NSMutableArray    *items;

@property (assign, nonatomic) BOOL          sendable;

@property (nonatomic, assign) DeviceModel   model;

@property (nonatomic, assign) DeviceColorModel  colorModel;

@property (nonatomic, assign) BOOL isUpdateCircleImageView;
@property (nonatomic, assign) BOOL isOn;

@property (nonatomic, assign) NSInteger outletStatus;
@property (nonatomic, assign) NSInteger effectivePower;

- (NSString *)status;

- (UIImage *)image;

- (UIImage *)highlightImage;

- (void)turnOn;

- (void)turnOff;

- (void)switchLight;

- (void)lightIncrease;

- (void)lightDecrease;

- (void)RGBLightIncrease;

- (void)RGBLightDecrease;

- (void)lightTmpIncrease;

- (void)lightTmpDecrease;

- (void)updateLightValue:(unsigned char)value;

- (void)updateRGBLightValue:(unsigned char)value;

- (void)updateLightTmpValue:(int)value;

- (void)RGBModeIncrease;

- (void)RGBModeDecrease;

- (void)updateRGBMode:(int)mode;

- (void)setR:(unsigned char)r
           g:(unsigned char)g
           b:(unsigned char)b;

- (void)setC:(unsigned char)c
           w:(unsigned char)w;

- (void)setTimerOn:(unsigned char)hour minute:(unsigned char)minute;

- (void)setTimerOff:(unsigned char)hour minute:(unsigned char)minute;

- (void)setWakeUp:(unsigned char)hour minute:(unsigned char)minute;

- (void)setNight;

- (void)setSleep;

- (void)setRecreation;

@end
