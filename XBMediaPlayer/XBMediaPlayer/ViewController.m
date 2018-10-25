//
//  ViewController.m
//  XBMediaPlayer
//
//  Created by xxb on 2017/6/24.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "XBAudioPlayer.h"
#import "XBAudioRecorder.h"
#import "XBViewController.h"
#import "XBVideoViewController.h"

@interface ViewController ()
@property (nonatomic,strong) XBAudioPlayer *audioPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",NSHomeDirectory());
    
    self.view.backgroundColor = [UIColor greenColor];

}

//进入音频播放页面
- (IBAction)yinpin:(id)sender {
    
    [self.navigationController pushViewController:[XBViewController new] animated:YES];
}

//进入视频播放页面
- (IBAction)shipin:(id)sender {
    [self.navigationController pushViewController:[XBVideoViewController new] animated:YES];
}

///懒加载音频播放器
-(XBAudioPlayer *)audioPlayer
{
    if (_audioPlayer == nil)
    {
        _audioPlayer = [XBAudioPlayer new];
        
        _audioPlayer.b_autoPlayNext = YES;
        _audioPlayer.bl_playProgress = ^(XBAVPlayer *player, CGFloat progress, CGFloat current, CGFloat total) {
            NSLog(@"当前进度：%f, 播放了：%f, 总共：%f",progress,current,total);
        };
        
        _audioPlayer.bl_bufferBlock = ^(XBAVPlayer *player, CGFloat totalBuffer) {
            NSLog(@"已经缓冲了：%f",totalBuffer);
        };
    }
    return _audioPlayer;
}


//开始录音
- (IBAction)start:(UIButton *)sender
{
    if (self.audioPlayer.b_isPlaying)
    {
        [self.audioPlayer pause];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"音量大小%f",[[XBAudioRecorder shared] volumePow]);
    }];
    
    [[XBAudioRecorder shared] record];
    NSLog(@"start");
}
//暂停录音
- (IBAction)pause:(UIButton *)sender
{
    [[XBAudioRecorder shared] pause];
    NSLog(@"pause");
}
//恢复录音
- (IBAction)resume:(UIButton *)sender
{
    [[XBAudioRecorder shared] resume];
    NSLog(@"resume");
}
//停止录音
- (IBAction)stop:(UIButton *)sender
{
    [[XBAudioRecorder shared] stop];
    NSLog(@"stop");
}
//播放录音
- (IBAction)playRecord:(UIButton *)sender
{
    
    NSLog(@"playRecord");
    self.audioPlayer.arr_urlStrs = @[[[XBAudioRecorder shared] getSavePath]];
    [self.audioPlayer playWithErrorBlock:nil];

}




@end

