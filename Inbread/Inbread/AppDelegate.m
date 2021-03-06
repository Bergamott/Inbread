//
//  AppDelegate.m
//  Inbread
//
//  Created by Karl on 2014-08-10.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import "AppDelegate.h"
#import "DataHandler.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary
                                 dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:TRUE],@"soundOn",
                                 [NSNumber numberWithBool:TRUE],@"musicOn",
                                 nil];
    [defaults registerDefaults:appDefaults];
    
    NSMutableArray *highscores = [[defaults objectForKey:@"highscores"] mutableCopy];
    if (highscores == NULL)
    {
        highscores = [[NSMutableArray alloc] initWithCapacity:NUM_LEVELS];
        for (int i=0;i<NUM_LEVELS;i++)
            [highscores addObject:[NSNumber numberWithInt:0]];
        [defaults setObject:highscores forKey:@"highscores"];
        [defaults synchronize];
    }
    else if (highscores.count < NUM_LEVELS) // For when adding new restaurants
    {
        int j = NUM_LEVELS - (int)highscores.count;
        for (int i=0;i<j;i++)
            [highscores addObject:[NSNumber numberWithInt:0]];
        [defaults setObject:highscores forKey:@"highscores"];
        [defaults synchronize];
    }
    [[DataHandler sharedDataHandler] loadEverything];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
