//
//  LightBulbColorViewController.m
//  nextHome
//
//  Created by john on 8/4/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import "LightBulbColorViewController.h"
#import "MyNavigationController.h"
#import "BrightnessView.h"
#import "CircleCounter.h"

@interface LightBulbColorViewController ()

/* View */
@property CGRect screenRect;
@property (strong,nonatomic) MyNavigationController *nav;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UIVisualEffect *vibrancyEffect;
@property  (strong,nonatomic) UIVisualEffectView *vibrancyView;
@property (nonatomic) BrightnessView *brightView;
@property (strong,nonatomic) UIButton *toogleButton;
@property (nonatomic) UIButton *back;

@property (strong,nonatomic) UIButton *brightnessButtonSmall;
@property (strong,nonatomic) UIButton *brightnessButtonLarge;
@property (strong,nonatomic) UIButton *warmnessButtonCold;
@property (strong,nonatomic) UIButton *warmnessButtonWarm;

@property (strong,nonatomic) ASValueTrackingSlider *brightSlider;
@property (strong,nonatomic) ASValueTrackingSlider *warmSlider;

@property (strong, nonatomic) CircleCounter *background;
@property BOOL isOn;

@property double red;
@property double green;
@property double blue;

@property int percentage;

@end

@implementation LightBulbColorViewController

- (id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.screenRect = [[UIScreen mainScreen] bounds];
        self.view.backgroundColor = [UIColor clearColor];
        self.devices = [NSArray arrayWithArray:devices];
        UIImage *color = [UIImage imageNamed:@"appliance-nextbulb-small"];
        UITabBarItem *colorTab = [[UITabBarItem alloc] initWithTitle:@"Color" image:color tag:0];
        self.tabBarItem = colorTab;
        [self findCharacteristicsAndConfigure];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpBlurAndVibrancy];
    
    self.background = [[CircleCounter alloc] initWithFrame:CGRectMake(10, ((self.view.frame.size.height)/2 - 220), 300, 300)];
    self.background.backgroundColor = [UIColor clearColor];
    self.background.circleColor = [UIColor colorWithRed:255/255.0f
                                                  green:255/255.0f
                                                   blue:255/255.0f
                                                  alpha:0.1];
    self.background.circleWidth = 24.0;
    [self.view addSubview:self.background];
    
    UIImage *image = [UIImage imageNamed:@"back"];
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(self.screenRect.size.width/16,
                                                          self.screenRect.size.width/16,
                                                          self.screenRect.size.width/8,
                                                          self.screenRect.size.width/8)];
    [self.back setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.back];
    [self.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventAllTouchEvents];

    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(25, ((self.view.frame.size.height)/2 - 205), 270, 270)];
    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    [self.view addSubview:_colorWheel];
    
    self.toogleButton = [[UIButton alloc]initWithFrame:CGRectMake(110, 170, 100, 100)];
    [self.toogleButton setBackgroundImage:[UIImage imageNamed:@"onButton"] forState:UIControlStateNormal];
    [self.toogleButton addTarget:self action:@selector(toogleSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toogleButton];
    [self setUpBrightnessView];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) setUpBlurAndVibrancy
{
    self.nav = (MyNavigationController*)self.navigationController;
    self.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:self.nav.blurEffect];
    self.vibrancyView = [[UIVisualEffectView alloc]initWithEffect:self.vibrancyEffect];
    self.vibrancyView.frame = self.view.bounds;
    [self.nav.blurView.contentView addSubview:self.vibrancyView];
}

