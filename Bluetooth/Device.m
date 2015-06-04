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
@synthesize ZhengGeeCongigureCharacteristic;
@synthesize ZhengGeeOnOffCharacteristic;
@synthesize ZhengGeeReadCharacteristic;
@synthesize ZhengGeeWriteCharacteristic;
@synthesize ZhengGeeConfigurationEnabledData;
@synthesize ZhengGeeOnData;
@synthesize ZhengGeeOffData;

@synthesize packet = _packet;
@synthesize colorPacket = _colorPacket;


#pragma mark - Initialization
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initZhengGee];
        [self initLede];
    }
    return self;
}

-(void)initZhengGee
{
    self.ZhengGeeCongigureCharacteristic = [[CBCharacteristic alloc]init];
    self.ZhengGeeOnOffCharacteristic = [[CBCharacteristic alloc]init];
    self.ZhengGeeReadCharacteristic = [[CBCharacteristic alloc]init];
    self.ZhengGeeWriteCharacteristic = [[CBCharacteristic alloc]init];
    
    UInt8 configureByte[1];
    configureByte[0] = 0x04;
    self.ZhengGeeConfigurationEnabledData = [NSData dataWithBytes:&configureByte length:sizeof(configureByte)];
    
    UInt8 onByte[1];
    onByte[0]= 0x3f;
    self.ZhengGeeOnData = [NSData dataWithBytes:&onByte length:sizeof(onByte)];
    
    UInt8 offByte[1];
    offByte[0]= 0x00;
    self.ZhengGeeOffData = [NSData dataWithBytes:&offByte length:sizeof(offByte)];
    
    UInt8 colorByte[7];
    colorByte[0] = 0x56;
    colorByte[1] = 0x00; //R
    colorByte[2] = 0x00; //G
    colorByte[3] = 0x00; //B
    colorByte[4] = 0xFE; //brightness
    colorByte[5] = 0x0F; //to indicate brightness
    colorByte[6] = 0xAA;
    self.ZhengGeebrightness = colorByte[4];
    self.ZhengGeeColorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
}

-(void)initLede
{
    self.Lede_Service = [[CBService alloc]init];
    self.Lede_Send_Characteristic = [[CBCharacteristic alloc]init];
    self.Lede_Read_Characteristic = [[CBCharacteristic alloc]init];
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
}

- (void)initColor
{
    _colorPacket.Head = 0xAA;
    _colorPacket.Type = 0x0A;
    _colorPacket.ID[0] = 0Xfc;
    _colorPacket.ID[1] = 0X3a;
    _colorPacket.ID[2] = 0X86;
    _colorPacket.Group = 0x01;
    _colorPacket.Length = 0x06;
    srand((int)time(0));
    _colorPacket.RVar = random();
    _colorPacket.Stop = 0x0d;
}


#pragma mark - Configuration
-(void)startconfiguration
{
    // Lede
    if ([self.name hasPrefix:@"Tint"]){
        for (CBService *service in self.peripheral.services) {
            if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]]) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
                        NSLog(@"Got FFF1");
                        self.Lede_Send_Characteristic = characteristic;
                    }
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]]) {
                        NSLog(@"Got FFF2");
                        self.Lede_Read_Characteristic = characteristic;
                    }
                }
            }
        }
    }
    
    // 征极
    else if ([self.name hasPrefix:@"LEDnet"])
    {
        for (CBService *service in self.peripheral.services) {
            for (CBCharacteristic *characteristic in service.characteristics) {

                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
                    self.ZhengGeeCongigureCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]]) {
                    self.ZhengGeeOnOffCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE4"]]) {
                    self.ZhengGeeReadCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE9"]]) {
                    self.ZhengGeeWriteCharacteristic = characteristic;
                }
            }
        }
        /* set the configuration characteristics to be configurable */
        [self.peripheral writeValue:self.ZhengGeeConfigurationEnabledData forCharacteristic:self.ZhengGeeCongigureCharacteristic type:CBCharacteristicWriteWithResponse];
        /* then turn it on */
        [self.peripheral writeValue:self.ZhengGeeOnData forCharacteristic:self.ZhengGeeOnOffCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}


