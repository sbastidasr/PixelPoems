//
//  AppDelegate.m
//  FridgeWords
//
//  Created by Sebastian Bastidas on 2/5/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse enableLocalDatastore];
    
    [Parse setApplicationId:@"Lte9mX91dy4NdRlWsJRXflcEygn66KFwRcIyrjAx"
                  clientKey:@"r73ZYF7QjbtH3xEdsjUwna1gLoMQov3ZSKI5Tihy"];

    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    
   return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
     // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self scheduleNotification];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self scheduleNotification];
}


- (void)scheduleNotification
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:60*60*24];
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:60];
    notification.alertBody = @"24 hours passed since last visit :(";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


@end
