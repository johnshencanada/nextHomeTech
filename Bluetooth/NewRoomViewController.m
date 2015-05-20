//
//  NewRoomViewController.m
//  Bluetooth
//
//  Created by john on 9/11/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "NewRoomViewController.h"

@interface NewRoomViewController ()
@property CGRect screenRect;
@property (nonatomic) UIButton *back;
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong,nonatomic) UIButton *retakeButton;
@property (strong,nonatomic) UIButton *goButton;

@end

@implementation NewRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //screenRect
    self.screenRect = [[UIScreen mainScreen] bounds];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // camera
    self.camera = [[LLSimpleCamera alloc] initWithQuality:CameraQualityPhoto andPosition:CameraPositionBack];
    [self.camera attachToViewController:self withFrame:CGRectMake(0,
                                                                  0,
                                                                  self.screenRect.size.width,
                                                                  self.screenRect.size.height/2)];
    self.camera.fixOrientationAfterCapture = NO;
    
    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        NSLog(@"Device changed.");
        
        // device changed, check if flash is available
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
            
            if(camera.flash == CameraFlashOff) {
                weakSelf.flashButton.selected = NO;
            }
            else {
                weakSelf.flashButton.selected = YES;
            }
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodePermission) {
                if(weakSelf.errorLabel)
                    [weakSelf.errorLabel removeFromSuperview];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"We need permission for the camera.\nPlease go to your settings.";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(self.screenRect.size.width / 2.0f, self.screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
    
    // ----- camera buttons -------- //
    
    // snap button to capture image
    self.snapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.snapButton.frame = CGRectMake(self.screenRect.size.width/2 - (self.screenRect.size.width/8),
                                       self.screenRect.size.height - (self.screenRect.size.width/3),
                                       (self.screenRect.size.width/4),
                                       (self.screenRect.size.width/4));
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius = self.snapButton.frame.size.width/2.0f;
    self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.snapButton.layer.borderWidth = 2.0f;
    self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.snapButton.layer.shouldRasterize = YES;
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    
    // button to toggle flash
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashButton.frame = CGRectMake(0,
                                        self.screenRect.size.height/4,
                                        (self.screenRect.size.width/5),
                                        (self.screenRect.size.width/5));
    [self.flashButton setImage:[UIImage imageNamed:@"camera-flash-off.png"] forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"camera-flash-on.png"] forState:UIControlStateSelected];
    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    // button to toggle camera positions
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton.frame = CGRectMake(self.screenRect.size.width - (self.screenRect.size.width/5),
                                         self.screenRect.size.height/4,
                                         (self.screenRect.size.width/5),
                                         (self.screenRect.size.width/5));
    [self.switchButton setImage:[UIImage imageNamed:@"camera-switch.png"] forState:UIControlStateNormal];
    self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchButton];
    
    [self setUpGoButton];
    
    // page view
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor clearColor];
    pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    [[self.pageViewController view]setFrame:CGRectMake(0,
                                                       0,
                                                       self.screenRect.size.width,
                                                       (5 * self.screenRect.size.height/16))];
    
    NewRoomChildViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:_pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
}


#pragma mark - MVC life cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    // start the camera
    [self.camera start];
    [[self view] addSubview:_pageViewController.view];
    
    // go Back
    UIImage *image = [UIImage imageNamed:@"back"];
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(self.screenRect.size.width/16,
                                                          self.screenRect.size.width/16,
                                                          self.screenRect.size.width/8,
                                                          self.screenRect.size.width/8)];
    [self.back setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.back];
    [self.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // stop the camera
    [self.camera stop];
}



- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    self.camera.view.frame = CGRectMake(0,
                                        0,
                                        self.screenRect.size.width,
                                        self.screenRect.size.height);
    
    //    self.snapButton.center = self.view.contentCenter;
    //    self.snapButton.bottom = self.view.height - 15;
    //
    //    self.flashButton.center = self.view.contentCenter;
    //    self.flashButton.top = 5.0f;
    //
    //    self.switchButton.top = 5.0f;
    //    self.switchButton.right = self.view.width - 5.0f;
}


