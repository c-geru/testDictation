//
//  VoiceInputView.h
//  testDictation
//
//  Created by c-geru on 2014/11/11.
//  Copyright (c) 2014年 c-geru. All rights reserved.
//

#import <UIKit/UIKit.h>

// extern は定義を.hで行って、数値設定を.mで書くための作法
extern NSString * const DictationRecordingDidEndNotification;
extern NSString * const DictationRecognitionSucceededNotification;
extern NSString * const DictationRecognitionFailedNotification;
extern NSString * const DictationResultKey;

@interface VoiceInputView : UIView<UITextInput>

@end
