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
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.videoplayer seekToTime:20];
    });
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.videoplayer next];
//    [self.videoplayer seekToTime:250];
//    if (self.videoplayer.b_isPlaying)
//    {
//        [self.videoplayer pause];
//    }
//    else
//    {
//        [self.videoplayer continuePlay];
//    }
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
        
        
        NSString *path0 = [[NSBundle mainBundle] pathForResource:@"周杰伦-晴天.mp3" ofType:nil];
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"test01.mp4" ofType:nil];
        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"test02.mp4" ofType:nil];
        NSString *path3 = [[NSBundle mainBundle] pathForResource:@"IMG_0097.MP4" ofType:nil];
        NSString *path4 = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
        NSString *path5 = @"http://qqma.tingge123.com:823/mp3/2016-06-01/1464765547.mp3";//晴天在线、
        NSString *path6 = @"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4";
        NSString *path7 = @"http://v4ttyey-10001453.video.myqcloud.com/Microblog/288-4-1452304375video1466172731.mp4";
        
//        _videoplayer.arr_urlStrs = @[path5,path6,path7,path4,path4];
        _videoplayer.arr_urlStrs = @[[self.task.requestURL originalSchemeURL].absoluteString];
        //_videoplayer.b_autoPlayNext = YES;
        WEAK_SELF
        _videoplayer.bl_playProgress = ^(XBAVPlayer *player, CGFloat progress, CGFloat current, CGFloat total) {
            NSLog(@"当前进度：%f, 播放了：%f, 总共：%f",progress,current,total);
            weakSelf.slider.value = progress;
        };
        
        _videoplayer.bl_bufferBlock = ^(XBAVPlayer *player, CGFloat totalBuffer) {
            NSLog(@"已经缓冲了：%f",totalBuffer);
        };
        
        
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
