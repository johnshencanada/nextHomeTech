//
//  DevicesCollectionViewController.h
//  nextHome
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import "Device.h"
#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "VBFPopFlatButton.h"

@interface DevicesCollectionViewController : UICollectionViewController <CBCentralManagerDelegate,CBPeripheralDelegate, HMHomeManagerDelegate >

- (instancetype)initWithName:(NSString *)name andDevice:(NSArray *)devices;

@end
