//
//  XBVideoViewController.m
//  XBMediaPlayer
//
//  Created by xxb on 2017/7/5.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBVideoViewController.h"
#import "XBVideoPlayer.h"
#import "Masonry.h"
#import "XBDataTaskManager.h"
#import "NSURL+XBLoader.h"

@interface XBVideoViewController ()
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) XBVideoPlayer *videoplayer;
@end

@implementation XBVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISlider *slider = [[UISlider alloc] init];
    [self.view addSubview:slider];
    slider.frame = CGRectMake(25, 400, 300, 30);
    [slider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventValueChanged];
    self.slider = slider;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.videoplayer playWithErrorBlock:^(XBAVPlayer *player, XBAVPlayerError xbError) {
        
    }];
}
- (void)changeProgress:(UISlider *)slider
{
    [self.videoplayer seekToTime:self.videoplayer.f_playingItemDuration * slider.value];
}
- (void)playVideo:(UIButton *)button
{
    [self.videoplayer playWithErrorBlock:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.videoplayer freePlayer];
}

-(void)dealloc
{
    NSLog(@"XBVideoViewController销毁");
}


-(XBVideoPlayer *)videoplayer
{
    if (_videoplayer == nil)
    {
        _videoplayer = [XBVideoPlayer new];
        [self.view addSubview:_videoplayer];
        _videoplayer.backgroundColor = [UIColor redColor];

        NSString *path = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
        _videoplayer.arr_urlStrs = @[path];
        WEAK_SELF
        _videoplayer.bl_playProgress = ^(XBAVPlayer *player, CGFloat progress, CGFloat current, CGFloat total) {
            NSLog(@"当前进度：%f, 播放了：%f, 总共：%f",progress,current,total);
            weakSelf.slider.value = progress;
        };
        
        _videoplayer.bl_bufferBlock = ^(XBAVPlayer *player, CGFloat totalBuffer) {
            NSLog(@"已经缓冲了：%f",totalBuffer);
        };
        
        //竖屏时的布局
        _videoplayer.bl_layout_vertical = ^(XBAVPlayer *player) {
            [player mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.view).offset(80);
                make.leading.trailing.equalTo(weakSelf.view);
                make.height.equalTo(player.mas_width).multipliedBy(9.0/16);
            }];
        };
        
        //横屏时的布局
        _videoplayer.bl_layout_horizontal = ^(XBAVPlayer *player) {
            [player mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakSelf.view);
            }];
        };
        
        
        
        //自定义loadingView
         _videoplayer.bl_waitView = ^UIView *(XBAVPlayer *player) {
         UIView *av = [UIView new];
         av.backgroundColor = [UIColor greenColor];
         [player addSubview:av];
         [av mas_makeConstraints:^(MASConstraintMaker *make) {
         make.center.equalTo(player);
         make.size.mas_equalTo(CGSizeMake(64, 64));
         }];
         return av;
         };
         
    }
    return _videoplayer;
}



@end