#pragma mark - General Methods
-(void)turnOn
{
    //Lede
    if ([self.name hasPrefix:@"Tint"]) {
        [self initOffLede];
        [self.peripheral writeValue:self.LedeOffData forCharacteristic:self.Lede_Send_Characteristic type:CBCharacteristicWriteWithResponse];
        [self initOnLede];
        [self.peripheral writeValue:self.LedeOnData forCharacteristic:self.Lede_Send_Characteristic type:CBCharacteristicWriteWithResponse];
    }
    
    //征极
    else if ([self.name hasPrefix:@"LEDnet"]) {
        [self.peripheral writeValue:self.ZhengGeeOnData forCharacteristic:self.ZhengGeeOnOffCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)turnOff
{
    //Lede
    if ([self.name hasPrefix:@"Tint"]) {
        [self initOffLede];
        [self.peripheral writeValue:self.LedeOffData forCharacteristic:self.Lede_Send_Characteristic type:CBCharacteristicWriteWithResponse];
    }
    
    //征极
    else if ([self.name hasPrefix:@"LEDnet"]) {
        [self.peripheral writeValue:self.ZhengGeeOffData forCharacteristic:self.ZhengGeeOnOffCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)sendColorR:(double)red G:(double)green B:(double)blue
{
    //Lede
    if ([self.name hasPrefix:@"Tint"]) {
        [self initColor];
        [self changeLedeColorWithRed:red andGreen:green andBlue:blue];
        [self.peripheral writeValue:self.LedeColorData forCharacteristic:self.Lede_Send_Characteristic type:CBCharacteristicWriteWithoutResponse];
    }
    
    //征极
    else {
        [self changeZhengGeeColorWithRed:red andGreen:green andBlue:blue];
        [self.peripheral writeValue:self.ZhengGeeColorData forCharacteristic:self.ZhengGeeWriteCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)changeBrightness:(double)brightness WithRed:(double)red andGreen:(double)green andBlue:(double)blue brightness:(BOOL)bright
{
    //Lede
    if ([self.name hasPrefix:@"Tint"]) {
        NSLog(@"Brightness N/A for %@",self.name);
    }
    
    //征极
    else {
        [self changeZhengGeeBrightness:brightness WithRed:red andGreen:green andBlue:blue brightness:bright];
        [self.peripheral writeValue:self.ZhengGeeColorData forCharacteristic:self.ZhengGeeWriteCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}


#pragma mark - Lede
- (void)initOnLede
{
    UInt8 onByte[12];
    onByte[0] = 0xAA;      // Head
    onByte[1] = 0xA;       // Type
    onByte[2] = 0xFC;      // ID[0]
    onByte[3] = 0x3A;      // ID[1]
    onByte[4] = 0x86;      // ID[2]
    onByte[5] = 0x00;      // Group    1.0x01  单个           2.
    onByte[6] = 0xA;       // Command  1.0X0A  灯光开关控制     2.0X0B RGB切换模式   3.0X0C 亮度调节命令
                           //          4.0X0D  调控模式        5.0X0E 冷暖光调节     6.0X10 场景模式选择
    onByte[7] = 0x01;      // Length
    onByte[8] = 0x01;      // Data     1.0x01  开             2.0x00  关
    srand((int)time(0));
    onByte[9] = rand();    // random
    onByte[10] = 0;        // checkSum
    onByte[11] = 0xD;      // Stop
    
    onByte[10] = onByte[1]+onByte[2]+onByte[3]+onByte[4]+onByte[5]+onByte[6]+onByte[7]+onByte[9]+0X55;
    
    self.LedeOnData = [NSMutableData dataWithBytes:&onByte length:sizeof(onByte)];
}

-(void)initOffLede
{
    UInt8 offByte[12];
    offByte[0] = 0xAA;      // Head
    offByte[1] = 0xA;       // Type
    offByte[2] = 0xFC;      // ID[0]
    offByte[3] = 0x3A;      // ID[1]
    offByte[4] = 0x86;      // ID[2]
    offByte[5] = 0x00;      // Group    1.0x00  单个           2.
    offByte[6] = 0xA;       // Command  1.0X0A  灯光开关控制     2.0X0B RGB切换模式   3.0X0C 亮度调节命令
                            //          4.0X0D  调控模式        5.0X0E 冷暖光调节     6.0X10 场景模式选择
    offByte[7] = 0x01;      // Length
    offByte[8] = 0x00;      // Data     1.0x01  开             2.0x00  关
    srand((int)time(0));
    offByte[9] = rand();    // random
    offByte[10] = 0;        // checkSum
    offByte[11] = 0xD;      // Stop
    
    offByte[10] = offByte[1]+offByte[2]+offByte[3]+offByte[4]+offByte[5]+offByte[6]+offByte[7]+offByte[9]+0X55;
    
    self.LedeOffData = [NSMutableData dataWithBytes:&offByte length:sizeof(offByte)];
}

- (void)changeLedeColorWithRed:(double)red andGreen:(double)green andBlue:(double)blue
{
    NSLog(@"Chaging lEDE color");
    UInt8 colorByte[17];
    colorByte[0] = 0xAA;  // Head
    colorByte[1] = 0xA;   // Type
    colorByte[2] = 0xFC;  // ID[0]
    colorByte[3] = 0x3A;  // ID[1]
    colorByte[4] = 0x86;  // ID[2]
    colorByte[5] = 0x0;   // Group
    colorByte[6] = 0xD;   // Command 1.0X0A 灯光开关控制 2.0X0B RGB切换模式 3.0X0C 亮度调节命令
    //         4.0X0D 调控模式 5.0X0E 冷暖光调节 6.0X10 场景模式选择
    colorByte[7] = 6;     // Length
    colorByte[8] = 0x1;   // Mode
    colorByte[9] = 0xff;  // r
    colorByte[10] = 0x73; // g
    colorByte[11] = 0xAB; // b
    colorByte[12] = 0x80; // c
    colorByte[13] = 0x80; // w
    colorByte[14] = 0x51; // random
    colorByte[15] = 0x9D; // checkSum
    colorByte[16] = 0xD;  // Stop
    self.LedeColorData = [NSMutableData dataWithBytes:&colorByte length:sizeof(colorByte)];
    
//    /* Color Packet */
//    UInt8 colorByte[17];
//    colorByte[0] = 0xAA;  // Head
//    colorByte[1] = 0xA;   // Type
//    colorByte[2] = 0xFC;  // ID[0]
//    colorByte[3] = 0x3A;  // ID[1]
//    colorByte[4] = 0x86;  // ID[2]
//    colorByte[5] = 0x0;   // Group
//    colorByte[6] = 0xD;   // Command 1.0X0A 灯光开关控制 2.0X0B RGB切换模式 3.0X0C 亮度调节命令
//                          //         4.0X0D 调控模式    5.0X0E 冷暖光调节  6.0X10 场景模式选择
//    colorByte[7] = 6;     // Length
//    colorByte[8] = 0x1;   // Mode
//    colorByte[9] = 0xff;  // r
//    colorByte[10] = 0x73; // g
//    colorByte[11] = 0xAB; // b
//    colorByte[12] = 0x80; // c
//    colorByte[13] = 0x80; // w
//    colorByte[14] = 0x51; // random
//    colorByte[15] = 0x9D; // checkSum
//    colorByte[16] = 0xD;  // Stop
//    
//    
//    colorByte[15] = colorByte[1]+colorByte[2]+colorByte[3]+colorByte[4]+colorByte[5]+colorByte[6]+colorByte[7]+colorByte[8]+colorByte[9]+colorByte[10]+colorByte[11]+colorByte[12]+colorByte[13]+colorByte[14]+0x55;
//    self.LedeColorData = [NSMutableData dataWithBytes:&colorByte length:sizeof(colorByte)];
}


#pragma mark - 征极
//Change RGB color
- (void)changeZhengGeeColorWithRed:(double)red andGreen:(double)green andBlue:(double)blue
{
    UInt8 colorByte[7];
    colorByte[0] = 0x56;
    colorByte[1] = red; //R
    colorByte[2] = green; //G
    colorByte[3] = blue; //B
    colorByte[4] = (int)self.ZhengGeebrightness;
    colorByte[5] = 0xF0; //to indicate Color Change
    colorByte[6] = 0xAA;

    NSLog(@"colorbyte = %d",colorByte[1]);
    NSLog(@"colorbyte = %d",colorByte[2]);
    NSLog(@"colorbyte = %d",colorByte[3]);
    
    self.ZhengGeeColorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
}

//Change Brightness
- (void)changeZhengGeeBrightness:(double)brightness WithRed:(double)red andGreen:(double)green andBlue:(double)blue brightness:(BOOL)bright
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

- (int)incrementBrightnessBy:(double)brightness
{
    if (self.ZhengGeebrightness < 249) {
        self.ZhengGeebrightness+=brightness;
    }
    UInt8 colorByte[7];
    colorByte[0] = 0x56;
    colorByte[1] = 0x00; //R
    colorByte[2] = 0x00; //G
    colorByte[3] = 0x00; //B
    colorByte[4] = (int)self.ZhengGeebrightness;
    colorByte[5] = 0x0F; //to indicate brightness
    colorByte[6] = 0xAA;
    
    NSLog(@"colorbyte = %d",colorByte[4]);
    self.ZhengGeeColorData = [NSData dataWithBytes:&colorByte length:sizeof(colorByte)];
    return colorByte[4];
}

- (int)decrementBrightnessBy:(double)brightness
{
    if (self.ZhengGeebrightness > 6) {
        self.ZhengGeebrightness-=brightness;
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
@end
