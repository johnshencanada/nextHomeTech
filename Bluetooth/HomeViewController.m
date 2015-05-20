//
//  HomeViewController.m
//  Bluetooth
//
//  Created by john on 9/11/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property CGRect screenRect;
@property (nonatomic) UIButton *back;
@property (nonatomic) UIButton *resetBtn;
@property (nonatomic) UIButton *storeBtn;

@end

@implementation HomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenRect = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    /* blur effect background */
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 600)];
    imageView.image = [UIImage imageNamed:@"house"];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    [self setBackImage:@"back"];
    [self setUpView];
    [self.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setUpAnimation];
}

- (void)setUpView
{
    //resetBtn
    self.resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 600, 280, 50)];
    self.resetBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.resetBtn.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
    [self.resetBtn setTintColor:[UIColor whiteColor]];
    [self.resetBtn setTitle:@"Reset Rooms" forState:UIControlStateNormal];
    [self.resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventAllTouchEvents];
    [self.view addSubview:self.resetBtn];
    
    //storeBtn
    self.storeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 600, 280, 50)];
    self.storeBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.storeBtn.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
    [self.storeBtn setTintColor:[UIColor whiteColor]];
    [self.storeBtn setTitle:@"Next Store" forState:UIControlStateNormal];
    [self.view addSubview:self.storeBtn];
}

- (void)setBackImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(self.screenRect.size.width/16,
                                                          self.screenRect.size.width/16,
                                                          self.screenRect.size.width/8,
                                                          self.screenRect.size.width/8)];
    [self.back setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.back];
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpAnimation
{
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:13
                        options:0
                     animations:^() {
                         self.resetBtn.center = CGPointMake(160, 400);
                         self.storeBtn.center = CGPointMake(160, 460);
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(void)reset
{
    NSLog(@"Resetting Everything!");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defaults dictionaryRepresentation];
    for (id key in dict) {
        [defaults removeObjectForKey:key];
    }
    
}


@end
