//
//  DeviceCell.h
//  nextHome
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SAMGradientView/SAMGradientView.h>
#import "RoomLogoButton.h"
#import "VBFPopFlatButton.h"

@interface DeviceCell : UICollectionViewCell

@property (strong,nonatomic) VBFPopFlatButton *flatRoundedButton;
@property (nonatomic) RoomLogoButton *logo;
@property (nonatomic) UILabel *name;
@property (nonatomic) UIImageView *connection;

- (void)setLogoImage:(NSString*)logoName;
- (void)setStateImage:(NSString*)state;

- (void)addRoundedButton;
- (void)removeRounedButton;

@end
