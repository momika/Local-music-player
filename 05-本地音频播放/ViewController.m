//
//  ViewController.m
//  05-本地音频播放
//
//  Created by vera on 16/5/5.
//  Copyright © 2016年 vera. All rights reserved.
//

#import "ViewController.h"
#import "AudioPlayerManager.h"
#import "Lrc.h"

@interface ViewController ()
{
    //定时器
    NSTimer *_timer;
    
    //音频管理类
    AudioPlayerManager *_manager;
    
    //当前音频的索引
    NSInteger _currentAudioIndex;
    
    //歌词索引
    NSInteger _currentLrcIndex;
}

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UITableView *lrcTableView;

/**
 *  歌词对象
 */
@property (nonatomic, strong) Lrc *lrc;

/**
 *  音频列表
 */
@property (strong, nonatomic) NSArray *audioArray;

- (IBAction)playButtonClick:(UIButton *)sender;
- (IBAction)currentTimeSliderHandle:(UISlider *)sender;
- (IBAction)previousButtonClick:(UIButton *)sender;
- (IBAction)nextButtonClick:(UIButton *)sender;
- (IBAction)audioPlayType:(UIButton *)sender;



@end

@implementation ViewController

/**
 *  <#Description#>
 */
- (void)initUI
{
    [self.currentTimeSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    self.playButton.selected = YES;
}

/**
 *  <#Description#>
 */
- (void)initAudioPlayer
{
    //播放
    [_manager playWithPath:[self audioFilePath]];
    
    
    //获取总时间
    self.durationTimeLabel.text = [_manager stringFormatterFromDuration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.audioArray = @[@"梁静茹-偶阵雨.mp3",@"林俊杰-背对背拥抱.mp3",@"情非得已.mp3"];
    
//    __block和__weak在arc和传统的mrc的区别
    
    __weak ViewController *weakSelf = self;
    
    _manager = [AudioPlayerManager audioPlayerManager];
    /**
     *  当前音频播放完成回调
     */
    [_manager setAudioPlayerManagerPlayerDidFinishCallBack:^{
        
        //如果是顺序播放,播放下一首
        if(_manager.playerType == AudioPlayerTypeSequence)
        {
            /*
             retain cycle：循环引用
             */
            
            //播放下一首
            [weakSelf next];
        }
    }];
    
    
    //1.初始化UI
    [self initUI];
    
    //2.初始化播放器
    [self initAudioPlayer];
    

    //3.初始化定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
  
    
    //已经过去了很久
    NSLog(@"%@",[NSDate distantPast]);
    //遥远的将来
    NSLog(@"%@",[NSDate distantFuture]);
    
    
    [self.lrcTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    Lrc *lrc = [[Lrc alloc] init];
    [lrc parseLrcWithFileName:@"梁静茹-偶阵雨.lrc"];
    
    self.lrc = lrc;
    
                                    
}

/**
 *  更新当前时间
 */
- (void)update
{
    //1.修改当前时间
    self.currentTimeLabel.text = [_manager stringCurrentSecondFormatter];
    //2.修改slider
    self.currentTimeSlider.value = _manager.currentSecond/_manager.duration;
    
    //3.获取当前歌词index
    _currentLrcIndex =  [self.lrc currentLrcIndex:_manager.currentSecond];
    
    //4.刷新tableView
    [self.lrcTableView reloadData];
    
    //5.滚动到指定行
    [self.lrcTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentLrcIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

/**
 *  下一首
 */
- (void)next
{
    _currentAudioIndex++;
    
    //1.如果已经是第一首了，播放最后一首
    if (_currentAudioIndex > self.audioArray.count - 1)
    {
        _currentAudioIndex = 0;
    }
    
    //2.重新初始化播放器
    [self initAudioPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  播放,暂停
 *
 *  @param sender <#sender description#>
 */
- (IBAction)playButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        //继续播放
        [_manager coutinuePlay];
        
        //启动定时器
        [_timer setFireDate:[NSDate distantPast]];
    }
    else
    {
        //暂停
        [_manager pause];
        
        //暂停定时器
        [_timer setFireDate:[NSDate distantFuture]];
    }
    
}

/**
 *  快进，快退
 *
 *  @param sender <#sender description#>
 */
- (IBAction)currentTimeSliderHandle:(UISlider *)sender
{
    //修改当前时间
    _manager.currentSecond = sender.value * _manager.duration;
}

/**
 *  上一首
 *
 *  @param sender <#sender description#>
 */
- (IBAction)previousButtonClick:(UIButton *)sender
{
    _currentAudioIndex--;
    
    //1.如果已经是第一首了，播放最后一首
    if (_currentAudioIndex < 0)
    {
        _currentAudioIndex = self.audioArray.count - 1;
    }
    
    //2.重新初始化播放器
    [self initAudioPlayer];
}

/**
 *  下一首
 *
 *  @param sender <#sender description#>
 */
- (IBAction)nextButtonClick:(UIButton *)sender
{
    [self next];
}

/**
 *  现实播放器顺序播放、单曲循环
 *
 *  @param sender <#sender description#>
 */
- (IBAction)audioPlayType:(UIButton *)sender
{
//    arc4random_uniform(self.audioArray.count);
    
    sender.selected = !sender.selected;
    
    AudioPlayerType playerType = AudioPlayerTypeSequence;
    
    //单曲循环
    if (sender.selected)
    {
         playerType = AudioPlayerTypeLoops;
    }
    
    _manager.playerType = playerType;
}


/**
 *  返回指定的路径
 *
 *  @param filename <#filename description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)audioFilePath
{
    return [[NSBundle mainBundle] pathForResource:self.audioArray[_currentAudioIndex] ofType:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrc.wordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.lrc.wordArray[indexPath.row];
    
    UIColor *color;
    
    //选中,修改文字颜色
    if (_currentLrcIndex == indexPath.row)
    {
        color = [UIColor redColor];
    }
    else
    {
        color = [UIColor blackColor];
    }
    
    cell.textLabel.textColor = color;
    
    return cell;
}

@end
