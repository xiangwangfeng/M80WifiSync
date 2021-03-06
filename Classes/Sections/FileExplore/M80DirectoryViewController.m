//
//  M80DirectoryViewController.m
//  M80WifiSync
//
//  Created by amao on 1/12/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80DirectoryViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "M80Kit.h"
#import "M80PathManager.h"
#import "M80DirectoryDatasource.h"
#import "M80ExploreViewController.h"

static NSString *M80DirectoryCellReuseIdentify = @"M80DirectoryCellReuseIdentify";

@interface M80DirectoryViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,copy)      NSString *dir;
@property (nonatomic,strong)    M80DirectoryDatasource  *datasource;
@property (nonatomic,strong)    M80FolderMonitor *monitor;
@end

@implementation M80DirectoryViewController
- (instancetype)initWithDir:(NSString *)dir
{
    if (self = [super init])
    {
        _dir = [dir copy];
        _datasource = [M80DirectoryDatasource datasource:dir];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:M80DirectoryCellReuseIdentify];
    
    [self.tableView m80HideExtraCell];
    
    [self setupNavBar];
    
    
    
    __weak typeof(self) weakSelf = self;
    NSURL *url = [NSURL fileURLWithPath:_dir];
    _monitor = [M80FolderMonitor monitor:url
                                   block:^{
                                       [weakSelf reloadAll];
                                   }];
    [_monitor start];
}

- (void)reloadAll
{
    _datasource = [M80DirectoryDatasource datasource:_dir];
    [self.tableView reloadData];
}

- (void)setupNavBar
{
    NSString *fileStorage = [[M80PathManager sharedManager] fileStoragePath];
    NSString *title = [[_datasource dir] isEqualToString:fileStorage] ?
    NSLocalizedString(@"我的文件", nil) : [[_datasource dir] lastPathComponent];
    self.navigationItem.title = title;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                          target:self
                                                                          action:@selector(addNewItem:)];
    
    self.navigationItem.rightBarButtonItem = item;
}


#pragma mark - 添加新的数据
- (void)addNewItem:(id)sender
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *addNewDirAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"新建目录", nil)
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                [self addNewDir];
                                                            }];
    [controller addAction:addNewDirAction];
    
    UIAlertAction *addNewMediaAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"添加多媒体", nil)
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  [self addNewMedia];
                                                              }];
    [controller addAction:addNewMediaAction];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [controller addAction:cancel];
    
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

- (void)addNewDir
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
                                                     style:UIAlertActionStyleCancel
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

- (void)addNewMedia
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.mediaTypes = @[(__bridge NSString *)kUTTypeMovie,(__bridge NSString *)kUTTypeImage];
    ipc.delegate = self;
    
    [self presentViewController:ipc
                       animated:YES
                     completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    [self.datasource createMedia:info
                      completion:^{
                          [weakSelf.tableView reloadData];
                      }];
    
    [picker dismissViewControllerAnimated:YES
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
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
        NSString *dir = [mode.filepath stringByAppendingString:@"/"];
        M80DirectoryViewController *vc = [[M80DirectoryViewController alloc] initWithDir:dir];
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
