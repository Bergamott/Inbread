//
//  SoundPlayer.h
//  Inbread
//
//  Created by Karl on 2014-11-06.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SoundPlayer : NSObject {
    
    BOOL soundOn;
}

+(SoundPlayer*)sharedPlayer;

-(void)playTapWithNode:(SKNode*)skn;
-(void)playErrorWithNode:(SKNode*)skn;
-(void)playSplatWithNode:(SKNode*)skn;
-(void)playChopWithNode:(SKNode*)skn;
-(void)playKnockWithNode:(SKNode*)skn;
-(void)playSlideWithNode:(SKNode*)skn;
-(void)playFailWithNode:(SKNode*)skn;
-(void)playBlipWithNode:(SKNode*)skn;
-(void)playBoingWithNode:(SKNode*)skn;
-(void)playPopupWithNode:(SKNode*)skn;
-(void)playLevelWithDelay:(float)del WithNode:(SKNode*)skn;
-(void)playLandWithDelay:(float)del withNode:(SKNode*)skn;
-(void)playScoreWithNode:(SKNode*)skn;
-(void)playBurpWithDelay:(float)del withNode:(SKNode*)skn;
-(void)playHijackWithNode:(SKNode*)skn;
-(void)playSwatWithNode:(SKNode*)skn;
-(void)playBuzzWithNode:(SKNode*)skn;
-(void)playPaperWithNode:(SKNode*)skn;
-(void)playFanfareWithNode:(SKNode*)skn;
-(void)playKetchupWithNode:(SKNode*)skn;

@property(nonatomic) BOOL soundOn;

@end
