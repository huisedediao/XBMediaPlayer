//
//  XBViewController.m
//  XBMediaPlayer
//
//  Created by xxb on 2017/7/5.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBViewController.h"
#import "XBAudioPlayer.h"

@interface XBViewController ()

@property (nonatomic,strong) XBAudioPlayer *audioPlayer;
@end

@implementation XBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"address:%@",self);
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)playVideo:(UIButton *)button
{
    [self.audioPlayer playWithErrorBlock:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"XBViewController销毁");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.audioPlayer freePlayer];
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.audioPlayer next];
}

-(XBAudioPlayer *)audioPlayer
{
    if (_audioPlayer == nil)
    {
        _audioPlayer = [XBAudioPlayer new];
        
        //NSString *path0 = [[NSBundle mainBundle] pathForResource:@"周杰伦-晴天.mp3" ofType:nil];
        //NSString *path5 = @"http://qqma.tingge123.com:823/mp3/2016-06-01/1464765547.mp3";//晴天在线、
        //_audioPlayer.arr_urlStrs = @[path0];
        NSString *path0 = [[NSBundle mainBundle] pathForResource:@"周杰伦-晴天.mp3" ofType:nil];
        _audioPlayer.arr_urlStrs = @[path0,path0];
        
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

@end
