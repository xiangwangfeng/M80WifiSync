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

@interface M80ServerViewController ()
@property (strong, nonatomic) IBOutlet UIButton *filesButton;
@property (strong, nonatomic) IBOutlet UILabel *linkLabel;
@property (strong, nonatomic) M80HttpServer *server;
@end

@implementation M80ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"文件传输", nil);
    

    _server = [[M80HttpServer alloc] init];
    _linkLabel.text = [_server url];
    
    CGSize buttonSize = [_filesButton bounds].size;
    [_filesButton.layer setCornerRadius:buttonSize.width / 2];
    [_filesButton.layer setMasksToBounds:YES];
    [_filesButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