#pragma mark - Helper Methods

- (void)setUpGoButton
{
    self.retakeButton = [[UIButton alloc]initWithFrame:CGRectMake(0,
                                                                  self.screenRect.size.height + self.screenRect.size.height/8,
                                                                  self.screenRect.size.width/2,
                                                                  self.screenRect.size.height/8)];
    [self.retakeButton setTitle:@"Retake" forState:UIControlStateNormal];
    [self.retakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.retakeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.retakeButton.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:40];
    self.retakeButton.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:59.0f/255.0f blue:30.0f/255.0f alpha:0.4];
    [self.retakeButton addTarget:self action:@selector(retake) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.retakeButton];

    self.goButton = [[UIButton alloc]initWithFrame:CGRectMake(self.screenRect.size.width/2,
                                                              self.screenRect.size.height + self.screenRect.size.height/8,
                                                              self.screenRect.size.width/2,
                                                              self.screenRect.size.height/8)];
    [self.goButton setTitle:@"Go" forState:UIControlStateNormal];
    [self.goButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.goButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.goButton.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:40];
    self.goButton.backgroundColor = [UIColor colorWithRed:90.0f/255.0f green:212.0f/255.0f blue:39.0f/255.0f alpha:0.4];
    [self.goButton addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goButton];
}

- (void) retake
{
    [self.camera start];
    [self.view addSubview:self.flashButton ];
    [self.view addSubview:self.switchButton ];
    [self.view addSubview:self.snapButton ];
    
    //red
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:13
                        options:0
                     animations:^() {
                         self.retakeButton.center = CGPointMake(self.screenRect.size.width/4,
                                                                self.screenRect.size.height + self.screenRect.size.height/16);
                     }
                     completion:^(BOOL finished) {
                     }];
    
    //green
    [UIView animateWithDuration:1.5
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:13
                        options:0
                     animations:^() {
                         self.goButton.center = CGPointMake((3 * self.screenRect.size.width/4),
                                                            self.screenRect.size.height + self.screenRect.size.height/16);
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(void) go
{
    
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)popupSelection
{
    //red
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:13
                        options:0
                     animations:^() {
                         self.retakeButton.center = CGPointMake(80, self.screenRect.size.height - self.screenRect.size.height/16);
                     }
                     completion:^(BOOL finished) {
                     }];
    
    //green
    [UIView animateWithDuration:1.5
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:13
                        options:0
                     animations:^() {
                         self.goButton.center = CGPointMake(240, self.screenRect.size.height - self.screenRect.size.height/16);
                     }
                     completion:^(BOOL finished) {
                     }];
}


#pragma mark - Camera Delegates

- (void)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
}

- (void)flashButtonPressed:(UIButton *)button {
    
    if(self.camera.flash == CameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:CameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:CameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
        }
    }
}

- (void)snapButtonPressed:(UIButton *)button {
    
    // capture
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            
            // we should stop the camera, since we don't need it anymore. We will open a new vc.
            // this very important, otherwise you may experience memory crashes
            [camera stop];
            
            // show the image
//            ImageViewController *imageVC = [[ImageViewController alloc] initWithImage:image];
//            [self presentViewController:imageVC animated:NO completion:nil];
        }
        else {
            NSLog(@"An error has occured: %@", error);
        }
        
    } exactSeenImage:YES];
    
    [self.flashButton removeFromSuperview];
    [self.switchButton removeFromSuperview];
    [self.snapButton removeFromSuperview];
    [self popupSelection];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


#pragma mark - Page View Controller Data Source

- (NewRoomChildViewController *)viewControllerAtIndex:(NSUInteger)index
{
    NewRoomChildViewController *childViewController = [[NewRoomChildViewController alloc]init];
    childViewController.index = index;
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(NewRoomChildViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    
    index --;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(NewRoomChildViewController *)viewController index];
    index++;
    
    if (index == 10) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 10;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
