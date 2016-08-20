//
//  AudioPlayerManager.m
//  05-本地音频播放
//
//  Created by vera on 16/5/5.
//  Copyright © 2016年 vera. All rights reserved.
//

#import "AudioPlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayerManager ()<AVAudioPlayerDelegate>
{
//    NSTimeInterval _currentSecond;
    
    AudioPlayerManagerPlayerDidFinishCallBack _audioPlayerManagerPlayerDidFinishCallBack;
}

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation AudioPlayerManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        /*
         支持后台播放 - 音乐播放，录音
         */
        
        //音频会话
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        //后台播放模式
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        //激活
        [session setActive:YES error:nil];
    }
    return self;
}

+ (instancetype)audioPlayerManager
{
    static AudioPlayerManager *manager = nil;
    
    //只会调用一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}


/**
 *  播放指定的音频
 *
 *  @param path <#path description#>
 */
- (void)playWithPath:(NSString *)path
{
   //如果播放器正在播放
    if ([self isPalying])
    {
        //停止播放
        [self stop];
        //销毁播放器
        _player = nil;
    }
    
    
    //创建播放器
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    _player.numberOfLoops = self.playerType;
    _player.delegate = self;
    
    //减少缓冲时间
    [_player prepareToPlay];
    //播放
    [_player play];
}

/**
 *  暂停播放
 */
- (void)pause
{
    [self.player pause];
}

/**
 *  停止播放
 */
- (void)stop
{
    [self.player stop];
}

/**
 *  继续播放
 */
- (void)coutinuePlay
{
    [self.player play];
}

/**
 *  判断是否正在播放
 *
 *  @return <#return value description#>
 */
- (BOOL)isPalying
{
    return _player.isPlaying;
}


/**
 *  当前时间，单位是秒
 *
 *  @return <#return value description#>
 */
- (NSTimeInterval)currentSecond
{
    return self.player.currentTime;
}

#pragma mark - setter
/**
 *  设置当前时间
 *
 *  @param currentSecond <#currentSecond description#>
 */
- (void)setCurrentSecond:(NSTimeInterval)currentSecond
{
    self.player.currentTime = currentSecond;
}

/**
 *  设置播放器循环类型
 *
 *  @param playerType <#playerType description#>
 */
- (void)setPlayerType:(AudioPlayerType)playerType
{
    _playerType = playerType;
    
    //设置播放器循环类型
    self.player.numberOfLoops = playerType;
}

/**
 *  设置播放完成的回调
 *
 *  @param callBack <#callBack description#>
 */
- (void)setAudioPlayerManagerPlayerDidFinishCallBack:(AudioPlayerManagerPlayerDidFinishCallBack)callBack
{
    _audioPlayerManagerPlayerDidFinishCallBack = callBack;
}

- (void)setVolume:(CGFloat)volume
{
    _volume = volume;
    
    self.player.volume = volume;
}

#pragma mark - other

/**
 *  返回当前格式化的时间，格式：mm:ss
 *
 *  @return <#return value description#>
 */
- (NSString *)stringCurrentSecondFormatter
{
    //1.获取当前时间
    NSTimeInterval currentSecond = [self currentSecond];
    
    //2.格式化
    return [self secondFormatterWithSecond:currentSecond];
}

/**
 *  音频时间，单位是秒
 *
 *  @return <#return value description#>
 */
- (NSTimeInterval)duration
{
    return self.player.duration;
}

/**
 *  时间格式化，格式化成：mm:ss
 *
 *  @return <#return value description#>
 */
- (NSString *)stringFormatterFromDuration
{
    //获取总时间
    NSTimeInterval duration = [self duration];
    
    return [self secondFormatterWithSecond:duration];
}

#pragma mark - other
/**
 *  时间格式化，格式化成：mm:ss
 *
 *  @param second <#second description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)secondFormatterWithSecond:(NSTimeInterval)second
{
    int m = (int)second/60;
    int s = (int)second%60;
    
    return [NSString stringWithFormat:@"%02d:%02d",m,s];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag)
    {
        _audioPlayerManagerPlayerDidFinishCallBack();
    }
}

@end
