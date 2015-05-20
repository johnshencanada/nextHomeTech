//
//  RoomPictureCell.m
//  nextHome
//
//  Created by john on 9/16/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import "RoomPictureCell.h"

@implementation RoomPictureCell

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.isSelected = false;
        
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self.imageView setImage: [UIImage imageNamed:@"Dashboard-Restroom"]];
        self.imageView.alpha = 0.4;
        [self addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc]initWithFrame:self.bounds];
        [self.textLabel setText:@"John's Room"];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont fontWithName:@"GillSans-Light" size:50.0];
        self.textLabel.alpha = 0.7;
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void) setUnSelected {
    self.imageView.alpha = 0.4;
    self.isSelected = false;
}

- (void) setIsSelected {
    self.imageView.alpha = 0.8;
    self.isSelected = true;
}

- (void) setLabelName:(NSString*)name
{
    [self.textLabel setText:name];
}

- (void) setImage:(NSString*)imageName
{
    [self.imageView setImage:[UIImage imageNamed:imageName]];
}

@end
