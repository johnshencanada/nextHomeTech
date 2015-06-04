//
//  DeviceCell.m
//  nextHome
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import "DeviceCell.h"

@implementation DeviceCell

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 106, 20)];
        self.name.textAlignment = NSTextAlignmentCenter;
        self.name.font = [UIFont fontWithName:@"GillSans-Light" size:15.0];
        self.name.textColor = [UIColor whiteColor];
//        [self.contentView addSubview:self.name];

        self.logo = [[RoomLogoButton alloc]initWithFrame:CGRectMake(23, 15, 55, 55)];
        [self.contentView addSubview:self.logo];

        self.connection = [[UIImageView alloc]initWithFrame:CGRectMake(10,10,10,10)];
    }
    return self;
}

- (void)setLogoImage:(NSString *)logoName
{
    UIImage *logoImage;

    if ([logoName isEqualToString:@"nextBulb-mega"])
    {
        logoImage = [UIImage imageNamed:@"appliance-nextbulb"];
    }
    else if ([logoName isEqualToString:@"nextBulb-nano"])
    {
        logoImage = [UIImage imageNamed:@"appliance-zhengGee"];
    }
    else if ([logoName isEqualToString:@"nextBulb"])
    {
        logoImage = [UIImage imageNamed:@"appliance-nextbulb"];
    }
    else if ([logoName isEqualToString:@"nextDuino"])
    {
        logoImage = [UIImage imageNamed:@"nextDuino"];
    }
    
    [self.logo setBackgroundImage:logoImage forState:UIControlStateNormal];
    self.logo.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setStateImage:(NSString*)state
{
    UIImage *logoImage;
    if ([state isEqualToString:@"Connected"]) {
        [self.connection removeFromSuperview];
        logoImage = [UIImage imageNamed:@"connected-small"];
        self.connection.image = logoImage;
    }
    
    else if ([state isEqualToString:@"Connecting"]) {
        self.connection = [[UIImageView alloc]initWithFrame:CGRectMake(10,10,10,10)];
        self.connection.contentMode = UIViewContentModeScaleAspectFit;
        logoImage = [UIImage imageNamed:@"connecting-small"];
        self.connection.image = logoImage;
    }
    
    else if ([state isEqualToString:@"Disconnected"]) {
        self.connection = [[UIImageView alloc]initWithFrame:CGRectMake(10,10,10,10)];
        self.connection.contentMode = UIViewContentModeScaleAspectFit;
        logoImage = [UIImage imageNamed:@"disconnected-small"];
        self.connection.image = logoImage;
    }
    
    self.connection.image = logoImage;
    self.connection.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.connection];
    [self setupRounedButton];
}

- (void)setupRounedButton
{
    self.flatRoundedButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(86,70,13,13)
                                                         buttonType:buttonForwardType
                                                        buttonStyle:buttonRoundedStyle
                                              animateToInitialState:YES];
    
    self.flatRoundedButton.lineThickness = 2;
    self.flatRoundedButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0.5];
    self.flatRoundedButton.tintColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.flatRoundedButton];
}

- (void)addRoundedButton
{
    NSLog(@"adding rounded button");
    self.flatRoundedButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0.5];
    self.flatRoundedButton.tintColor = [UIColor colorWithWhite:0 alpha:0.5];
}

- (void)removeRounedButton
{
    NSLog(@"Removing rounded button");
    self.flatRoundedButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0];
    self.flatRoundedButton.tintColor = [UIColor colorWithWhite:0 alpha:0];
}

- (void) buttonTapped {
    NSLog(@"hi");
}

@end
