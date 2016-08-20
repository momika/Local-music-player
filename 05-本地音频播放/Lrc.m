//
//  Lrc.m
//  05-本地音频播放
//
//  Created by vera on 16/5/6.
//  Copyright © 2016年 vera. All rights reserved.
//

#import "Lrc.h"

@implementation Lrc

- (NSMutableArray *)timeArray
{
    if (!_timeArray)
    {
        _timeArray = [NSMutableArray array];
    }
    
    return _timeArray;
}

- (NSMutableArray *)wordArray
{
    if (!_wordArray)
    {
        _wordArray = [NSMutableArray array];
    }
    
    return _wordArray;
}

- (NSString *)contentWithFileName:(NSString *)filename
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return content;
}

/**
 *  开始解析指定的歌词文件
 *
 *  @param filename <#filename description#>
 */
- (void)parseLrcWithFileName:(NSString *)filename
{
    //1.读取文件内容
    NSString *content = [self contentWithFileName:filename];
    
    //2.解析歌词
    NSArray *lrcArray = [content componentsSeparatedByString:@"["];
    
    for (int i = 5; i < lrcArray.count; i++)
    {
        NSArray *arr = [lrcArray[i] componentsSeparatedByString:@"]"];
        
        //健壮
        if (arr.count == 2)
        {
            //添加时间和歌词
            [self.timeArray addObject:arr[0]];
            [self.wordArray addObject:arr[1]];
        }
    
    }
    
}

/**
 *  查找当前时间的歌词在哪一行
 *
 *  @param currentSeconds <#currentSeconds description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)currentLrcIndex:(NSTimeInterval)currentSeconds
{
    __block NSInteger index = 0;
    
    //遍历
    [self.timeArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray *arr = [obj componentsSeparatedByString:@":"];
        //要比较的时间
        NSTimeInterval compareSeconds = [arr[0] integerValue] * 60 + [arr[1] floatValue];
        
        //两个时间进行比较
        if (compareSeconds < currentSeconds)
        {
            index = idx;
        }
        else
        {
            //停止遍历
            *stop = YES;
        }
        
    }];
    
    return index;
}

@end
