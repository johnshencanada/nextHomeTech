//
//  DevicesCollectionViewController.m
//  nextHome
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

//General View
#import "MyNavigationController.h"
#import "Dashboard.h"
#import "DevicesCollectionViewController.h"

// For the nextBulb
#import "LightBulbColorViewController.h"
#import "TimedActionCollectionViewController.h"
#import "LightBulbRoomCollectionViewController.h"
#import "DeviceCell.h"

@interface DevicesCollectionViewController ()
@property (strong,nonatomic) MyNavigationController *nav;

//view
@property CGRect screenRect;
@property (strong,nonatomic) Dashboard *dashBoard;
@property (strong,nonatomic) NSString *imageName;
@property (strong,nonatomic) VBFPopFlatButton *flatRoundedButton;
@property (strong,nonatomic) UILabel *addLabel;
@property (strong,nonatomic) UIButton *goButton;

//HomeKit
@property NSString *roomName;
@property (nonatomic) HMHomeManager *homeManger;
@property (nonatomic) NSMutableArray *homes;
@property (nonatomic) HMHome *primaryHome;
@property (nonatomic) HMAccessory *accessory;

//Model
@property (strong,nonatomic) CBCentralManager *centralManager;
@property (strong,nonatomic) NSNumber *rssi;
@property int rssiVal;
@property int averageRSSI;
@property (strong,nonatomic) NSMutableArray *devices;
@property (strong,nonatomic) NSMutableArray *selectedDevices;
@property BOOL allSelected;
@property (strong,nonatomic) NSTimer *discoverTimer;
@end


@implementation DevicesCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


#pragma mark - MVC

- (instancetype)initWithName:(NSString *)name andDevice:(NSArray *)devices
{
    self.screenRect = [[UIScreen mainScreen] bounds];
    self.imageName = [NSString stringWithFormat:@"Dashboard-%@",name];
    self.roomName = name;
    [self setUpHome];
    [self setUpDevices];
    self.devices = [NSMutableArray arrayWithArray:devices];
    self.allSelected = false;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(106, 106);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    layout.headerReferenceSize = CGSizeMake(0,0);
    self = [super initWithCollectionViewLayout:layout];
    
    [self findCharacteristicsAndConfigure];
    if (!devices) {
        [self setupAddButton];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.discoverTimer invalidate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    [self setupAddButton];

    /* check the connection every 1 second */
    if ([self.devices count]) {
//        self.discoverTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                         target:self
//                                       selector:@selector(checkRSSI)
//                                       userInfo:nil
//                                       repeats:YES];
    }

    [self.dashBoard.discover addTarget:self action:@selector(checkRSSI) forControlEvents:UIControlEventTouchUpInside];
    [self selectAllLightbulb];
}

- (void)setUpView
{
    self.dashBoard = [[Dashboard alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3.5)];
    [self.dashBoard setbackgroundImage:self.imageName];
    [self.dashBoard setBackImage: @"back"];
    [self.dashBoard setRefreshImage:@"reconnect"];
    [self.dashBoard setTitle:self.roomName];
    
    [self.dashBoard addSubview:self.dashBoard.camera];
    [self.dashBoard addSubview:self.dashBoard.alarmImageView];
    [self.dashBoard.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventAllTouchEvents];
    [self.dashBoard.refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventAllTouchEvents];
    [self.dashBoard.camera addTarget:self action:@selector(changePhoto) forControlEvents:UIControlEventAllTouchEvents];

    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.frame = CGRectMake(0, self.view.frame.size.height/4, 320, 320);
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[DeviceCell class] forCellWithReuseIdentifier:@"lightbulb"];
    self.collectionView.alwaysBounceVertical = YES;
    self.dashBoard.homeLabel.text = self.roomName;
    
    [self.view addSubview:self.dashBoard];
    
    self.goButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 600, 320, 80)];
    [self.goButton setTitle:@"Lightbulbs" forState:UIControlStateNormal];
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.goButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.goButton.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:30.0];
    self.goButton.titleLabel.textColor = [UIColor blackColor];
    self.goButton.backgroundColor = [UIColor colorWithWhite:255 alpha:0.2];
    [self.goButton addTarget:self action:@selector(pushToViewControllers) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupAddButton
{
    self.flatRoundedButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(self.screenRect.size.width/2 - self.screenRect.size.width/40,
                                                                               self.screenRect.size.height/3 - self.screenRect.size.width/40,
                                                                               self.screenRect.size.width/20,
                                                                               self.screenRect.size.width/20)
                                                         buttonType:buttonAddType
                                                        buttonStyle:buttonRoundedStyle
                                              animateToInitialState:YES];
    self.flatRoundedButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
    self.flatRoundedButton.lineThickness = 1;
    [self.flatRoundedButton setTintColor:[UIColor colorWithWhite:255 alpha:0.3]forState:UIControlStateNormal];
    [self.flatRoundedButton setTintColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.flatRoundedButton addTarget:self
                               action:@selector(addDevice)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flatRoundedButton];
    
    self.addLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.screenRect.size.width/2 - self.screenRect.size.width/4,
                                                             self.screenRect.size.height/3 + self.screenRect.size.width/15,
                                                             self.screenRect.size.width/2,
                                                             self.screenRect.size.width/20)];
    self.addLabel.text = @"Add Devices";
    self.addLabel.textAlignment = NSTextAlignmentCenter;
    self.addLabel.font = [UIFont fontWithName:@"GillSans-Light" size:14.0];
    self.addLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.addLabel];
}

