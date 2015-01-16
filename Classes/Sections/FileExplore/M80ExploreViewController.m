//
//  M80ExploreViewController.m
//  M80WifiSync
//
//  Created by amao on 1/16/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80ExploreViewController.h"
@import QuickLook;
@import MediaPlayer;

@interface M80ImageViewController : M80ExploreViewController
@end
@interface M80VideoViewController : M80ExploreViewController
@property (nonatomic,strong)    MPMoviePlayerController *mediaPlayer;
@end
@interface M80FileExploreViewController : M80ExploreViewController<QLPreviewControllerDataSource>
@end

@interface M80ExploreViewController ()
@property (nonatomic,copy)    NSString    *filepath;
@end

@implementation M80ExploreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                           target:self
                                                                           action:@selector(onShare:)];
    
    self.navigationItem.rightBarButtonItem = right;
}

- (void)onShare:(id)sender
{
    NSLog(@"..");
}

+ (NSString *)vcClassName:(NSString *)ext
{
    static NSDictionary *classDict = nil;
    if (classDict == nil)
    {
        classDict = @{@"png"        : @"M80ImageViewController",
                      @"jpeg"       : @"M80ImageViewController",
                      @"jpg"        : @"M80ImageViewController",
                      @"gif"        : @"M80ImageViewController",
                      
                      @"mp4"        : @"M80VideoViewController",
                      @"3gp"        : @"M80VideoViewController",
                      @"mov"        : @"M80VideoViewController",
                      @"m4v"        : @"M80VideoViewController",};
    }
    return [classDict objectForKey:ext];
}


+ (instancetype)exploreViewController:(NSString *)filepath
{
    M80ExploreViewController *vc = nil;
    NSString *ext = [[filepath pathExtension] lowercaseString];
    NSString *className = [self vcClassName:ext];
    if (className)
    {
        vc = [[NSClassFromString(className) alloc] init];
    }
    else
    {
        vc = [[M80FileExploreViewController alloc] init];
    }
    vc.filepath = filepath;
    return vc;
}
@end


#pragma mark - 图片预览
@implementation M80ImageViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageWithContentsOfFile:self.filepath];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:imageView];
}
@end


#pragma mark - 视频预览
@implementation M80VideoViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [NSURL fileURLWithPath:self.filepath];
    _mediaPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [self.view addSubview:_mediaPlayer.view];
    [_mediaPlayer.view setFrame:self.view.bounds];
    [_mediaPlayer.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [_mediaPlayer play];
}

@end

#pragma mark - 文件预览
@implementation M80FileExploreViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL fileURLWithPath:self.filepath];
    
    if ([QLPreviewController canPreviewItem:url])
    {
        [self addQLPreview];
    }
    else
    {
        [self addErrorTip];
    }
}

- (void)addQLPreview
{
    QLPreviewController *vc = [[QLPreviewController alloc] init];
    vc.dataSource = self;
    [self addChildViewController:vc];
    [vc.view setFrame:self.view.bounds];
    [vc.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:vc.view];
}

- (void)addErrorTip
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"不支持的文件类型", nil)
                                                                        message:NSLocalizedString(@"当前文件展示不支持预览", nil)
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
                                    
}

#pragma mark - QL
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:self.filepath];
}

@end