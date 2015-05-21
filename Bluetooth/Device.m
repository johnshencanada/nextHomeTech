//
//  Device.m
//  Bluetooth
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "Device.h"

@implementation Device
@synthesize peripheral,centralManager;
@synthesize congigureCharacteristic;
@synthesize onOffCharacteristic;
@synthesize readCharacteristic;
@synthesize writeCharacteristic;

@synthesize configurationEnabledData;
@synthesize onData;
@synthesize offData;

#pragma mark - Initialization
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.congigureCharacteristic = [[CBCharacteristic alloc]init];
        self.onOffCharacteristic = [[CBCharacteristic alloc]init];
        self.readCharacteristic = [[CBCharacteristic alloc]init];
        self.writeCharacteristic = [[CBCharacteristic alloc]init];
        
        UInt8 configureByte[1];
        configureByte[0] = 0x04;
        self.configurationEnabledData = [NSData dataWithBytes:&configureByte length:sizeof(configureByte)];
        
        UInt8 onByte[1];
        onByte[0]= 0x3f;
        self.onData = [NSData dataWithBytes:&onByte length:sizeof(onByte)];
        
        UInt8 offByte[1];
        offByte[0]= 0x00;
        self.offData = [NSData dataWithBytes:&offByte length:sizeof(offByte)];
        
        UInt8 colorByte[7];
        colorByte[0] = 0x56;
        colorByte[1] = 0x00; //R
        colorByte[2] = 0x00; //G
        colorByte[3] = 0x00; //B
        colorByte[4] = 0xFE; //brightness
        colorByte[5] = 0x0F; //to indicate brightness
        colorByte[6] = 0xAA;
        self.brightness = colorByte[4];
        self.ZhengGeeColorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
    }
    return self;
}



#pragma mark - Configuration
-(void)startconfiguration
{
    // Configuration for 征极
    if ([self.name hasPrefix:@"LEDnet"]) {
        for (CBService *service in self.peripheral.services) {
            for (CBCharacteristic *characteristic in service.characteristics) {

                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
                    self.congigureCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]]) {
                    self.onOffCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE4"]]) {
                    self.readCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE9"]]) {
                    self.writeCharacteristic = characteristic;
                }
            }
        }
        /* set the configuration characteristics to be configurable */
        [self.peripheral writeValue:self.configurationEnabledData forCharacteristic:self.congigureCharacteristic type:CBCharacteristicWriteWithResponse];
        /* then turn it on */
        [self.peripheral writeValue:self.onData forCharacteristic:self.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
    }
    
    else if ([self.name hasPrefix:@"Tint"]){
        NSLog(@"N/A for %@",self.name);
    }
}

#pragma mark - General Methods
-(void)sendColorR:(double)red G:(double)green B:(double)blue
{
    NSLog(@"%@",self.name);
    //征极
    if ([self.name hasPrefix:@"LEDnet"]) {
        [self changeZhengGeeColorWithRed:red andGreen:green andBlue:blue];
        [self.peripheral writeValue:self.ZhengGeeColorData forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
    
    else if ([self.name hasPrefix:@"Tint"]) {
        NSLog(@"N/A for %@",self.name);
    }
}

#pragma mark - 征极

//Change RGB color
- (void) changeZhengGeeColorWithRed:(double)red andGreen:(double)green andBlue:(double)blue
{
    UInt8 colorByte[7];
    colorByte[0] = 0x56;
    colorByte[1] = red; //R
    colorByte[2] = green; //G
    colorByte[3] = blue; //B
    colorByte[4] = (int)self.brightness;
    colorByte[5] = 0xF0; //to indicate Color Change
    colorByte[6] = 0xAA;
    
    NSLog(@"colorbyte = %d",colorByte[1]);
    NSLog(@"colorbyte = %d",colorByte[2]);
    NSLog(@"colorbyte = %d",colorByte[3]);
    
    self.ZhengGeeColorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
}


- (int)incrementBrightnessBy:(double)brightness
{
    if (self.brightness < 249) {
        self.brightness+=brightness;
    }
    UInt8 colorByte[7];
    colorByte[0] = 0x56;
    colorByte[1] = 0x00; //R
    colorByte[2] = 0x00; //G
    colorByte[3] = 0x00; //B
    colorByte[4] = (int)self.brightness;
    colorByte[5] = 0x0F; //to indicate brightness
    colorByte[6] = 0xAA;
    
    NSLog(@"colorbyte = %d",colorByte[4]);
    self.ZhengGeeColorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
    return colorByte[4];
}

- (int)decrementBrightnessBy:(double)brightness
{
    if (self.brightness > 6) {
        self.brightness-=brightness;
    }
    UInt8 colorByte[7];
    colorByte[0] = 0x56;
    colorByte[1] = 0x00; //R
    colorByte[2] = 0x00; //G
    colorByte[3] = 0x00; //B
    colorByte[4] = 0xFE; //brightness
    colorByte[5] = 0x0F; //to indicate brightness
    colorByte[6] = 0xAA;
    
    NSLog(@"colorbyte = %d",colorByte[4]);
    self.ZhengGeeColorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
    return colorByte[4];
}

- (void)changeBrightness:(double)brightness
{
    UInt8 colorByte[7];
    colorByte[0] = 0x56;
    colorByte[1] = 0X00; //R
    colorByte[2] = 0X00; //G
    colorByte[3] = 0X00; //B
    colorByte[4] = brightness; // Max Brightness
    colorByte[5] = 0x0F; //to indicate Color Change
    colorByte[6] = 0xAA;
    
    self.ZhengGeeColorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
}



- (void)changeBrightness:(double)brightness WithRed:(double)red andGreen:(double)green andBlue:(double)blue brightness:(BOOL)bright
{
    UInt8 colorByte[7];
    colorByte[0] = 0x56;
    colorByte[1] = red; //R
    colorByte[2] = green; //G
    colorByte[3] = blue; //B
    colorByte[4] = brightness; // Max Brightness
    if (bright) {
        colorByte[5] = 0x0F; //to indicate Brightness Change
    }
    else {
        colorByte[5] = 0xF0; //to indicate Color Change
    }
    colorByte[6] = 0xAA;
    self.ZhengGeeColorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
}


@end
