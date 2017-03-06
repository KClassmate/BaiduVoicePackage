//
//  ViewController.m
//  BDVoicePackage
//
//  Created by KSY-iOS on 17/3/6.
//  Copyright © 2017年 dingxiankun. All rights reserved.
//

#import "ViewController.h"
#import "BDSSpeechSynthesizer.h"

@interface ViewController ()<BDSSpeechSynthesizerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSDK];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self speakSentence];
}


- (void)speakSentence
{
    [[BDSSpeechSynthesizer sharedInstance] speakSentence: @"百度一下" withError:nil];
}

-(void)configureSDK{
    NSLog(@"TTS version info: %@", [BDSSpeechSynthesizer version]);
    [BDSSpeechSynthesizer setLogLevel:BDS_PUBLIC_LOG_VERBOSE];
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerDelegate:self];
    [self configureOnlineTTS];
    [self configureOfflineTTS];
}
// 配置在线
-(void)configureOnlineTTS{
    //#error "Set api key and secret key"
    [[BDSSpeechSynthesizer sharedInstance] setApiKey:@"e7QA3FWob8EbzLDP7I6fCtcY" withSecretKey:@"17d90e1974d0bcb31725245f96718e73"];
}
// 配置离线
-(void)configureOfflineTTS{
    NSString* offlineEngineSpeechData = [[NSBundle mainBundle] pathForResource:@"Chinese_Speech_Female" ofType:@"dat"];
    NSString* offlineEngineTextData = [[NSBundle mainBundle] pathForResource:@"Chinese_Text" ofType:@"dat"];
    NSString* offlineEngineEnglishSpeechData = [[NSBundle mainBundle] pathForResource:@"English_Speech_Female" ofType:@"dat"];
    NSString* offlineEngineEnglishTextData = [[NSBundle mainBundle] pathForResource:@"English_Text" ofType:@"dat"];
    NSString* offlineEngineLicenseFile = [[NSBundle mainBundle] pathForResource:@"offline_engine_tmp_license" ofType:@"dat"];
    //#error "set offline engine license"
    NSError* err = [[BDSSpeechSynthesizer sharedInstance] loadOfflineEngine:offlineEngineTextData speechDataPath:offlineEngineSpeechData licenseFilePath:offlineEngineLicenseFile withAppCode:@"9353239"]; //
    if (err) {
        return;
    }
    err = [[BDSSpeechSynthesizer sharedInstance] loadEnglishDataForOfflineEngine:offlineEngineEnglishTextData speechData:offlineEngineEnglishSpeechData];
    if (err) {
        return;
    }
    
    // 合成参数设置
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:BDS_SYNTHESIZER_SPEAKER_FEMALE]
                                                        forKey:BDS_SYNTHESIZER_PARAM_SPEAKER ];
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:5]
                                                        forKey:BDS_SYNTHESIZER_PARAM_VOLUME];
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:5]
                                                        forKey:BDS_SYNTHESIZER_PARAM_SPEED];
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt:5]
                                                        forKey:BDS_SYNTHESIZER_PARAM_PITCH];
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerParam:[NSNumber numberWithInt: BDS_SYNTHESIZER_AUDIO_ENCODE_MP3_16K]
                                                        forKey:BDS_SYNTHESIZER_PARAM_AUDIO_ENCODING ];
    
}
// 播放失败
- (void)synthesizerErrorOccurred:(NSError *)error
                        speaking:(NSInteger)SpeakSentence
                    synthesizing:(NSInteger)SynthesizeSentence{
    
    [[BDSSpeechSynthesizer sharedInstance] cancel];
}




@end
