//
//  IntroductionChildViewController.m
//  nextHome
//
//  Created by john on 1/23/15.
//  Copyright (c) 2015 Banana Technology. All rights reserved.
//

#import "IntroductionChildViewController.h"

@interface IntroductionChildViewController ()

@end

@implementation IntroductionChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(80, 60, 160, 160)];
    [self.view addSubview: self.contentView];

    if (self.index == 0) {
        self.contentView.backgroundColor = [UIColor greenColor];
    }
    
    else if (self.index == 1) {
        self.contentView.backgroundColor = [UIColor blackColor];
    }
    
    else if (self.index == 2) {
        self.contentView.backgroundColor = [UIColor yellowColor];
    }
    
    else {
        self.contentView.backgroundColor = [UIColor purpleColor];
    }
}

@end
