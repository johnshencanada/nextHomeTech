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

@interface Device : NSObject
@property (strong,nonatomic) CBPeripheral *peripheral;
@property (strong,nonatomic) CBCentralManager *centralManager;

//ZhengGee's characteristics
@property (strong,nonatomic) CBCharacteristic *congigureCharacteristic;
@property (strong,nonatomic) CBCharacteristic *onOffCharacteristic;
@property (strong,nonatomic) CBCharacteristic *readCharacteristic;
@property (strong,nonatomic) CBCharacteristic *writeCharacteristic;

//Coin's characteristics
@property (strong,nonatomic) CBCharacteristic *CoinWriteCharacteristic;

@property (strong,nonatomic) NSData *configurationEnabledData;
@property (strong,nonatomic) NSData *onData;
@property (strong,nonatomic) NSData *offData;
@property (strong,nonatomic) NSData *colorData;

@property (strong,nonatomic) NSString *room;
@property bool isOn;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) double brightness;

- (void)changeBrightness:(double)brightness WithRed:(double)red andGreen:(double)green andBlue:(double)blue brightness:(BOOL)bright;
- (int)incrementBrightnessBy:(double)brightness;
- (int)decrementBrightnessBy:(double)brightness;
- (void) changeColorWithRed:(double)red andGreen:(double)green andBlue:(double)blue;

@end
