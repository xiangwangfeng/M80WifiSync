//
//  M80ServerViewController.m
//  M80WifiSync
//
//  Created by amao on 1/13/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80ServerViewController.h"
#import "M80DirectoryViewController.h"
#import "M80PathManager.h"
#import "M80Kit.h"
#import "Reachability.h"
#import "UIView+Toast.h"

static NSString *wifiTag = @"wifi_tag";
static NSString *urlTag = @"url_tag";

@interface M80ServerViewController ()
@property (strong, nonatomic) Reachability *reachability;
@property (strong, nonatomic) M80HttpServer *server;
@end

@implementation M80ServerViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = NSLocalizedString(@"设置", nil);
    self.view.backgroundColor = [UIColor whiteColor];

    _server = [[M80HttpServer alloc] init];

    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNetChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [self setupForm];
}


- (void)setupForm
{
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"设置"];
    
    {
        XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:@"文件传输"];
        [form addFormSection:section];
        
        {
            __weak typeof(self) weakSelf = self;
            XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:wifiTag
                                                                             rowType:XLFormRowDescriptorTypeBooleanSwitch
                                                                               title:@"开启 Wifi 传输"];
            [section addFormRow:row];
            row.onChangeBlock =  ^(id __nullable oldValue,id __nullable newValue,XLFormRowDescriptor* __nonnull rowDescriptor)
            {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf updateUI];
            };


        }
        
        {
            XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:urlTag
                                                                             rowType:XLFormRowDescriptorTypeInfo
                                                                               title:@"地址"];
            [section addFormRow:row];
            row.hidden = @(YES);
        }
        
    }
    

    self.form = form;
}

- (void)onNetChanged:(NSNotification *)aNotification
{
    
}

- (void)updateUI
{
    //这个地方如果失败了，提示也没啥意义了。。。╮(╯▽╰)╭
    XLFormRowDescriptor *wifi = [self.form formRowWithTag:wifiTag];
    XLFormRowDescriptor *url = [self.form formRowWithTag:urlTag];
    BOOL on = [wifi.value boolValue];
    if (on)
    {
        [_server start];
    }
    else
    {
        [_server stop];
    }
    BOOL serverOn = [_server isRunning];
    
    if (serverOn != on)
    {
        on = serverOn;
        wifi.value = @(on);
    }
    url.value = [_server url];
    url.hidden = @(!on);

}




@end
