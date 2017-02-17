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
@property (strong, nonatomic) M80HttpServer *server;
@property (strong, nonatomic) Reachability *reachability;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation M80ServerViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = NSLocalizedString(@"使用说明", nil);
    self.view.backgroundColor = [UIColor whiteColor];

    _server = [[M80HttpServer alloc] init];

    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNetChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    _textView.dataDetectorTypes = UIDataDetectorTypeLink;
    [self updateUI];
}

- (void)updateUI
{
    BOOL wifiOn = [_reachability isReachableViaWiFi];
    if (wifiOn)
    {
        _textView.text = [NSString stringWithFormat:@"请在电脑浏览器中输入以下网址\n%@\n并保证手机和电脑处于同一网络下",[_server url]];
    }
    else
    {
        _textView.text = @"手机没有接入 wifi，请连接 wifi，并保证手机和电脑处于同一网络下";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)onNetChanged:(NSNotification *)aNotification
{
    [self updateUI];
}


@end
