//
//  NewActionViewController.m
//  nextHome
//
//  Created by john on 12/20/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "NewActionViewController.h"
#import "ChildViewController.h"
#import "VBFPopFlatButton.h"

@interface NewActionViewController ()
@property (nonatomic) UIButton *back;

@property (strong,nonatomic) VBFPopFlatButton *backwardButton;
@property (strong,nonatomic) VBFPopFlatButton *forwardButton;

@end

@implementation NewActionViewController

-(id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.devices = [NSArray arrayWithArray:devices];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];

    /* Create new PageViewController */
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    [[self.pageViewController view]setFrame:CGRectMake(0, 0, 320, 620)];
    
    ChildViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:_pageViewController];
    [[self view] addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    /* set up image view */
    UIImage *image = [UIImage imageNamed:@"back"];
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(20, 25, 30, 30)];
    [self.back setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.back];
    [self.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventAllTouchEvents];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)setUpView
{
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor clearColor];
    pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
    

    
    self.backwardButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(80, 15, 40, 40)
                                                         buttonType:buttonBackType
                                                        buttonStyle:buttonPlainStyle
                                              animateToInitialState:YES];
    self.backwardButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
    self.backwardButton.lineThickness = 2;
    self.backwardButton.tintColor = [UIColor colorWithWhite:255 alpha:0.6];
    [self.backwardButton addTarget:self
                               action:@selector(goBack)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backwardButton];

    self.forwardButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(200, 15, 40, 40)
                                                      buttonType:buttonForwardType
                                                     buttonStyle:buttonPlainStyle
                                           animateToInitialState:YES];
    self.forwardButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
    self.forwardButton.lineThickness = 2;
    self.forwardButton.tintColor = [UIColor colorWithWhite:255 alpha:0.6];
    [self.forwardButton addTarget:self
                            action:@selector(goForward)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forwardButton];
}



#pragma mark - UIbuttons Delegate

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (ChildViewController *)viewControllerAtIndex:(NSUInteger)index
{
    ChildViewController *childViewController = [[ChildViewController alloc]initWithDevices:self.devices];
    childViewController.index = index;
    return childViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(ChildViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    
    index --;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(ChildViewController *)viewController index];
    index++;
    
    if (index == 2) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
