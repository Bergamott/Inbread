//
//  SoundPlayer.m
//  Inbread
//
//  Created by Karl on 2014-11-06.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import "SoundPlayer.h"

@implementation SoundPlayer

@synthesize soundOn;

+(SoundPlayer*)sharedPlayer
{
	static SoundPlayer *sharedPlayer;
	
	@synchronized(self)
	{
		if (!sharedPlayer)
			sharedPlayer = [[SoundPlayer alloc] init];
		return sharedPlayer;
	}
}

-(void)playTapWithNode:(SKNode*)skn
{
    if (soundOn)
    {
        [skn runAction:[SKAction playSoundFileNamed:@"click.wav" waitForCompletion:FALSE]];
    }
}

-(void)playSplatWithNode:(SKNode*)skn
{
    if (soundOn)
        [skn runAction:[SKAction playSoundFileNamed:@"splat.wav" waitForCompletion:FALSE]];
}

-(void)playChopWithNode:(SKNode*)skn
{
    if (soundOn)
        [skn runAction:[SKAction playSoundFileNamed:@"chop.wav" waitForCompletion:FALSE]];
}

-(void)playKnockWithNode:(SKNode*)skn
{
    if (soundOn)
        [skn runAction:[SKAction playSoundFileNamed:@"knock.wav" waitForCompletion:FALSE]];
}

-(void)playSlideWithNode:(SKNode*)skn
{
    if (soundOn)
    {
        [skn runAction:[SKAction playSoundFileNamed:@"slide.wav" waitForCompletion:FALSE]];
    }
}

-(void)playFailWithNode:(SKNode*)skn
{
    if (soundOn)
    {
        [skn runAction:[SKAction playSoundFileNamed:@"fail.wav" waitForCompletion:FALSE]];
    }
}

-(void)playBlipWithNode:(SKNode*)skn
{
    if (soundOn)
    {
        [skn runAction:[SKAction playSoundFileNamed:@"blip.wav" waitForCompletion:FALSE]];
    }
}

-(void)playBoingWithNode:(SKNode*)skn
{
    if (soundOn)
    {
        [skn runAction:[SKAction playSoundFileNamed:@"boing.wav" waitForCompletion:FALSE]];
    }
}

-(void)playPopupWithNode:(SKNode*)skn
{
    if (soundOn)
    {
        [skn runAction:[SKAction playSoundFileNamed:@"popup.wav" waitForCompletion:FALSE]];
    }
}

-(void)playLandWithDelay:(float)del withNode:(SKNode*)skn
{
    if (soundOn)
        [skn runAction:[SKAction sequence:@[[SKAction waitForDuration:del],[SKAction playSoundFileNamed:@"land.wav" waitForCompletion:FALSE]]]];
}

-(void)playErrorWithNode:(SKNode*)skn
{
    if (soundOn)
        [skn runAction:[SKAction playSoundFileNamed:@"error.wav" waitForCompletion:FALSE]];
}

-(void)playScoreWithNode:(SKNode*)skn
{
    if (soundOn)
        [skn runAction:[SKAction playSoundFileNamed:@"score.wav" waitForCompletion:FALSE]];
}

-(void)playLevelWithDelay:(float)del WithNode:(SKNode*)skn
{
    if (soundOn)
        [skn runAction:[SKAction sequence:@[[SKAction waitForDuration:del],[SKAction playSoundFileNamed:@"level.wav" waitForCompletion:FALSE]]]];
}

-(void)playBurpWithDelay:(float)del withNode:(SKNode*)skn
{
    if (soundOn)
    {
        [skn runAction:[SKAction sequence:@[[SKAction waitForDuration:del],[SKAction playSoundFileNamed:@"burp.wav" waitForCompletion:FALSE]]]];
    }
}

-(void)playHijackWithNode:(SKNode*)skn;
{
    if (soundOn)
        [skn runAction:[SKAction playSoundFileNamed:@"hijack.wav" waitForCompletion:FALSE]];
}

-(void)playSwatWithNode:(SKNode*)skn
{
    if (soundOn)
        [skn runAction:[SKAction playSoundFileNamed:@"swat.wav" waitForCompletion:FALSE]];
}

-(void)playBuzzWithNode:(SKNode*)skn
{
    if (soundOn)
        [skn runAction:[SKAction playSoundFileNamed:@"buzz.wav" waitForCompletion:FALSE]];
}


@end
