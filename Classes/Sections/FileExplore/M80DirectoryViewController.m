//
//  M80DirectoryViewController.m
//  M80WifiSync
//
//  Created by amao on 1/12/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80DirectoryViewController.h"
#import "M80PathManager.h"
#import "M80DirectoryDatasource.h"
#import "M80ExploreViewController.h"

static NSString *M80DirectoryCellReuseIdentify = @"M80DirectoryCellReuseIdentify";

@interface M80DirectoryViewController ()
@property (nonatomic,strong)    M80DirectoryDatasource  *datasource;
@end

@implementation M80DirectoryViewController
- (instancetype)initWithDir:(NSString *)dir
{
    if (self = [super init])
    {
        _datasource = [M80DirectoryDatasource datasource:dir];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:M80DirectoryCellReuseIdentify];
    
    [self setupNavBar];
}

- (void)setupNavBar
{
    NSString *fileStorage = [[M80PathManager sharedManager] fileStoragePath];
    NSString *title = [[_datasource dir] isEqualToString:fileStorage] ?
    NSLocalizedString(@"我的文件", nil) : [[_datasource dir] lastPathComponent];
    self.navigationItem.title = title;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                          target:self
                                                                          action:@selector(addNewDir:)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    if ([self.navigationController.viewControllers count] == 1)
    {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                              target:self
                                                                              action:@selector(back:)];
        
        self.navigationItem.leftBarButtonItem = item;

    }
}


#pragma mark - 添加目录
- (void)addNewDir:(id)sender
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"新建目录", nil)
                                                                        message:@""
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(controller) weakController = controller;
    
    [controller addTextFieldWithConfigurationHandler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   
                                                   NSString *text = [[[weakController textFields] firstObject] text];
                                            
                                                   [self fireAction:text];
        
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    
    [controller addAction:ok];
    [controller addAction:cancel];
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}


- (void)fireAction:(NSString *)text
{
    if ([self.datasource createDir:text])
    {
        [self.tableView reloadData];
    }
}

#pragma mark -返回
- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.datasource files] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *files = [self.datasource files];
    M80FileModel *mode = [files objectAtIndex:[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:M80DirectoryCellReuseIdentify];
    cell.imageView.image = mode.icon;
    cell.textLabel.text = mode.filename;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *files = [self.datasource files];
    M80FileModel *mode = [files objectAtIndex:[indexPath row]];
    if (mode.isDir)
    {
        M80DirectoryViewController *vc = [[M80DirectoryViewController alloc] initWithDir:mode.filepath];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        M80ExploreViewController *vc = [M80ExploreViewController exploreViewController:mode.filepath];
        if (vc)
        {
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        M80FileModel *mode = [[self.datasource files] objectAtIndex:[indexPath row]];
        if ([self.datasource removeFile:mode.filepath])
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}


@end