- (void)setUpAnimation
{
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:13
                        options:0
                     animations:^() {
                         self.dashBoard.timeLabel.center = CGPointMake(125, 80);
                         self.dashBoard.AMPMLabel.center = CGPointMake(195, 80);
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}

//- (void)setUpTimer
//{
//    [NSTimer scheduledTimerWithTimeInterval:3.0
//                                     target:self
//                                   selector:@selector(changeTimeAndShake)
//                                   userInfo:nil
//                                    repeats:NO];
//    
//
//}


/* Temporary remove later */
//-(void)changeTimeAndShake
//{
//    self.dashBoard.timeLabel.text = @"6:00";
//    
//    [UIView animateWithDuration:1.0
//                          delay:0
//         usingSpringWithDamping:1
//          initialSpringVelocity:13
//                        options:0
//                     animations:^() {
//                         self.dashBoard.alarmImageView.center = CGPointMake(160, 150);
//                     }
//                     completion:^(BOOL finished) {
//                     }];
//    
//    for (DeviceCell *cell in self.collectionView.visibleCells) {
//        [self startShake:cell.logo for:50 horizontal:YES];
//    }
//}

- (void)setUpHome
{
    self.homeManger = [[HMHomeManager alloc]init];
    self.homeManger.delegate = self;
    [self.homeManger addHomeWithName:@"My Home" completionHandler:^(HMHome *home, NSError *error) {
        
        if (error != nil) {
        }
        
        /* Successful */
        else {
            NSLog(@"Created Home : %@",home.name);
        }
    }];
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

- (void)addDevice
{
    
}

- (void)setUpDevices
{
    self.selectedDevices = [[NSMutableArray alloc]init];
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
}

- (void)GoButtonTapped:(id)sender
{
    [self pushToViewControllers];
    for (Device *device in self.selectedDevices) {
    }
    NSLog(@"The RSSI is: %d",self.rssiVal);
}

- (void)changePhoto
{
}

- (void)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)refresh
{
    
}

- (void)selectAllLightbulb
{
    [self.selectedDevices removeAllObjects];
    for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
        Device *device = [self.devices objectAtIndex:row];
        device.isSelected = NO;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
        [self.collectionView selectItemAtIndexPath:indexPath  animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
        device.isSelected = YES;
    }
}

- (void)logoClicked:(RoomLogoButton*)sender
{
    [self startShake:sender for:20 horizontal:YES];
    
    for (Device *device in self.selectedDevices)
    {
        [device.peripheral writeValue:device.configurationEnabledData forCharacteristic:device.congigureCharacteristic type:CBCharacteristicWriteWithResponse];
        [device.peripheral writeValue:device.offData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
        [device.peripheral writeValue:device.onData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)pushToViewControllers
{
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    LightBulbColorViewController *ColorVC = [[LightBulbColorViewController alloc]initWithDevices:self.selectedDevices];
    ColorVC.extendedLayoutIncludesOpaqueBars = YES;
    TimedActionCollectionViewController *TimerVC = [[TimedActionCollectionViewController alloc]initWithDevices:self.selectedDevices];
    TimerVC.extendedLayoutIncludesOpaqueBars = YES;
    LightBulbRoomCollectionViewController *RoomVC = [[LightBulbRoomCollectionViewController alloc]initWithDevices:self.selectedDevices];
    RoomVC.extendedLayoutIncludesOpaqueBars = YES;
    NSArray *controllers = [NSArray arrayWithObjects: ColorVC,TimerVC,RoomVC, nil];
    tabBarController.viewControllers = controllers;
    tabBarController.tabBar.barStyle = UIBarStyleBlackOpaque;
    tabBarController.tabBar.tintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:tabBarController animated:NO];
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

- (void)pushDownGoButton
{
    [self.view addSubview:self.goButton];
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:13
                        options:0
                     animations:^() {
                         self.goButton.center = CGPointMake(160, 700);
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.devices.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lightbulb" forIndexPath:indexPath];
    
    if (cell) {
        [self.flatRoundedButton removeFromSuperview];
        [self.addLabel removeFromSuperview];
    }
    
    [cell.flatRoundedButton addTarget:self
                               action:@selector(pushToViewControllers)
                     forControlEvents:UIControlEventTouchUpInside];
    
    Device *device = [self.devices objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = device.peripheral;
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    
    /* Set logo Image */
    if ([peripheral.name hasPrefix:@"LEDnet"]) {
        cell.name.text = @"nextBulb-nano";
        [cell setLogoImage:@"nextBulb-nano"];
    }
    
    else if ([peripheral.name hasPrefix:@"Tint B7"]) {
        cell.name.text = @"nextBulb";
        [cell setLogoImage:@"nextBulb"];
    }
    
    else if ([peripheral.name hasPrefix:@"Tint B9"]) {
        cell.name.text = @"nextBulb-mega";
        [cell setLogoImage:@"nextBulb-mega"];
    }
    
    else if ([peripheral.name hasPrefix:@"Coin"]){
        cell.name.text = @"nextDuino";
        [cell setLogoImage:@"nextDuino"];
    }
    
    /* Set State Image */
    if (peripheral.state == CBPeripheralStateConnected) {
        [cell setStateImage:@"Connected"];
    }
    
    else if (peripheral.state == CBPeripheralStateConnecting)
    {
        [cell setStateImage:@"Connecting"];
    }
    
    else if (peripheral.state == CBPeripheralStateDisconnected)
    {
        [cell setStateImage:@"Disconnected"];
    }
    
    [cell.logo addTarget:self action:@selector(logoClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /* Find the peripheral and the cell at the index path */
    Device *device = [self.devices objectAtIndex:indexPath.row];
    DeviceCell *cell = (DeviceCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self startShake:cell.logo for:2 horizontal:NO];

    /* Create a device at the index path */
    if (!device.isSelected) {
        NSLog(@"select");
        device.isSelected = true;
        [cell addRoundedButton];
        [self.selectedDevices addObject:device];
    }
    
    else {
        NSLog(@"unselect");
        device.isSelected = false;
        [self.selectedDevices removeObject:device];
        [cell removeRounedButton];
    }
    
    if ([self.selectedDevices count] > 0)
    {
        [self pushUpGoButton];
    }
    
    else
    {
        [self pushDownGoButton];
    }
}


#pragma mark - CBCentralManager delegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self.collectionView reloadData];
    if (central.state != CBCentralManagerStatePoweredOn) {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops" message:[NSString stringWithFormat:@"CoreBluetooth return state: %ld",central.state] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
    }
    
    else {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}


#pragma mark - CBPeripheral delegate

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
 
}

/* returnRSSI is called */
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.rssiVal += [peripheral.RSSI intValue];
    
    if (self.rssiVal) {
        int devceCount = (int)[self.devices count];
        self.averageRSSI += [peripheral.RSSI intValue]/devceCount;
        self.dashBoard.RSSILabel.text = [NSString stringWithFormat:@"%d",self.rssiVal];
        self.dashBoard.DeviceCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)devceCount];
        self.dashBoard.Average.text = [NSString stringWithFormat:@"%d",self.averageRSSI];
    }

    if (self.averageRSSI > -60)
    {
        for (Device *device in self.devices) {
            
            if (self.rssiVal > -80) {
                NSLog(@"Close");
//                [device.peripheral writeValue:device.onData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
            }
        }
    }
    
    if (self.averageRSSI < -75)
    {
        for (Device *device in self.devices) {
            
            NSLog(@"Far");
//            [device.peripheral writeValue:device.offData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
        }
    }
    
    NSLog(@"The RSSI is: %d",self.rssiVal);
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

#pragma mark - HMHomeManager delegate

- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager
{
    
}

- (void)homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home
{

}

#pragma mark - TGCameraDelegate required

- (void)cameraDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidTakePhoto:(UIImage *)image
{
    CGSize size = [image size];
    CGRect rect = CGRectMake(0 ,size.height*0.2, size.width*2, size.height*1.2);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    
    self.dashBoard.backgroundImageView.image = img;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    self.dashBoard.backgroundImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <Shaking animation>

- (void)startShake:(UIView *)view for:(int)times horizontal:(BOOL)horizontal
{
    CGAffineTransform normal = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform leftShake;
    CGAffineTransform rightShake;
    
    if (horizontal)
    {
        leftShake = CGAffineTransformMakeTranslation(-10, 0);
        rightShake = CGAffineTransformMakeTranslation(10, 0);
    }
    
    else {
        leftShake = CGAffineTransformMakeTranslation(0, -5);
        rightShake = CGAffineTransformMakeTranslation(0, 5);
    }

    view.transform = leftShake;  // starting point
    
    [UIView beginAnimations:@"shake_button"context:NULL];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:times];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    view.transform = rightShake;
    view.transform = normal;  // end here & auto-reverse
    [UIView commitAnimations];
}

@end
