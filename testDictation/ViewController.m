//
//  ViewController.m
//  testDictation
//
//  Created by c-geru on 2014/11/11.
//  Copyright (c) 2014年 c-geru. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
{
    BOOL flg_voiceCheck;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Voiceチェック判定用
    flg_voiceCheck = false;
    
    // 音声入力に関するNotificationの設定
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dictationRecordingDidEnd:)
                                                 name:DictationRecordingDidEndNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dictationRecognitionSucceeded:)
                                                 name:DictationRecognitionSucceededNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dictationRecognitionFailed:)
                                                 name:DictationRecognitionFailedNotification object:nil];

}

-(void)viewDidAppear:(BOOL)animated
{
    if (![_voiceInputView isFirstResponder]) {
        [_voiceInputView becomeFirstResponder];
    }
    
    //---ここのsharedInstanceが、「Undeclared selector 'sharedInstance'」になってしまう。
    //---参考にしたソースは、targetがiOS5.1でエラーは出なかったので仕様が変わったのかも？
    //---動くのでとりあえず放置。
    _dictationController =
    [NSClassFromString(@"UIDictationController") performSelector:@selector(sharedInstance)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    // Notificationの解除
    [_notificationCenter removeObserver:self];
    
    [super viewDidUnload];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    if (![_voiceInputView isFirstResponder]) {
        [_voiceInputView becomeFirstResponder];
    }
    
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self cancelDictation];
    [_voiceInputView resignFirstResponder];
}

#pragma mark 音声入力
- (void)startDictation {
    [_dictationController performSelector:@selector(startDictation)];
    _myText.text = @"start dictation";
    
    _btnStart.alpha = 0.5f;
    flg_voiceCheck = true;
    
    //stopDictationしないと、音声解析が開始したいためタイマーを設定している
    _timer = [NSTimer scheduledTimerWithTimeInterval:4.75
                                              target:self
                                            selector:@selector(timerDidEnd)
                                            userInfo:nil
                                             repeats:NO];
}

- (void)timerDidEnd {
    NSLog(@"call stopDictation, timerDidEnd");
    [self stopDictation];
}

- (void)stopDictation {
    NSLog(@"In stopDictation");
    
    _btnStart.alpha = 1.0f;
    flg_voiceCheck = false;
    
    [_dictationController performSelector:@selector(stopDictation)];
}

- (void)cancelDictation {
    [_dictationController performSelector:@selector(cancelDictation)];
    _myText.text = @"";
}

- (void)dictationRecordingDidEnd:(NSNotification *)notification {
    NSLog(@"dictationRecordingDidEnd --- 認識終了：main");
    _myText.text = @"";
}

- (void)dictationRecognitionSucceeded:(NSNotification *)notification {
    NSLog(@"dictationRecognitionSucceeded --- 認識成功：main");
    NSDictionary *userInfo = notification.userInfo;
    NSArray *dictationResult = [userInfo objectForKey:DictationResultKey];
    NSString *text = [self wholeTestWithDictationResult:dictationResult];
    NSLog(@"----text >> %@", text);
    _myText.text = text;
    
}

- (void)dictationRecognitionFailed:(NSNotification *)notification {
    NSLog(@"dictationRecognitionFailed --- 認識失敗：main");
    _myText.text = @"Failed";
}

- (NSString *)wholeTestWithDictationResult:(NSArray *)dictationResult {
    NSMutableString *text = [NSMutableString string];
    for (UIDictationPhrase *phrase in dictationResult) {
        [text appendString:phrase.text];
    }
    
    return text;
}


- (IBAction)startVoice:(id)sender {
    if (flg_voiceCheck) {
        return;
    }
    
    [self startDictation];
}

- (IBAction)endVoice:(id)sender {
    [self stopDictation];
}




@end
