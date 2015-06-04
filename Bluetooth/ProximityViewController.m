//
//  ProximityViewController.m
//  nextHome
//
//  Created by john on 5/10/15.
//  Copyright (c) 2015 Banana Technology. All rights reserved.
//

#import "ProximityViewController.h"

@interface ProximityViewController ()
@property CGRect screenRect;

//view
@property (nonatomic) UIButton *back;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *contentView;
@property (nonatomic) CHCircleGaugeView *circleGaugeView;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NYSegmentedControl *foursquareSegmentedControl;
@property (nonatomic,strong) NYSegmentedControl *colorSegmentedControl;
@property (nonatomic,strong) UIButton *goButton;
@property (nonatomic,strong) UILabel *proximityLabel;
@property (nonatomic,strong) UILabel *percentLabel;
@property (nonatomic,strong) UITextView *instruction1;
@property (nonatomic,strong) UITextView *instruction2;

//proximity
@property (strong,nonatomic) NSNumber *rssi;
@property int rssiVal;
@property int averageRSSI;
@property int proximity;
@property int lastAbsoluteRSSI;
@property double percentage;
@property int signalStrength;

//model
@property (nonatomic,strong)NSMutableArray *actionArray;
@property (nonatomic,strong)NSDictionary *dictionary;
@property (nonatomic,strong)UIColor *color;

@end


@implementation ProximityViewController

-(id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.devices = [NSArray arrayWithArray:devices];
        for (Device *device in devices) {
            device.peripheral.delegate = self;
            self.lastAbsoluteRSSI = 100;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenRect = [[UIScreen mainScreen]bounds];
    self.view.backgroundColor = [UIColor clearColor];
    
    /* set up image view */
    UIImage *image = [UIImage imageNamed:@"back"];
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(self.screenRect.size.width/16,
                                                          self.screenRect.size.width/16,
                                                          self.screenRect.size.width/8,
                                                          self.screenRect.size.width/8)];
    [self.back setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.back];
    [self.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventAllTouchEvents];
    
    /* ContentView */
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(self.screenRect.size.width/4,
                                                               self.screenRect.size.width/5.3,
                                                               self.screenRect.size.width/2,
                                                               self.screenRect.size.width/2)];
    [self.view addSubview: self.contentView];

    /* Title */
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 60)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.text = [NSString stringWithFormat:@"Proximity"];
    
    /* Proximity */
    self.circleGaugeView = [[CHCircleGaugeView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.circleGaugeView];
    self.circleGaugeView.state = CHCircleGaugeViewStatePercentSign;
    self.circleGaugeView.trackTintColor = [UIColor colorWithWhite:255 alpha:0.1];
    self.color = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1];
    self.circleGaugeView.gaugeTintColor = self.color;
    self.circleGaugeView.textColor = [UIColor lightGrayColor];
    self.circleGaugeView.trackWidth = 20;
    self.circleGaugeView.gaugeWidth = 10;
    [self.circleGaugeView setValue:0 animated:YES];
    
    self.instruction1 = [[UITextView alloc]initWithFrame:CGRectMake(10, 250, 300, 60)];
    self.instruction1.backgroundColor = [UIColor clearColor];
    self.instruction1.textColor = [UIColor lightGrayColor];
    self.instruction1.textAlignment = NSTextAlignmentCenter;
    self.instruction1.text = @": ";
    self.instruction1.font = [UIFont fontWithName:@"GillSans-Light" size:18];

    //    [self.view addSubview:self.instruction1];
    
    self.instruction2 = [[UITextView alloc]initWithFrame:CGRectMake(10, 340, 300, 60)];
    self.instruction2.backgroundColor = [UIColor clearColor];
    self.instruction2.textColor = [UIColor lightGrayColor];
    self.instruction2.textAlignment = NSTextAlignmentCenter;
    self.instruction2.text = @"Turns On when signal is: ";
    self.instruction2.font = [UIFont fontWithName:@"GillSans-Light" size:18];
    [self.instruction2 setUserInteractionEnabled:NO];
    [self.view addSubview:self.instruction2];
    
    self.proximityLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 160, 60)];
    self.proximityLabel.textColor = [UIColor lightGrayColor];
    self.proximityLabel.textAlignment = NSTextAlignmentCenter;
    self.proximityLabel.text = @"0";
    self.proximityLabel.font = [UIFont fontWithName:@"GillSans-Light" size:25];
    [self.view addSubview:self.proximityLabel];
    
    self.percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 110, 130, 60)];
    self.percentLabel.textColor = [UIColor lightGrayColor];
    self.percentLabel.textAlignment = NSTextAlignmentCenter;
    self.percentLabel.text = @"%";
    self.percentLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20];
    [self.view addSubview:self.percentLabel];
    
    [self setupSegementedControl];
    [self setupGoButton];

    /* check the connection every 1 second */
    if ([self.devices count]) {
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(checkRSSI)
                                       userInfo:nil
                                        repeats:YES];
    }
}

