//
//  AudioPlayerManager.h
//  05-本地音频播放
//
//  Created by vera on 16/5/5.
//  Copyright © 2016年 vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger,AudioPlayerType)
{
    /**
     *  单曲循环
     */
    AudioPlayerTypeLoops = -1,
    
    /**
     *  顺序播放
     */
    AudioPlayerTypeSequence = 0
};

/**
 *  播放完成的回调
 */
typedef void(^AudioPlayerManagerPlayerDidFinishCallBack)(void);

@interface AudioPlayerManager : NSObject

+ (instancetype)audioPlayerManager;

/**
 *  当前时间
 */
@property (nonatomic, assign) NSTimeInterval currentSecond;

/**
 *  总时间
 */
@property (nonatomic, assign, readonly) NSTimeInterval duration;

/**
 *  播放器类型
 */
@property (nonatomic, assign) AudioPlayerType playerType;

/**
 *  音量
 */
@property (nonatomic, assign) CGFloat volume;

#warning 下面两个方法需要优化
/**
 *  播放指定的音频
 *
 *  @param path <#path description#>
 */
- (void)playWithPath:(NSString *)path;

/**
 *  继续播放
 */
- (void)coutinuePlay;

/**
 *  暂停播放
 */
- (void)pause;

/**
 *  停止播放
 */
- (void)stop;

/**
 *  判断是否正在播放
 *
 *  @return <#return value description#>
 */
- (BOOL)isPalying;

/**
 *  设置播放完成的回调
 *
 *  @param callBack <#callBack description#>
 */
- (void)setAudioPlayerManagerPlayerDidFinishCallBack:(AudioPlayerManagerPlayerDidFinishCallBack)callBack;

/**
 *  返回当前格式化的时间，格式：mm:ss
 *
 *  @return <#return value description#>
 */
- (NSString *)stringCurrentSecondFormatter;

/**
 *  时间格式化，格式化成：mm:ss
 *
 *  @return <#return value description#>
 */
- (NSString *)stringFormatterFromDuration;


@end
