//
//  AppDelegate.m
//  SPContactApp
//
//  Created by popovychs on 02.11.15.
//  Copyright © 2015 popovychs. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //[self.window setTintColor:[UIColor whiteColor]];
    //[self.window setBackgroundColor:[UIColor blackColor]];
    
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance]setBarTintColor :[UIColor blackColor]];
    [self appRun];
    
    return YES;
}

- (void) applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - NSUserDefaults

- (void) appRun
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:@"firstRun"]) {
        [userDefaults setBool:YES forKey:@"isFirstNameOrLastName"];
        [userDefaults setBool:NO forKey:@"isWhiteOfBlackColorTheme"];
    }
}

@end
