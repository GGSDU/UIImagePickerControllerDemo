//
//  ViewController.m
//  AVAudioRecorderDemo
//
//  Created by pk on 15/3/20.
//  Copyright (c) 2015年 pk. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "UIButton+LZCategory.h"
@interface ViewController ()
{
    AVAudioRecorder *_recorder;
    AVAudioPlayer *_player;
}

@property (nonatomic,strong) UIView *controlView;
@property (nonatomic,strong) UIButton *recordButton;
@property (nonatomic,strong) UIButton *playButton;
@property (nonatomic,strong) UIButton *completeButton;
@property (nonatomic,strong) UIButton *reRecordButton;

@property (nonatomic,strong) NSMutableArray *animationImages;
@property (nonatomic,strong) UIImageView *recordAnimation;

@property (nonatomic,assign,readonly) CGSize size;
@property (nonatomic,assign,readonly) float space;

@property (nonatomic,strong) NSURL *url;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self showRecordButton];
    
    
    //保存路径
    NSString* path = [NSString stringWithFormat:@"%@/Documents/a.aac", NSHomeDirectory()];
    self.url = [NSURL fileURLWithPath:path];
    
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.url settings:recordSetting error:nil];
   //_recorder.meteringEnabled
    //准备录音
    [_recorder prepareToRecord];
}

//开始录音
- (void)startRecord{
    [_recorder record];
    
    self.recordAnimation.hidden = NO;
    [self.recordAnimation startAnimating];
}
//停止录音
- (void)stopRecord{
    [_recorder stop];
    [self.recordAnimation stopAnimating];
    self.recordAnimation.hidden = YES;
    [self showControlView];
}

- (void)completeRecord {
    
}

- (void)playRecord:(UIButton *)aSender {
    aSender.selected = !aSender.selected;
    if (aSender.selected) {
        //播放声音
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.url error:nil];
        [_player prepareToPlay];
        [_player play];
    } else {
        [_player pause];
    }
}

- (void)reRecord {
    [self showRecordButton];
}

#pragma mark - UI
- (void)showRecordButton
{
    self.recordButton.hidden = NO;
    self.controlView.hidden = YES;
}

- (void)showControlView
{
    self.recordButton.hidden = YES;
    self.controlView.hidden = NO;
    self.completeButton.hidden = NO;
    self.playButton.hidden = NO;
    self.playButton.selected = NO;
    self.reRecordButton.hidden = NO;
}

- (NSMutableArray *)animationImages
{
    if (_animationImages == nil) {
        _animationImages = [[NSMutableArray alloc] initWithCapacity:8];
        for (int i = 0; i < 16; i++) {
            [_animationImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"mic_%d.png",i]]];
        }
    }
    return _animationImages;
}

- (UIImageView *)recordAnimation
{
    if (_recordAnimation == nil) {
        _recordAnimation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
        _recordAnimation.center = self.view.center;
        _recordAnimation.animationImages = self.animationImages;
        [self.view addSubview:_recordAnimation];
    }
    return _recordAnimation;
}

- (UIButton *)recordButton
{
    if (_recordButton == nil) {
        float width = self.size.width;
        float originX = (CGRectGetWidth(self.view.bounds) - width) / 2;
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordButton.frame = CGRectMake(originX, CGRectGetMinY(self.controlView.frame), width, self.size.height);
        
        [_recordButton setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
        [_recordButton setTitle:@"按住录音" forState:UIControlStateNormal];
        [_recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_recordButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_recordButton];
        
        [_recordButton setbuttonType:LZCategoryTypeBottom];
        
    }
    return _recordButton;
}


- (UIView *)controlView
{
    if (_controlView == nil) {
        float offsetY = 50;
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - self.size.height - offsetY, self.view.bounds.size.width, self.size.height)];
        [self.view addSubview:self.controlView];
    }
    return _controlView;
}

- (UIButton *)playButton
{
    if (_playButton == nil) {
        float originX = (CGRectGetWidth(self.controlView.bounds) - self.size.width) / 2;
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(originX, 0, self.size.width, self.size.height);
        [_playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateSelected];
        [_playButton setTitle:@"播放录音" forState:UIControlStateNormal];
        [_playButton setTitle:@"暂停播放" forState:UIControlStateSelected];
        [_playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self.controlView addSubview:_playButton];
        
        [_playButton setbuttonType:LZCategoryTypeBottom];
    }
    return _playButton;
}

- (UIButton *)completeButton
{
    if (_completeButton == nil) {
        float originX = CGRectGetMinX(self.playButton.frame) - self.size.width - self.space;
        _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _completeButton.frame = CGRectMake(originX, 0, self.size.height, self.size.height);
        [_completeButton setImage:[UIImage imageNamed:@"complete.png"] forState:UIControlStateNormal];
        [_completeButton setTitle:@"完成录音" forState:UIControlStateNormal];
        [_completeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_completeButton addTarget:self action:@selector(completeRecord) forControlEvents:UIControlEventTouchUpInside];
        [self.controlView addSubview:_completeButton];
        
        [_completeButton setbuttonType:LZCategoryTypeBottom];

    }
    return _completeButton;
}

- (UIButton *)reRecordButton
{
    if (_reRecordButton == nil) {
        float originX = CGRectGetMaxX(self.playButton.frame) + self.space;
        _reRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reRecordButton.frame = CGRectMake(originX, 0, self.size.width, self.size.height);
        [_reRecordButton setImage:[UIImage imageNamed:@"reRecord.png"] forState:UIControlStateNormal];
        [_reRecordButton setTitle:@"重新录制" forState:UIControlStateNormal];
        [_reRecordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_reRecordButton addTarget:self action:@selector(reRecord) forControlEvents:UIControlEventTouchUpInside];
        [self.controlView addSubview:_reRecordButton];
        
        [_reRecordButton setbuttonType:LZCategoryTypeBottom];

    }
    return _completeButton;
}

- (CGSize)size
{
    return CGSizeMake(80, 90);
}

- (float)space
{
    return 50;
}

@end
