//
//  M80ServerViewController.m
//  M80WifiSync
//
//  Created by amao on 1/13/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80ServerViewController.h"
#import "M80HttpServer.h"
#import "M80DirectoryViewController.h"
#import "M80PathManager.h"
#import "M80Kit.h"
#import "Reachability.h"

@interface M80ServerViewController ()
@property (strong, nonatomic) IBOutlet UIButton *filesButton;
@property (strong, nonatomic) IBOutlet UILabel *linkLabel;
@property (strong, nonatomic) IBOutlet UILabel *networkLabel;
@property (strong, nonatomic) M80HttpServer *server;
@property (strong, nonatomic) Reachability *reachability;
@end

@implementation M80ServerViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = NSLocalizedString(@"文件传输", nil);
    self.view.backgroundColor = M80RGB(0xEDEDED);

    _server = [[M80HttpServer alloc] init];
    
    [_filesButton setBackgroundImage:[[UIColor orangeColor] m80ToImage]
                            forState:UIControlStateNormal];
    
    CGSize buttonSize = [_filesButton bounds].size;
    [_filesButton.layer setCornerRadius:buttonSize.width / 2];
    [_filesButton.layer setMasksToBounds:YES];
    [_filesButton.layer setBorderColor:[UIColor whiteColor].CGColor];

    [self resetNetworkUI];
    
    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNetChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
}

- (void)resetNetworkUI
{
    _linkLabel.text = [_server url];
    NSString *ssid = [[M80NetworkConfig currentConfig] currentSSID];
    _networkLabel.text = !ssid ? NSLocalizedString(@"未使用Wifi", nil) :
    [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"当前网络", nil),ssid];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)onNetChanged:(NSNotification *)aNotification
{
    [self resetNetworkUI];
}

- (IBAction)showFiles:(id)sender {
    NSString *dir = [[M80PathManager sharedManager] fileStoragePath];
    M80DirectoryViewController *vc = [[M80DirectoryViewController alloc] initWithDir:dir];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}


@end