- (void)setupGoButton
{
    self.goButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 600, 320, 80)];
    [self.goButton setTitle: @"Set!" forState:UIControlStateNormal];
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.goButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.goButton.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:50.0];
    self.goButton.backgroundColor = [UIColor colorWithWhite:255 alpha:0.2];
    [self.goButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self pushUpGoButton];
}

- (void)setupSegementedControl
{
    self.signalStrength = 0;
    UIView *foursquareSegmentedControlBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                                0.0f,
                                                                                                CGRectGetWidth([UIScreen mainScreen].bounds),
                                                                                                44.0f)];
    foursquareSegmentedControlBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:foursquareSegmentedControlBackgroundView];
    
    self.colorSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Strong",@"Okay", @"Weak"]];
    self.colorSegmentedControl.titleTextColor = [UIColor lightGrayColor];
    self.colorSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    self.colorSegmentedControl.selectedTitleFont = [UIFont systemFontOfSize:13.0f];
    self.colorSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.298 green:0.851 blue:0.392 alpha:0.8];
    self.colorSegmentedControl.backgroundColor = [UIColor colorWithRed:0.31f green:0.53f blue:0.72f alpha:0.2f];
    self.colorSegmentedControl.borderWidth = 0.0f;
    self.colorSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    self.colorSegmentedControl.segmentIndicatorInset = 1.0f;
    self.colorSegmentedControl.segmentIndicatorBorderColor = self.view.backgroundColor;
    [self.colorSegmentedControl sizeToFit];
    self.colorSegmentedControl.cornerRadius = CGRectGetHeight(self.colorSegmentedControl.frame) / 2.0f;
    self.colorSegmentedControl.center = CGPointMake(self.view.center.x,
                                                         self.view.center.y + 110);
    foursquareSegmentedControlBackgroundView.center = self.colorSegmentedControl.center;
    [self.colorSegmentedControl addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.colorSegmentedControl];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.actionArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"actions"]];
    self.dictionary = self.actionArray[0];
    NSNumber *number = [self.dictionary objectForKey:@"proximity"];
    int index = [number intValue];
    self.colorSegmentedControl.selectedSegmentIndex = index;
    
    if (index == 0)
    {
        self.colorSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.298 green:0.851 blue:0.392 alpha:0.8];
    }
    
    else if (index == 1)
    {
        self.colorSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:1 green:0.859 blue:0.298 alpha:0.8];
    }
    
    else {
        self.colorSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:1 green:0.231 blue:0.298 alpha:0.8];
    }
}

- (void)pushUpGoButton
{
    [self.view addSubview:self.goButton];
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:13
                        options:0
                     animations:^() {
                         self.goButton.center = CGPointMake(160, 530);
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)segmentSelected:(NYSegmentedControl*)foursquareSegmentedControl
{
    int index = (int)foursquareSegmentedControl.selectedSegmentIndex;
    
    if (index == 0)
    {
        self.signalStrength = 0;
        self.colorSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.298 green:0.851 blue:0.392 alpha:0.8];
    }
    
    else if (index == 1)
    {
        self.signalStrength = 1;
        self.colorSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:1 green:0.859 blue:0.298 alpha:0.8];
    }
    
    else {
        self.signalStrength = 2;
        self.colorSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:1 green:0.231 blue:0.298 alpha:0.8];
    }
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

/* returnRSSI is called */
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.rssiVal += [peripheral.RSSI intValue];
    
    if (self.rssiVal) {
        int devceCount = (int)[self.devices count];
        self.averageRSSI += [peripheral.RSSI intValue]/devceCount;
        self.proximity = self.rssiVal;
    }
    
    self.percentage = [self ConvertRSSItoPercentage];
    [self.circleGaugeView setValue:(self.percentage) animated:YES];
    [self.circleGaugeView setGaugeTintColor:self.color];
}


