//
//  ViewController.m
//  AVAudioRecorderDemo
//
//  Created by Story5 on 2017/7/30.
//  Copyright © 2017年 Story5. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate>

@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) AVAudioRecorder *recorder;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [self configureRecordPath];
    NSDictionary *recordSetting = [self configureRecord];
    [self initRecorderWithURL:url settings:recordSetting];
    [self prepareRecord];
    
    [self configurePlayerWithURL:url];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startRecord:(UIButton *)sender {
    [self.recorder record];
}

- (IBAction)pauseRecord:(UIButton *)sender {
    [self.recorder record];
}

- (IBAction)stopRecord:(UIButton *)sender {
    [self.recorder stop];
}

- (IBAction)deleteRecording:(UIButton *)sender {
    [self.recorder deleteRecording];
}

- (IBAction)playRecord:(UIButton *)sender {
    [self.player play];
}

#pragma mark - AVAudioRecorder
// 步骤一:录音保存路径(沙盒路径)
- (NSURL *)configureRecordPath
{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/record.mp3",NSHomeDirectory()];
    NSURL *url = [NSURL fileURLWithPath:path];
    return url;
}

// 步骤二:录音设置
- (NSDictionary *)configureRecord
{
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    // 设置录音格式 AVFormatIDKey = kAudioFormatMPEGLayer3
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEGLayer3] forKey:AVFormatIDKey];
    // 设置录音采样率(Hz) AVSampleRateKey = 8000/44100/96000
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    // 录音通道数
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    // 线性采样位数 8/16/24/32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    // 录音质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    return recordSetting;
}

// 步骤三:实例化录音
- (void)initRecorderWithURL:(NSURL *)url settings:(NSDictionary *)settings
{
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
}

// 步骤四:准备录音
- (void)prepareRecord
{
    [self.recorder prepareToRecord];
}

#pragma mark - AVAudioPlayer
- (void)configurePlayerWithURL:(NSURL *)url
{
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.delegate = self;
    self.player.enableRate = YES;
    [self.player prepareToPlay];
}


@end
