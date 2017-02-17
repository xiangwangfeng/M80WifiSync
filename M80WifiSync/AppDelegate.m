//
//  AppDelegate.m
//  M80WifiSync
//
//  Created by amao on 1/12/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "M80ServerViewController.h"
#import "M80DirectoryViewController.h"
#import "M80PathManager.h"

@interface AppDelegate ()<WXApiDelegate>

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    [self initUIAppearance];
    
    NSMutableArray *vcs = [NSMutableArray array];
    {
        NSString *dir = [[M80PathManager sharedManager] fileStoragePath];
        M80DirectoryViewController *vc = [[M80DirectoryViewController alloc] initWithDir:dir];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [vcs addObject:nav];
    }
    {
        M80ServerViewController *vc = [[M80ServerViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [vcs addObject:nav];
    }
    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController setViewControllers:vcs];
    
    
    
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabController;
    [self.window makeKeyAndVisible];
    
    [WXApi registerApp:@"wx1ab7c4f3991eb5eb"];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

- (void)initUIAppearance
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes
                                                forState:UIControlStateNormal];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url
                       delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url
                       delegate:self];
}

-(void)onReq:(BaseReq*)req
{

}

-(void)onResp:(BaseResp*)resp
{

}

@end
