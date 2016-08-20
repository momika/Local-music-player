//
//  Lrc.h
//  05-本地音频播放
//
//  Created by vera on 16/5/6.
//  Copyright © 2016年 vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lrc : NSObject

/**
 *  时间
 */
@property (nonatomic, strong) NSMutableArray *timeArray;

/**
 *  歌词
 */
@property (nonatomic, strong) NSMutableArray *wordArray;

/**
 *  开始解析指定的歌词文件
 *
 *  @param filename <#filename description#>
 */
- (void)parseLrcWithFileName:(NSString *)filename;

/**
 *  查找当前时间的歌词在哪一行
 *
 *  @param currentSeconds <#currentSeconds description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)currentLrcIndex:(NSTimeInterval)currentSeconds;

@end
