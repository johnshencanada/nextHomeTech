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
#import "NYSegmentedControl.h"

@interface LightBulbColorViewController ()

/* View */
@property CGRect screenRect;
@property (strong,nonatomic) MyNavigationController *nav;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UIVisualEffect *vibrancyEffect;
@property  (strong,nonatomic) UIVisualEffectView *vibrancyView;
@property (nonatomic) BrightnessView *brightView;
@property (nonatomic,strong) NYSegmentedControl *colorSegmentedControl;
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
//    [self.view addSubview:self.background];
    
    UIImage *image = [UIImage imageNamed:@"back"];
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(self.screenRect.size.width/16,
                                                          self.screenRect.size.width/16,
                                                          self.screenRect.size.width/8,
                                                          self.screenRect.size.width/8)];
    [self.back setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.back];
    [self.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventAllTouchEvents];

    //Color Wheel
    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(self.screenRect.size.width/11,
                                                                 self.screenRect.size.height/11,
                                                                  (9 * self.screenRect.size.width/11),
                                                                  (9 * self.screenRect.size.width/11))];
    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    [self.view addSubview:_colorWheel];
    
    //Brightness
    [self setUpBrightnessView];
    
    //On Off Button
    UIView *foursquareSegmentedControlBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                                                                0.0,
                                                                                                self.screenRect.size.width,
                                                                                                self.screenRect.size.height/8)];
    foursquareSegmentedControlBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:foursquareSegmentedControlBackgroundView];
    self.colorSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"On",@"Off"]];
    self.colorSegmentedControl.titleTextColor = [UIColor lightGrayColor];
    self.colorSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    self.colorSegmentedControl.selectedTitleFont = [UIFont systemFontOfSize:18.0f];
    self.colorSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.31f green:0.53f blue:0.72f alpha:0.7];
    self.colorSegmentedControl.backgroundColor = [UIColor colorWithRed:0.31f green:0.53f blue:0.72f alpha:0.1];
    self.colorSegmentedControl.borderWidth = 0.0f;
    self.colorSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    self.colorSegmentedControl.segmentIndicatorInset = 1.0f;
    self.colorSegmentedControl.segmentIndicatorBorderColor = self.view.backgroundColor;
    [self.colorSegmentedControl sizeToFit];
    self.colorSegmentedControl.cornerRadius = CGRectGetHeight(self.colorSegmentedControl.frame) / 2.0f;
    self.colorSegmentedControl.center = CGPointMake(self.view.center.x,
                                                    self.view.center.y + self.screenRect.size.height/8);
    foursquareSegmentedControlBackgroundView.center = self.colorSegmentedControl.center;
    [self.colorSegmentedControl addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.colorSegmentedControl];

}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)setUpBlurAndVibrancy
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
        [device startconfiguration];
    }
}

- (void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel
{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [_colorWheel.currentColor getRed:&red green:&green blue:&blue alpha:&alpha];
    [self.brightSlider setPopUpViewColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.5]];
    [self.warmSlider setPopUpViewColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.5]];
    self.titleLabel.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.7];
    self.colorSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.7];
    self.colorSegmentedControl.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.1];

    self.red = (int)(red * 255);
    self.green = (int)(green * 255);
    self.blue = (int)(blue * 255);
    
    for (Device *device in self.devices) {
        [device sendColorR:self.red G:self.green B:self.blue];
    }
}


- (void)segmentSelected:(NYSegmentedControl*)foursquareSegmentedControl
{
    int index = (int)foursquareSegmentedControl.selectedSegmentIndex;
    
    if (index == 0)
    {
        for (Device *device in self.devices) {
            [device turnOff];
            [device turnOn];
        }
    }
    
    else if (index == 1)
    {
        for (Device *device in self.devices) {
            [device turnOff];
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
    }
}

#pragma mark - ASValueTrackingSliderDataSource

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    for (Device *device in self.devices) {
        
        if (self.red||self.blue||self.green) {
            [device changeBrightness:15+(int)(240*value) WithRed:self.red andGreen:self.green andBlue:self.blue brightness:NO];
        }
        
        else {
            [device changeBrightness:15+(int)(240*value) WithRed:self.red andGreen:self.green andBlue:self.blue brightness:YES];
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
