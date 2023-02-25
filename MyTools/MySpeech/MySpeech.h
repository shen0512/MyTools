//
//  MySpeech.h
//  MyTools
//
//  Created by Shen on 2023/2/19.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@protocol MySpeechDelegate <NSObject>
-(void)getResult:(NSString*)result;

@end

@interface MySpeech : NSObject
@property (nonatomic) id <MySpeechDelegate> delegate;

-(void)startListening;
-(void)stopListening;

@end

NS_ASSUME_NONNULL_END
