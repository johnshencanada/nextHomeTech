//
//  BackgroundGifViewController.m
//  nextHome
//
//  Created by john on 1/23/15.
//  Copyright (c) 2015 Banana Technology. All rights reserved.
//

#import "BackgroundGifViewController.h"
#import "IntroductionChildViewController.h"

@interface BackgroundGifViewController ()

@end

@implementation BackgroundGifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackgroundGIF];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    [[self.pageViewController view]setFrame:CGRectMake(0, 0, 320, 620)];
    
    IntroductionChildViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:_pageViewController];
    [[self view] addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}


-(void)loadBackgroundGIF
{
    //load the gif data
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"railway" ofType:@"gif"];
    NSData *gif = [NSData dataWithContentsOfFile:filePath];
    
    //create the webView
    UIWebView *webViewBG = [[UIWebView alloc] initWithFrame:self.view.frame];
    [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    webViewBG.userInteractionEnabled = NO;
    [self.view addSubview:webViewBG];
    
    //add a filter
    UIView *filter = [[UIView alloc] initWithFrame:self.view.frame];
    filter.backgroundColor = [UIColor blackColor];
    filter.alpha = 0.5;
    [self.view addSubview:filter];
}

#pragma mark - Helper Method

- (IntroductionChildViewController *)viewControllerAtIndex:(NSUInteger)index
{
    IntroductionChildViewController *childViewController = [[IntroductionChildViewController alloc]init];
    childViewController.index = index;
    return childViewController;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(IntroductionChildViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    
    index --;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(IntroductionChildViewController *)viewController index];
    index++;
    
    if (index == 4) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 4;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}


@end
