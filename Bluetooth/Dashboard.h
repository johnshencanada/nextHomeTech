//
//  Dashboard.h
//  nextHome
//
//  Created by john on 8/16/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBFPopFlatButton.h"

@interface Dashboard : UIView
@property CGRect screenRect;
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) NSString *homeName;
@property (nonatomic) UILabel *homeLabel;

@property (nonatomic) UILabel *state;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *AMPMLabel;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) UIImageView *alarmImageView;
@property (nonatomic) UILabel *RSSILabel;
@property (nonatomic) UILabel *DeviceCount;
@property (nonatomic) UILabel *Average;

@property (nonatomic) UIButton *lightBulb;
@property (nonatomic) UIButton *home;
@property (strong,nonatomic) VBFPopFlatButton *menu;

@property (nonatomic) UIButton *camera;
@property (strong,nonatomic) VBFPopFlatButton *addNewRoom;

@property (nonatomic) UIButton *back;
@property (nonatomic) UIButton *refresh;
@property (nonatomic) UIButton *discover;

- (void)setTitle:(NSString *)title;
- (void)setbackgroundImage:(NSString *)image;
- (void)setBackImage:(NSString *)imageName;
- (void)setRefreshImage:(NSString *)imageName;
@end
