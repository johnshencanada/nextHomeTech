//
//  LightBulbRoomCollectionViewController.m
//  nextHome
//
//  Created by john on 9/16/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import "LightBulbRoomCollectionViewController.h"


@interface LightBulbRoomCollectionViewController ()
@property CGRect screenRect;
@property (nonatomic) NSArray *rooms;
@property (nonatomic) NSString *currentRoom;
@property (nonatomic) UILabel *currentRoomLabel;
@property (strong,nonatomic) VBFPopFlatButton *flatRoundedButton;
@property (strong,nonatomic) UIButton *back;
@end

@implementation LightBulbRoomCollectionViewController

static NSString * const reuseIdentifier = @"Room";

-(id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.screenRect = [[UIScreen mainScreen]bounds];
        self.devices = [NSArray arrayWithArray:devices];
        
        UIImage *home = [UIImage imageNamed:@"home_small"];
        UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"Home" image:home tag:0];
        self.tabBarItem = homeTab;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(320, 150);
        layout.minimumInteritemSpacing = 1.0;
        layout.minimumLineSpacing = 1.0;
        layout.headerReferenceSize = CGSizeMake(0,0);
        self = [super initWithCollectionViewLayout:layout];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.rooms = [defaults objectForKey:@"rooms"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    [self checkCurrentRoom];
}

- (void)setUpView
{
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.frame = CGRectMake(0,
                                           self.screenRect.size.height/3,
                                           self.screenRect.size.width,
                                           (2 * self.screenRect.size.height/3));
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[RoomPictureCell class] forCellWithReuseIdentifier:@"Room"];
    
    self.currentRoomLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 60)];
    self.currentRoomLabel.textColor = [UIColor whiteColor];
    self.currentRoomLabel.textAlignment = NSTextAlignmentCenter;
    self.currentRoomLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
    self.currentRoomLabel.text = [NSString stringWithFormat:@"Select Room"];
    [self.view addSubview:self.currentRoomLabel];
    
    UIImage *image = [UIImage imageNamed:@"back"];
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(self.screenRect.size.width/16,
                                                          self.screenRect.size.width/16,
                                                          self.screenRect.size.width/8,
                                                          self.screenRect.size.width/8)];
    [self.back setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.back];
    [self.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventAllTouchEvents];
    
    [self setupAddButton];
}

- (void)setupAddButton
{
    self.flatRoundedButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(130, 80, 60, 60)
                                                         buttonType:buttonAddType
                                                        buttonStyle:buttonRoundedStyle
                                              animateToInitialState:YES];
    
    self.flatRoundedButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
    self.flatRoundedButton.lineThickness = 2;
    [self.flatRoundedButton addTarget:self
                               action:@selector(newRoom)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.flatRoundedButton setTintColor:[UIColor colorWithWhite:255 alpha:0.3]forState:UIControlStateNormal];
    [self.flatRoundedButton setTintColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.view addSubview:self.flatRoundedButton];
}

- (void)checkCurrentRoom
{
    /* Check which room this device is currently in */
    for (Device *device in self.devices)
    {
        for (NSString *room in self.rooms) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSArray *identifiers = [NSArray arrayWithArray:[defaults objectForKey:room]];

            for (NSString *identifier in identifiers) {

                if ([identifier isEqualToString:device.peripheral.identifier.UUIDString]) {
                    self.currentRoom = room;
                    self.currentRoomLabel.text = self.currentRoom;
                }
            }
        }
    }
    
}

- (void)PrintRoomDevices
{
    for (NSString *room in self.rooms) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (room) {
            NSArray *identifiers = [NSArray arrayWithArray:[defaults objectForKey:room]];
        }
    }
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.rooms.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RoomPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Room" forIndexPath:indexPath];
    NSString *roomName = [self.rooms objectAtIndex:indexPath.row];
    [cell setLabelName:roomName];
    [cell setImage:[NSString stringWithFormat:@"Dashboard-%@",roomName]];
    if ([roomName isEqualToString:self.currentRoom]) {
        [cell setIsSelected];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self checkCurrentRoom];
    
    RoomPictureCell *cell = (RoomPictureCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *roomName = [self.rooms objectAtIndex:indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    /* If this peripheral don't belong to any room */
    if (!self.currentRoom) {
        
        /* Make it belong to this room */
        [cell setIsSelected];
        
        /* Save it into data */
        NSMutableArray *devicesUUID = [NSMutableArray arrayWithArray:[defaults objectForKey:roomName]];
        for (Device *device in self.devices) {
            [devicesUUID addObject:device.peripheral.identifier.UUIDString];
        }
        
        /* Remove that saved array and update it */
        self.currentRoom = roomName;
        [defaults setObject:[NSArray arrayWithArray:devicesUUID] forKey:roomName];
        [self PrintRoomDevices];
    }
    
    /* Or it belongs to a room */
    else {

        /* If the user select the same room */
        if ([roomName isEqualToString:self.currentRoom]) {
            
            /* if it's already selected, diselect it */
            if (cell.isSelected) {
                [cell setUnSelected];
                self.currentRoom = NULL;

                /* Remove the device in this room saved in data */
                for (Device *device in self.devices)
                {
                    NSMutableArray *identifiers = [NSMutableArray arrayWithArray:[defaults objectForKey:roomName]];
                    NSString *UUIDString = device.peripheral.identifier.UUIDString;
                    
                    if ([identifiers containsObject:UUIDString]) {
                        [identifiers removeObject:UUIDString];
                        [defaults setObject:[NSArray arrayWithArray:identifiers] forKey:roomName];
                        [defaults synchronize];
                    }
                }
            }
            [self PrintRoomDevices];
        }
        
        /* If the user selects another room */
        else {
            
            /* Remove the devices from its previous room */
            for (Device *device in self.devices)
            {
                NSMutableArray *identifiers = [NSMutableArray arrayWithArray:[defaults objectForKey:self.currentRoom]];
                NSString *UUIDString = device.peripheral.identifier.UUIDString;
                
                if ([identifiers containsObject:UUIDString]) {
                    [identifiers removeObject:UUIDString];
                    [defaults setObject:[NSArray arrayWithArray:identifiers] forKey:self.currentRoom];
                    [defaults synchronize];
                }
            }
            
            /* Deselect all the other cells */
            for (RoomPictureCell *cell in [[self collectionView]visibleCells]) {
                [cell setUnSelected];
            }
            
            self.currentRoom = roomName;
            
            /* Select this room */
            [cell setIsSelected];
            
            /* Update the data */
            NSMutableArray *devicesUUID = [NSMutableArray arrayWithArray:[defaults objectForKey:roomName]];
            for (Device *device in self.devices) {
                [devicesUUID addObject:device.peripheral.identifier.UUIDString];
            }
            
            [defaults setObject:[NSArray arrayWithArray:devicesUUID] forKey:roomName];
            [defaults synchronize];
            [self PrintRoomDevices];
        }
    }
    
    
    if (self.currentRoom) {
        self.currentRoomLabel.text = self.currentRoom;
    }
    
    else {
        self.currentRoomLabel.text = [NSString stringWithFormat:@"Please Select Room"];
    }
    
    [defaults synchronize];
}


- (void)newRoom
{
    NewRoomViewController *newRoomVC = [[NewRoomViewController alloc]init];
    [self.navigationController pushViewController:newRoomVC animated:NO];
}

@end
