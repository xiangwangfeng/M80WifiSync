//
//  M80ExploreViewController.m
//  M80WifiSync
//
//  Created by amao on 1/16/15.
//  Copyright (c) 2015 www.xiangwangfeng.com. All rights reserved.
//

#import "M80ExploreViewController.h"
#import "UIView+Toast.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "M80Kit.h"

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
    [self fireActions];
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

#pragma mark - 操作
- (void)fireActions
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"保存到相册", nil)
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action){
                                                           [self saveToAlbum];
                                                       }];
    [vc addAction:saveAction];
    
    UIAlertAction *wexinAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"发送图片到微信", nil)
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [self shareToWX];
                                                            
                                                        }];
    [vc addAction:wexinAction];
    
    
    
    UIAlertAction *emoticonAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"发送表情到微信", nil)
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               [self shareEmoticonToWX];
                                                           }];
    [vc addAction:emoticonAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [vc addAction:cancelAction];
    
    
    [self presentViewController:vc
                       animated:YES
                     completion:nil];
}

- (void)saveToAlbum
{
    UIImage *image = [UIImage imageWithContentsOfFile:self.filepath];
    if (image)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        return;
    }
    
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.filepath))
    {
        UISaveVideoAtPathToSavedPhotosAlbum(self.filepath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        return;
    }

    
    [self.view makeToast:NSLocalizedString(@"不支持的文件格式", nil)];
}

- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *) error
  contextInfo:(void *)contextInfo
{
    [self.view makeToast:!error ? NSLocalizedString(@"保存成功", nil) : NSLocalizedString(@"保存失败",nil)
                duration:2
                position:CSToastPositionCenter];
}

- (void)video:(NSString *)videoPath
didFinishSavingWithError:(NSError *) error
  contextInfo:(void *)contextInfo
{
    [self.view makeToast:!error ? NSLocalizedString(@"保存成功", nil) : NSLocalizedString(@"保存失败",nil)
                duration:2
                position:CSToastPositionCenter];

}

- (void)shareToWX
{
    UIImage *image = [UIImage imageWithContentsOfFile:self.filepath];
    if (image)
    {
        WXImageObject *obj = [WXImageObject object];
        obj.imageData = [NSData dataWithContentsOfFile:self.filepath];
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = obj;
        [message setThumbImage:[image m80ScaledWithPixels:40000]];
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.message = message;
        req.scene = WXSceneSession;
        
        [WXApi sendReq:req];
        
    }
    else
    {
        [self.view makeToast:NSLocalizedString(@"文件格式不支持", nil)
                    duration:2
                    position:CSToastPositionCenter];
    }
}

- (void)shareEmoticonToWX
{
    UIImage *image = [UIImage imageWithContentsOfFile:self.filepath];
    if (image)
    {
        NSData *imageData = [NSData dataWithContentsOfFile:self.filepath];
        WXEmoticonObject *obj = [WXEmoticonObject object];
        obj.emoticonData = imageData;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = obj;
        [message setThumbImage:[image m80ScaledWithPixels:40000]];
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.message = message;
        req.scene = WXSceneSession;
        
        [WXApi sendReq:req];

    }
    else
    {
        [self.view makeToast:NSLocalizedString(@"文件格式不支持", nil)
                    duration:2
                    position:CSToastPositionCenter];
    }
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

- (BOOL)isFileImage
{
    return YES;
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

- (BOOL)isFileVideo
{
    return YES;
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
    [self.view makeToast:NSLocalizedString(@"当前文件暂时不支持预览", nil)
                duration:2
                position:CSToastPositionCenter];
    
}



#pragma mark - QLPreview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:[self datasourcePath]];
}

- (NSString *)datasourcePath
{
    NSString *filepath = self.filepath;
    NSString *ext = [[self.filepath pathExtension] lowercaseString];
    if ([ext isEqualToString:@"txt"] ||
        [ext isEqualToString:@"html"])
    {
        NSString *filename = [filepath m80MD5];
        NSString *dstFilepath = [NSString stringWithFormat:@"%@/%@.%@",NSTemporaryDirectory(),filename,ext];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dstFilepath])
        {
            NSString *content = [self fileContent];
            if (content && [content writeToFile:dstFilepath
                                     atomically:YES
                                       encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16)
                                          error:nil])
            {
                
                filepath = dstFilepath;
            }
            
        }
        
    }
    return filepath;
}

- (NSString *)fileContent
{
    NSString *content = [[NSString alloc] initWithContentsOfFile:self.filepath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
    if (content == nil)
    {
        content = [[NSString alloc] initWithContentsOfFile:self.filepath
                                                  encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                                     error:nil];
    }
    return content;
}

@end
