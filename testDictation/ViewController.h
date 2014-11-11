//
//  ViewController.h
//  testDictation
//
//  Created by c-geru on 2014/11/11.
//  Copyright (c) 2014年 c-geru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceInputView.h"


@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UITextField *myText;
- (IBAction)startVoice:(id)sender;
- (IBAction)endVoice:(id)sender;

// 音声入力
@property id dictationController;
@property (strong, nonatomic) IBOutlet VoiceInputView *voiceInputView;

@property NSNotificationCenter *notificationCenter;

@property NSTimer *timer;

@end
