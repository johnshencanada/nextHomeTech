//
//  AppDelegate.m
//  Bluetooth
//
//  Created by john on 7/1/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "AppDelegate.h"
#import "MyNavigationController.h"
#import "RoomsCollectionViewController.h"
#import "BackgroundGifViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
            
- (void)setupPageViewController
{
    /* Page Controller Setup */
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = [UIColor clearColor];
}

- (void)setupNotification
{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor whiteColor];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    RoomsCollectionViewController *roomSelector = [[RoomsCollectionViewController alloc]init];
    MyNavigationController *roomsSelectorNavController = [[MyNavigationController alloc]initWithRootViewController:roomSelector];
    
    BackgroundGifViewController *backgroundGIF = [[BackgroundGifViewController alloc]init];
    self.window.rootViewController = roomsSelectorNavController;
    [self.window makeKeyAndVisible];
    
    [self setupPageViewController];
    [self setupNotification];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
