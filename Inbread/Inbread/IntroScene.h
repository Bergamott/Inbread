//
//  IntroScene.h
//  Inbread
//
//  Created by Karl on 2014-10-05.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class Hillbilly;

@interface IntroScene : SKScene {
    
    SKTextureAtlas *myAtlas;
    SKNode *backgroundNode;

    NSMutableArray *hillbillies;
    NSArray *chewArray;
    
    // Temporary
    AVAudioPlayer *myAudioPlayer;
    BOOL musicOn;
}

-(void)prepareIntro;

-(void)animateHillbilly:(Hillbilly*)hb;

-(void)setMusicOn:(BOOL)mo;

-(void)stopEverything;

@property(nonatomic,strong) SKTextureAtlas *myAtlas;
@property(nonatomic,strong) SKNode *backgroundNode;
@property(nonatomic,strong) AVAudioPlayer *myAudioPlayer;
@property(nonatomic) BOOL musicOn;
@property(nonatomic) BOOL soundOn;

@end
