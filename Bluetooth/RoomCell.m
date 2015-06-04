//
//  RoomCell.m
//  nextHome
//
//  Created by john on 8/22/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import "RoomCell.h"

@implementation RoomCell

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.screenRect = frameRect;
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        
        self.logo = [[RoomLogoButton alloc]initWithFrame:CGRectMake(self.screenRect.size.width/13,
                                                                    self.screenRect.size.height/4,
                                                                    self.screenRect.size.height/2,
                                                                    self.screenRect.size.height/2)];
        [self.contentView addSubview:self.logo];

        self.name = [[UILabel alloc]initWithFrame:CGRectMake(self.screenRect.size.width/3.5,
                                                             self.screenRect.size.height/4,
                                                             self.screenRect.size.width/2.5,
                                                             self.screenRect.size.height/2)];
        self.name.textAlignment = NSTextAlignmentLeft;
        self.name.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
        self.name.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.name];
        self.numberOfDevices = 0;
        
        self.numberOfDeviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.screenRect.size.width/1.55,
                                                                            self.screenRect.size.height/2.5,
                                                                            self.screenRect.size.height/4,
                                                                            self.screenRect.size.height/4)];
        self.numberOfDeviceLabel.text = [NSString stringWithFormat:@"%d", self.numberOfDevices];
        self.numberOfDeviceLabel.textColor = [UIColor lightGrayColor];
        self.numberOfDeviceLabel.font = [UIFont fontWithName:@"Bradley Hand" size:10.0];
        
        self.blackCircle = [[BlackCircle alloc]initWithFrame:CGRectMake(self.screenRect.size.width/1.6,
                                                                  self.screenRect.size.height/2.5,
                                                                  self.screenRect.size.height/4,
                                                                  self.screenRect.size.height/4)];
        [self.contentView addSubview:self.blackCircle];
    }
    return self;
}

- (void)setLogoImage:(NSString *)logoName
{
    UIImage *logoImage;
    
    if ([logoName isEqualToString:@"LivingRoom"])
    {
        logoImage = [UIImage imageNamed:@"livingroom"];
    }
    
    else if ([logoName isEqualToString:@"Bathroom"])
    {
        logoImage = [UIImage imageNamed:@"bathroom"];
    }
    
    else if ([logoName isEqualToString:@"Kitchen"])
    {
        logoImage = [UIImage imageNamed:@"kitchen"];
    }
    
    else if ([logoName isEqualToString:@"Bedroom"])
    {
        logoImage = [UIImage imageNamed:@"bedroom"];
    }
    
    else if ([logoName isEqualToString:@"nextBulb-mega"])
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
        [self.numberOfDeviceLabel removeFromSuperview];
        [self.blackCircle removeFromSuperview];
        self.connection = [[UIImageView alloc]initWithFrame:CGRectMake((9.5 * self.screenRect.size.width/12),
                                                                       self.screenRect.size.height/4,
                                                                       self.screenRect.size.height/2,
                                                                       self.screenRect.size.height/2)];
        self.connection.contentMode = UIViewContentModeScaleAspectFit;
        logoImage = [UIImage imageNamed:@"connected"];
        self.connection.image = logoImage;
    }
    
    else if ([state isEqualToString:@"Connecting"]) {
        [self.connection removeFromSuperview];
        [self.numberOfDeviceLabel removeFromSuperview];
        [self.blackCircle removeFromSuperview];
        self.connection = [[UIImageView alloc]initWithFrame:CGRectMake((9.5 * self.screenRect.size.width/12),
                                                                       self.screenRect.size.height/4,
                                                                       self.screenRect.size.height/2,
                                                                       self.screenRect.size.height/2)];
        self.connection.contentMode = UIViewContentModeScaleAspectFit;
        logoImage = [UIImage imageNamed:@"connecting"];
        self.connection.image = logoImage;
    }
    
    else if ([state isEqualToString:@"Disconnected"]) {
        [self.connection removeFromSuperview];
        [self.numberOfDeviceLabel removeFromSuperview];
        [self.blackCircle removeFromSuperview];
        self.connection = [[UIImageView alloc]initWithFrame:CGRectMake((9.5 * self.screenRect.size.width/12),
                                                                       self.screenRect.size.height/4,
                                                                       self.screenRect.size.height/2,
                                                                       self.screenRect.size.height/2)];
        self.connection.contentMode = UIViewContentModeScaleAspectFit;
        logoImage = [UIImage imageNamed:@"disconnected"];
        self.connection.image = logoImage;
    }
    
    else {
        [self.connection removeFromSuperview];
        [self.contentView addSubview:self.blackCircle];
        [self.contentView addSubview:self.numberOfDeviceLabel];
        self.connection = [[UIImageView alloc]initWithFrame:CGRectMake((9.5 * self.screenRect.size.width/12),
                                                                       self.screenRect.size.height/4,
                                                                       self.screenRect.size.height/2,
                                                                       self.screenRect.size.height/2)];
        self.connection.contentMode = UIViewContentModeScaleAspectFit;
        logoImage = [UIImage imageNamed:@"forward2"];
        self.connection.image = logoImage;
    }
    
    [self.contentView addSubview:self.connection];
}

-(void)setNumberOfDevice:(NSUInteger)number
{
    self.numberOfDeviceLabel.text = [NSString stringWithFormat:@"%lu", number];

}

@end
