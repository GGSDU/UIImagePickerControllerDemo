//
//  ViewController.m
//  AVAudioPlayerDemo
//
//  Created by pk on 15/3/20.
//  Copyright (c) 2015年 pk. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate>{
    //进度
    IBOutlet UISlider* _proSlider;
    //音量
    IBOutlet UISlider* _volSlider;
    //声道
    IBOutlet UISlider* _panSlider;
    //速度
    IBOutlet UISlider* _rateSlider;
    //progressView
    IBOutlet UIProgressView* _pv1;
    IBOutlet UIProgressView* _pv2;
    //播放器
    AVAudioPlayer* _player;
    //定时器
    NSTimer* _timer;
}

//进度
- (IBAction)changeProgress:(id)sender;
//音量
- (IBAction)changeVolume:(id)sender;
//声道
- (IBAction)changePan:(id)sender;
//速度
- (IBAction)changeRate:(id)sender;
//播放
- (IBAction)play:(id)sender;
//暂停
- (IBAction)pause:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //得到路径
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Beat It" ofType:@"mp3"];
    NSURL* url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.delegate = self;
    //开启变速功能
    _player.enableRate = YES;
    //开启峰值，平均值功能
    _player.meteringEnabled = YES;
    //准备播放
    [_player prepareToPlay];
}

//进度
- (IBAction)changeProgress:(id)sender{
    //当前时间=总时间*进度
    float currentTime = _player.duration * _proSlider.value;
    _player.currentTime = currentTime;
}
//音量
- (IBAction)changeVolume:(id)sender{
    _player.volume = _volSlider.value;
}
//声道
- (IBAction)changePan:(id)sender{
    _player.pan = _panSlider.value;
}
//速度
- (IBAction)changeRate:(id)sender{
    _player.rate = _rateSlider.value;
}

//刷新
- (void)refresh{
    //进度=当前时间/总时间
    float pro = _player.currentTime / _player.duration;
    [_proSlider setValue:pro animated:YES];
    
    //刷新值
    [_player updateMeters];
    /*
     秒        1      2       3
     平均值     5      6       7
     峰值      8       9       10
     取值：1s  5，8    6，9
     */
    //获取平均值 0 声道
    float avg = [_player averagePowerForChannel:0];
    //获取峰值
    float peak = [_player peakPowerForChannel:0];
    //NSLog(@"%f, %f", avg, peak);
    [_pv1 setProgress:(avg + 30) / 30 animated:YES];
    [_pv2 setProgress:(peak + 30) / 30 animated:YES];
}

//播放
- (IBAction)play:(id)sender{
    if (_timer == nil) {
        //开启定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    }
    [_player play];
}
//暂停
- (IBAction)pause:(id)sender{
    if (_timer) {
        //销毁定时器
        [_timer invalidate];
        _timer = nil;
    }
    [_player pause];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //_player = 
}


@end
