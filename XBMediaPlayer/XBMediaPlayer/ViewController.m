//
//  ViewController.m
//  XBMediaPlayer
//
//  Created by xxb on 2017/6/24.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "ViewController.h"
#import "XBVideoPlayer.h"
#import "Masonry.h"
#import "XBAudioPlayer.h"
#import "XBAudioRecorder.h"
#import "XBViewController.h"
#import "XBVideoViewController.h"


@interface ViewController ()
@property (nonatomic,strong) XBVideoPlayer *videoplayer;
@property (nonatomic,strong) XBAudioPlayer *audioPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",NSHomeDirectory());
    
    self.view.backgroundColor = [UIColor greenColor];
    
    /*
    [self.videoplayer playWithErrorBlock:^(XBAVPlayer *player, XBAVPlayerError xbError) {
        NSLog(@"出错了");
    }];
    */
    //[self.audioPlayer playWithErrorBlock:nil];
}
- (IBAction)yinpin:(id)sender {
    
    [self.navigationController pushViewController:[XBViewController new] animated:YES];
}

- (IBAction)shipin:(id)sender {
    [self.navigationController pushViewController:[XBVideoViewController new] animated:YES];
}

-(XBAudioPlayer *)audioPlayer
{
    if (_audioPlayer == nil)
    {
        _audioPlayer = [XBAudioPlayer new];
        
        //NSString *path0 = [[NSBundle mainBundle] pathForResource:@"周杰伦-晴天.mp3" ofType:nil];
        //NSString *path5 = @"http://qqma.tingge123.com:823/mp3/2016-06-01/1464765547.mp3";//晴天在线、
        //_audioPlayer.arr_urlStrs = @[path0];
        
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



-(XBVideoPlayer *)videoplayer
{
    if (_videoplayer == nil)
    {
        _videoplayer = [XBVideoPlayer new];
        [self.view addSubview:_videoplayer];
        _videoplayer.backgroundColor = [UIColor redColor];
        
        
        NSString *path0 = [[NSBundle mainBundle] pathForResource:@"周杰伦-晴天.mp3" ofType:nil];
        NSString *path5 = @"http://qqma.tingge123.com:823/mp3/2016-06-01/1464765547.mp3";//晴天在线、
        NSString *path6 = @"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4";
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"test01.mp4" ofType:nil];
        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"test02.mp4" ofType:nil];
        NSString *path3 = [[NSBundle mainBundle] pathForResource:@"IMG_0097.MP4" ofType:nil];
        
        _videoplayer.arr_urlStrs = @[path0,path6,path1,path2,path3,@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
        _videoplayer.b_autoPlayNext = YES;
        _videoplayer.bl_playProgress = ^(XBAVPlayer *player, CGFloat progress, CGFloat current, CGFloat total) {
            NSLog(@"当前进度：%f, 播放了：%f, 总共：%f",progress,current,total);
        };
        
        _videoplayer.bl_bufferBlock = ^(XBAVPlayer *player, CGFloat totalBuffer) {
            NSLog(@"已经缓冲了：%f",totalBuffer);
        };
        WEAK_SELF
        
        _videoplayer.bl_layout_vertical = ^(XBAVPlayer *player) {
            [player mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.view).offset(20);
                make.leading.trailing.equalTo(weakSelf.view);
                //make.height.mas_equalTo(100);
                make.height.equalTo(player.mas_width).multipliedBy(9.0/16);
            }];
        };
        _videoplayer.bl_layout_horizontal = ^(XBAVPlayer *player) {
            [player mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakSelf.view);
            }];
        };
        
        
        
        /*
         _player.bl_waitView = ^UIView *(XBAVPlayer *player) {
         UIView *av = [UIView new];
         av.backgroundColor = [UIColor greenColor];
         [player addSubview:av];
         [av mas_makeConstraints:^(MASConstraintMaker *make) {
         make.center.equalTo(player);
         make.size.mas_equalTo(CGSizeMake(64, 64));
         }];
         return av;
         };
         */
    }
    return _videoplayer;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /*
    if (self.audioPlayer.b_isPlaying)
    {
        [self.audioPlayer pause];
    }
    else
    {
        [self.audioPlayer continuePlay];
    }
     */
    
    //[self.videoplayer next];
    //[self.player seekToTime:200];
    //[self.player playIndex:2 errorBlock:^(XBAVPlayer *player, XBAVPlayerError xbError) {}];
}




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
- (IBAction)pause:(UIButton *)sender
{
    [[XBAudioRecorder shared] pause];
    NSLog(@"pause");
}
- (IBAction)resume:(UIButton *)sender
{
    [[XBAudioRecorder shared] resume];
    NSLog(@"resume");
}
- (IBAction)stop:(UIButton *)sender
{
    [[XBAudioRecorder shared] stop];
    NSLog(@"stop");
}




- (IBAction)playRecord:(UIButton *)sender
{
    
    NSLog(@"playRecord");
    //NSString *path0 = [[NSBundle mainBundle] pathForResource:@"周杰伦-晴天.mp3" ofType:nil];
    //self.audioPlayer.arr_urlStrs = @[path0];
    self.audioPlayer.arr_urlStrs = @[[[XBAudioRecorder shared] getSavePath]];
    [self.audioPlayer playWithErrorBlock:nil];

}




@end

