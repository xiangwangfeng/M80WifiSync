//
//  AppDelegate.m
//  M80WifiSync
//
//  Created by amao on 1/12/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "AppDelegate.h"
#import "M80DirectoryViewController.h"
#import "M80PathManager.h"
#import "M80HttpServer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *dir = [[M80PathManager sharedManager] fileStoragePath];
    M80DirectoryViewController *vc = [[M80DirectoryViewController alloc] initWithDir:dir];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [[M80HttpServer sharedServer] start];
    
    NSLog(@"%@",[[M80HttpServer sharedServer] url]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
