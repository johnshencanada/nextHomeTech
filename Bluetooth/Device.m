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
        self.colorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
    }
    self.isSelected = false;

    return self;
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
    self.colorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
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
    self.colorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
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
    
    self.colorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
}

- (void) changeColorWithRed:(double)red andGreen:(double)green andBlue:(double)blue
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

    self.colorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
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
    
    self.colorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
}


@end