- (void)setUpBrightnessView
{
    /* Do any additional setup after loading the view */
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 60)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
    self.titleLabel.text = [NSString stringWithFormat:@"Change Color"];
    [self.view addSubview:self.titleLabel];

    
    UIImage *brightnessImage = [UIImage imageNamed:@"brightness"];
    UIImage *warmImage = [UIImage imageNamed:@"warm"];

    self.brightnessButtonSmall = [[UIButton alloc]initWithFrame:CGRectMake(10, 395, 25, 25)];
    [self.brightnessButtonSmall setBackgroundImage:brightnessImage forState:UIControlStateNormal];
    [self.view addSubview:self.brightnessButtonSmall];
    [self.brightnessButtonSmall addTarget:self action:@selector(brightnessButtonSmallClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.brightnessButtonLarge = [[UIButton alloc]initWithFrame:CGRectMake(275, 385, 40, 40)];
    [self.brightnessButtonLarge setBackgroundImage:brightnessImage forState:UIControlStateNormal];
    [self.view addSubview:self.brightnessButtonLarge];
    [self.brightnessButtonLarge addTarget:self action:@selector(brightnessButtonLargeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.brightSlider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(40, 393, 230, 30)];
    self.brightSlider.popUpViewCornerRadius = 12.0;
    self.brightSlider.maximumValue = 1.00;
    self.brightSlider.dataSource = self;
    [self.brightSlider setMaxFractionDigitsDisplayed:0];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    [self.brightSlider setNumberFormatter:formatter];
    self.brightSlider.popUpViewColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.brightSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.brightSlider.textColor = [UIColor whiteColor];
    self.brightSlider.value = 100;
    
    [self.view addSubview:self.brightSlider];
    
    self.warmnessButtonCold = [[UIButton alloc]initWithFrame:CGRectMake(10, 455, 25, 25)];
    [self.warmnessButtonCold setBackgroundImage:warmImage forState:UIControlStateNormal];
    [self.view addSubview:self.warmnessButtonCold];
    [self.warmnessButtonCold addTarget:self action:@selector(brightnessButtonSmallClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.warmnessButtonWarm = [[UIButton alloc]initWithFrame:CGRectMake(275, 450, 40, 40)];
    [self.warmnessButtonWarm setBackgroundImage:warmImage forState:UIControlStateNormal];
    [self.view addSubview:self.warmnessButtonWarm];
    [self.warmnessButtonWarm addTarget:self action:@selector(brightnessButtonLargeClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.warmSlider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(40, 453, 230, 30)];
    self.warmSlider.popUpViewCornerRadius = 12.0;
    self.warmSlider.maximumValue = 1.00;
    [self.warmSlider setMaxFractionDigitsDisplayed:0];
    [self.warmSlider setNumberFormatter:formatter];
    self.warmSlider.popUpViewColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.warmSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.warmSlider.textColor = [UIColor whiteColor];
    [self.view addSubview:self.warmSlider];
    
    self.isOn = true;
}


- (void)findCharacteristicsAndConfigure
{
    for (Device *device in self.devices)
    {
        for (CBService *service in device.peripheral.services)
        {
            for (CBCharacteristic *characteristic in service.characteristics) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
                    device.congigureCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]]) {
                    device.onOffCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE4"]]) {
                    device.readCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE9"]]) {
                    device.writeCharacteristic = characteristic;
                }
            }
        }
        
        /* set the configuration characteristics to be configurable */
        [device.peripheral writeValue:device.configurationEnabledData forCharacteristic:device.congigureCharacteristic type:CBCharacteristicWriteWithResponse];
        /* then turn it on */
        [device.peripheral writeValue:device.onData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel
{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [_colorWheel.currentColor getRed:&red green:&green blue:&blue alpha:&alpha];
    [self.background setColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.5]];
    [self.brightSlider setPopUpViewColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.5]];
    [self.warmSlider setPopUpViewColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.5]];

    self.red = (int)(red * 255);
    self.green = (int)(green * 255);
    self.blue = (int)(blue * 255);
    
    for (Device *device in self.devices) {
        [device changeColorWithRed:self.red andGreen:self.green andBlue:self.blue];
        [device.peripheral writeValue:device.colorData forCharacteristic:device.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)toogleSwitch
{
    
    if (!self.isOn) {
        [self.toogleButton setBackgroundImage:[UIImage imageNamed:@"onButton"] forState:UIControlStateNormal];
        [self.background setColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
        for(Device *device in self.devices) {
            [device.peripheral writeValue:device.onData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
        }
        self.isOn = true;
    }
    
    else {
        [self.toogleButton setBackgroundImage:[UIImage imageNamed:@"offButton"] forState:UIControlStateNormal];
        [self.background setColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        for(Device *device in self.devices) {
            [device.peripheral writeValue:device.offData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
        }
        self.isOn = false;
    }
}

- (void)brightnessButtonSmallClicked:sender
{
    [self startShake:sender];
    [self.brightSlider setPopUpViewColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self.warmSlider setPopUpViewColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self.background setColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    self.red=self.green=self.blue = 0;
    for (Device *device in self.devices) {
        self.brightSlider.value = 0;
        [device changeBrightness:15 WithRed:0 andGreen:0 andBlue:0 brightness:YES];
        [device.peripheral writeValue:device.colorData forCharacteristic:device.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)brightnessButtonLargeClicked:sender
{
    [self startShake:sender];
    [self.brightSlider setPopUpViewColor:[UIColor colorWithRed:255 green:205 blue:255 alpha:0.5]];
    [self.warmSlider setPopUpViewColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    [self.background setColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    self.red=self.green=self.blue = 0;
    for (Device *device in self.devices) {
        self.brightSlider.value = 100;
        [device changeBrightness:255 WithRed:0 andGreen:0 andBlue:0 brightness:YES];
        [device.peripheral writeValue:device.colorData forCharacteristic:device.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

#pragma mark - ASValueTrackingSliderDataSource

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    for (Device *device in self.devices) {
        
        if (self.red||self.blue||self.green) {
            [device changeBrightness:15+(int)(240*value) WithRed:self.red andGreen:self.green andBlue:self.blue brightness:NO];
            [device.peripheral writeValue:device.colorData forCharacteristic:device.writeCharacteristic type:CBCharacteristicWriteWithResponse];
        }
        
        else {
            [device changeBrightness:15+(int)(240*value) WithRed:self.red andGreen:self.green andBlue:self.blue brightness:YES];
            [device.peripheral writeValue:device.colorData forCharacteristic:device.writeCharacteristic type:CBCharacteristicWriteWithResponse];
        }
    }
    
    return 0;
}

#pragma mark <shaking animation>

- (void) startShake:(UIView *)view
{
    CGAffineTransform normal = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform leftShake = CGAffineTransformMakeTranslation(0, -5);
    CGAffineTransform rightShake = CGAffineTransformMakeTranslation(0, 5);
    
    view.transform = leftShake;  // starting point
    
    [UIView beginAnimations:@"shake_button"context:NULL];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    view.transform = rightShake;
    view.transform = normal;  // end here & auto-reverse
    [UIView commitAnimations];
}

@end
