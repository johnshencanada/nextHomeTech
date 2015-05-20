//
//  RoomsCollectionViewController.h
//  nextHome
//
//  Created by john on 8/22/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import "Device.h"
#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface RoomsCollectionViewController : UICollectionViewController <CBCentralManagerDelegate, CBPeripheralDelegate, HMHomeManagerDelegate>


@end