- (double)ConvertRSSItoPercentage {
    
    int originalAbsoluteRSSI = abs(self.averageRSSI);
    int absoluteRSSI = originalAbsoluteRSSI;
    
    NSLog(@"Last:%d Now:%d",self.lastAbsoluteRSSI,absoluteRSSI);

    /* if it's a signal Spike, don't worry about it */
    if (absoluteRSSI >= (self.lastAbsoluteRSSI + 5))
    {
        NSLog(@"Big Increase!");
        absoluteRSSI -= 5;
        
        if (absoluteRSSI >= (self.lastAbsoluteRSSI + 10)) {
            
            NSLog(@"Super!");
            absoluteRSSI -= 5;
        }
    }

    else if (absoluteRSSI <= (self.lastAbsoluteRSSI - 5))
    {
        NSLog(@"Big Decrease!");
        int difference = absoluteRSSI - self.lastAbsoluteRSSI;
        absoluteRSSI += 5;
        
        if (absoluteRSSI <= (self.lastAbsoluteRSSI - 10)) {
            
            NSLog(@"Super!");
            absoluteRSSI = absoluteRSSI + difference - 5;
        }
    }
    
    self.lastAbsoluteRSSI = originalAbsoluteRSSI;
    self.proximityLabel.text = [NSString stringWithFormat:@"%d", absoluteRSSI];
    double alpha = 0.2;
    
    if (absoluteRSSI == 0) {
        self.color = [UIColor colorWithRed:1 green:0 blue:0 alpha:alpha];
        return 0.01;
    }
    
    else if (absoluteRSSI < 50) {
        self.color = [UIColor colorWithRed:0.298 green:0.851 blue:0.392 alpha:0.8];
        return 1.0;
    }
    
    else if (absoluteRSSI >= 50 && absoluteRSSI < 70) {
        self.color = [UIColor colorWithRed:0.298 green:0.851 blue:0.392 alpha:0.8];
        return 0.9;
    }
    
    else if (absoluteRSSI >= 70 && absoluteRSSI < 80) {
        self.color = [UIColor colorWithRed:1 green:0.859 blue:0.298 alpha:0.8];
        return 0.8;
    }
    
    else if (absoluteRSSI >= 80 && absoluteRSSI < 85) {
        self.color = [UIColor colorWithRed:1 green:0.859 blue:0.298 alpha:0.8];
        return 0.7;
    }
    
    else if (absoluteRSSI >= 85 && absoluteRSSI < 90) {
        self.color = [UIColor colorWithRed:1 green:0.859 blue:0.298 alpha:0.8];
        return 0.6;
    }
    
    else if (absoluteRSSI >= 90 && absoluteRSSI < 95) {
        self.color = [UIColor colorWithRed:1 green:0.231 blue:0.298 alpha:0.8];
        return 0.5;
    }
    
    else if (absoluteRSSI >= 95 && absoluteRSSI <= 100) {
        self.color = [UIColor colorWithRed:1 green:0.231 blue:0.298 alpha:0.8];
        return 0.2;
    }
    
    
//    if (absoluteRSSI >= 100) {
//        return 1.0;
//    }
//    
//    else if (absoluteRSSI < 100) {
//        self.proximityLabel.text = @"Very Close 😆";
//    }
//    
//    else if (absoluteRSSI >= 90 && absoluteRSSI < 100) {
//        self.proximityLabel.text = @"Far 😫";
//    }
//    
//    else if (absoluteRSSI >= 80 && absoluteRSSI < 90) {
//        self.proximityLabel.text = @"Closer 😗";
//    }
//    
//    else if (absoluteRSSI >= 75 && absoluteRSSI < 80) {
//        self.proximityLabel.text = @"Very Close 😕";
//    }
//    
//    else if (absoluteRSSI >= 70 && absoluteRSSI < 75) {
//        self.proximityLabel.text = @"Super Close 😑";
//    }
//    
//    else if (absoluteRSSI < 70) {
//        self.proximityLabel.text = @"Near You 😐";
//    }
    
    return 0;
}

- (void)checkRSSI
{
    self.rssiVal = 0;
    self.averageRSSI = 0;
    int deviceCount = 0;
    
    for (Device *device in self.devices) {
        
        CBPeripheral *peripheral = device.peripheral;
        if (peripheral) {
            deviceCount++;
            [peripheral readRSSI];
        }
    }
}

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.actionArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"actions"]];
    
    if (!self.actionArray) {
        self.actionArray = [[NSMutableArray alloc]init];
    }
    
    NSString * key1 = @"actionType";    // 0 as alarm triggered action; 1 as proximity triggered                                        action; 2 as timer triggered action
    NSString * key2 = @"OnOff";         // on or off
    NSString * key3 = @"time";          // the time of the action
    NSString * key4 = @"proximity";     // 0 as strong, 1 as okay, 2 as weak
    
    NSNumber *obj1 = [NSNumber numberWithLong:1];
    NSNumber *obj2 = [NSNumber numberWithBool:1];
    NSDate *obj3 = [NSDate date];
    NSNumber *obj4 = [NSNumber numberWithInt:self.signalStrength];
    NSDictionary * dictionary =[NSDictionary dictionaryWithObjects:@[obj1,obj2,obj3,obj4] forKeys:@[key1,key2,key3,key4]];
    
    self.actionArray[0] = dictionary;
    [defaults setObject:self.actionArray forKey:@"actions"];
    [defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
