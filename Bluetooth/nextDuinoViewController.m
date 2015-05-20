//
//  nextDuinoViewController.m
//  nextHome
//
//  Created by john on 11/14/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "nextDuinoViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "VBFPopFlatButton.h"
#import "DKCircleButton.h"

@interface nextDuinoViewController ()
@property (strong,nonatomic) UIButton *toogleButton;
@property (strong,nonatomic) VBFPopFlatButton *leftButton;
@property (strong,nonatomic) VBFPopFlatButton *rightButton;
@property (strong,nonatomic) DKCircleButton *stopButton;
@end

@implementation nextDuinoViewController

#pragma mark MVC Lifecycle

- (id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        self.devices = [NSArray arrayWithArray:devices];
        UIImage *color = [UIImage imageNamed:@"heart"];
        UITabBarItem *colorTab = [[UITabBarItem alloc] initWithTitle:@"nextDuino" image:color tag:0];
        self.tabBarItem = colorTab;
        [self findCharacteristicsAndConfigure];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupStopButton];
    [self setupLeftButton];
    [self setupRightButton];
}

- (void)setupStopButton
{
    self.stopButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(130, 200, 100, 100)];
    self.stopButton.center = CGPointMake(160, 200);
    
    [self.stopButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.stopButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [self.stopButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.stopButton.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:30.0];;

    [self.stopButton setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateNormal];
    [self.stopButton setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateSelected];
    [self.stopButton setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateHighlighted];

    [self.stopButton addTarget:self
                        action:@selector(stop)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.stopButton];
}

- (void)setupLeftButton
{
    self.leftButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(20, 200, 60, 60)
                                                         buttonType:buttonBackType
                                                        buttonStyle:buttonRoundedStyle
                                              animateToInitialState:YES];
    
    self.leftButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
    self.leftButton.lineThickness = 2;
    self.leftButton.tintColor = [UIColor colorWithWhite:255 alpha:0.6];
    [self.leftButton addTarget:self
                               action:@selector(goLeft)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftButton];
}

- (void)setupRightButton
{
    self.rightButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(240, 200, 60, 60)
                                                         buttonType:buttonForwardType
                                                        buttonStyle:buttonRoundedStyle
                                              animateToInitialState:YES];
    
    self.rightButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
    self.rightButton.lineThickness = 2;
    self.rightButton.tintColor = [UIColor colorWithWhite:255 alpha:0.6];
    [self.rightButton addTarget:self
                               action:@selector(goRight)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark View helper

- (void)findCharacteristicsAndConfigure
{
    for (Device *device in self.devices)
    {
        for (CBService *service in device.peripheral.services)
        {
            for (CBCharacteristic *characteristic in service.characteristics)
            {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCNCoinBLEWriteCharacteristicUUID]])
                {
                    device.CoinWriteCharacteristic = characteristic;
                }
            }
        }
    }
}

-(void)goLeft
{
    NSString *str;
    str = [NSString stringWithFormat:@"l"];
    [self sendDataWithoutResponse:str];
}

- (void)goRight
{
    NSString *str;
    str = [NSString stringWithFormat:@"r"];
    [self sendDataWithoutResponse:str];
}

- (void)stop
{
    NSString *str;
    str = [NSString stringWithFormat:@"b"];
    [self sendDataWithoutResponse:str];
}

- (void)sendDataWithoutResponse:(NSString *)dataStr
{
    for (Device *device in self.devices)
    {
        //Cut and send in 20 character size
        NSString *tmpStr;
        int x = 0;
        
        for (x = 0; x + 20 < [dataStr length]; x = x + 20)
        {
            tmpStr = [dataStr substringWithRange:NSMakeRange(x, 20)];
            [device.peripheral writeValue:[tmpStr dataUsingEncoding:NSUTF8StringEncoding]
                                forCharacteristic:device.CoinWriteCharacteristic
                                             type:CBCharacteristicWriteWithResponse];
        }
        
        [device.peripheral writeValue:[[dataStr substringWithRange:NSMakeRange(x, [dataStr length] - x)] dataUsingEncoding:NSUTF8StringEncoding]
                            forCharacteristic:device.CoinWriteCharacteristic
                                         type:CBCharacteristicWriteWithResponse];
    }
}

- (void)centralReadCharacteristic:(CBCharacteristic *)characteristic withPeripheral:(CBPeripheral *)peripheral withError:(NSError *)error {
    
    NSUInteger i;
    NSString *str;
    NSString *temp = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    NSLog(@"%@", temp);
}

@end
