//
//  NewRoomChildViewController.m
//  nextHome
//
//  Created by john on 3/29/15.
//  Copyright (c) 2015 Banana Technology. All rights reserved.
//

#import "NewRoomChildViewController.h"

@interface NewRoomChildViewController ()
@property CGRect screenRect;
@property (strong,nonatomic) UIImageView *roomIcon;
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) UILabel *titleLabel;
@end

@implementation NewRoomChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // screenRect
    self.screenRect = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                          0,
                                                          self.screenRect.size.width,
                                                          self.screenRect.size.height/4)];
    top.backgroundColor = [UIColor colorWithRed:0.204 green:0.667 blue:0.863 alpha:0.95];

    [self.view addSubview:top];
    
    // room
    self.roomIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.screenRect.size.width/2 - (self.screenRect.size.width/12),
                                                                 self.screenRect.size.width/7,
                                                                 self.screenRect.size.width/6,
                                                                 self.screenRect.size.width/6)];
    
    // title
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, self.screenRect.size.width, self.screenRect.size.width/5)];
                       
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
    
    if (self.index == 0) {
        self.image = [UIImage imageNamed:@"livingroom"];
        self.roomIcon.image = self.image;
        [self.view addSubview:self.roomIcon];
        
        self.titleLabel.text = [NSString stringWithFormat:@"Livingroom"];
        [self.view addSubview:self.titleLabel];
    }
    
    else if (self.index == 1) {
        self.image = [UIImage imageNamed:@"bedroom"];
        self.roomIcon.image = self.image;
        [self.view addSubview:self.roomIcon];
        
        self.titleLabel.text = [NSString stringWithFormat:@"bedroom"];
        [self.view addSubview:self.titleLabel];
    }
    
    else if (self.index == 2) {
        self.image = [UIImage imageNamed:@"kitchen"];
        self.roomIcon.image = self.image;
        [self.view addSubview:self.roomIcon];
        
        self.titleLabel.text = [NSString stringWithFormat:@"kitchen"];
        [self.view addSubview:self.titleLabel];
    }
    
    else {
        self.image = [UIImage imageNamed:@"bathroom"];
        self.roomIcon.image = self.image;
        [self.view addSubview:self.roomIcon];
        
        self.titleLabel.text = [NSString stringWithFormat:@"bathroom"];
        [self.view addSubview:self.titleLabel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
