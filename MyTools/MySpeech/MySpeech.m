//
//  MySpeech.m
//  MyTools
//
//  Created by Shen on 2023/2/19.
//

#import "MySpeech.h"
#import <Speech/Speech.h>
@interface MySpeech()
@property (strong, nonatomic) SFSpeechRecognizer *speechRecognizer;
@property (strong, nonatomic) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (strong, nonatomic) SFSpeechRecognitionTask *recognitionTask;
@property (strong, nonatomic) AVAudioEngine *audioEngine;

@end
@implementation MySpeech
- (instancetype)init{
    self = [super init];
    
    if(self){
        self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"]];
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    NSLog(@"User denied access to speech recognition.");
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    NSLog(@"Speech recognition restricted on this device.");
                    break;
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    break;
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                default:
                    NSLog(@"Speech recognition not yet authorized");
                    break;
            }
        }];
        
        NSError *error;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
        [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        if(error){
            NSLog(@"error: %@", error);
        }
    }
    
    return self;
}

- (void)startListening{
    
    self.audioEngine = [[AVAudioEngine alloc] init];

    if (self.recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }

    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    self.recognitionRequest.shouldReportPartialResults = YES;
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (result) {
//            NSLog(@"RESULT:%@",result.bestTranscription.formattedString);
            if([self.delegate respondsToSelector:@selector(getResult:)]){
                [self.delegate getResult:result.bestTranscription.formattedString];
            }
        }
        if (error) {
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            self.recognitionRequest = nil;
            self.recognitionTask = nil;
        }
    }];

    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    NSError *error;
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
    if(error){
        NSLog(@"error: %@", error);
    }
}

- (void)stopListening{
    [self.audioEngine stop];
    self.recognitionRequest = nil;
    
    if (self.recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
}

@end
