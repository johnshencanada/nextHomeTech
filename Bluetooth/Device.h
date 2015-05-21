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


#pragma mark - Bluetooth Peripheral
@interface Device : NSObject
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) CBPeripheral *peripheral;
@property (strong,nonatomic) CBCentralManager *centralManager;


#pragma mark - ZhengGee's characteristics
@property (strong,nonatomic) CBCharacteristic *congigureCharacteristic;
@property (strong,nonatomic) CBCharacteristic *onOffCharacteristic;
@property (strong,nonatomic) CBCharacteristic *readCharacteristic;
@property (strong,nonatomic) CBCharacteristic *writeCharacteristic;


#pragma mark - Coin's characteristics
@property (strong,nonatomic) CBCharacteristic *CoinWriteCharacteristic;


#pragma mark - Lede's characteristics



@property (strong,nonatomic) NSData *configurationEnabledData;
@property (strong,nonatomic) NSData *onData;
@property (strong,nonatomic) NSData *offData;
@property (strong,nonatomic) NSString *room;
@property bool isOn;
@property bool isSelected;

@property (nonatomic) double brightness;


#pragma mark - Configuration
-(void)startconfiguration;

#pragma mark - General Functions
-(void)sendColorR:(double)red G:(double)green B:(double)blue;


#pragma mark - ZhengGee
@property (strong,nonatomic) NSData *ZhengGeeColorData;

- (void) changeZhengGeeColorWithRed:(double)red andGreen:(double)green andBlue:(double)blue;
- (void)changeBrightness:(double)brightness WithRed:(double)red andGreen:(double)green andBlue:(double)blue brightness:(BOOL)bright;
- (int)incrementBrightnessBy:(double)brightness;
- (int)decrementBrightnessBy:(double)brightness;

@end
