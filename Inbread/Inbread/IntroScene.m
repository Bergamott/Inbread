//
//  IntroScene.m
//  Inbread
//
//  Created by Karl on 2014-10-05.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import "IntroScene.h"
#import "Hillbilly.h"

#define LEAN_ANGLE 0.1
#define CHEW_TIME 0.3
#define FRAME_TIME 0.15

@implementation IntroScene

@synthesize myAtlas;
@synthesize backgroundNode;

@synthesize myAudioPlayer;
@synthesize musicOn;

static float armsLowY[5] = {65,80,60,65,80};
static float armsHighY[5] = {95,105,90,92,97};
static int hillbillyZ[5] = {0,1,5,6,7};
static float hillbillyX[5] = {106,212,159,53,265};
static float hillbillyY[5] = {180,180,110,110,110};
static float leanTimes[5] = {1.0,1.1,1.2,1.3,1.4};
static float liftTimes[5] = {0.6,0.4,0.7,0.5,0.8};
static float mouthX[5] = {2,0,2,1,0};
static float mouthY[5] = {122,128,117,124,130};
static int numChews[5] = {3,4,5,4,3};


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        myAtlas = [SKTextureAtlas atlasNamed:@"intro"];
        
        backgroundNode = [SKNode node];
        if (size.height < 500)
            backgroundNode.position = CGPointMake(0, -22.0f);
        [self addChild:backgroundNode];
    }
    return self;
}

-(void)prepareIntro
{
    hillbillies = [NSMutableArray arrayWithCapacity:5];
    
    int s[5][2];
    for (int i=0;i<5;i++)
    {
        s[i][0] = arc4random() & 1023;
        s[i][1] = i;
    }
    for (int i=0;i<4;i++)
        for (int j=i+1;j<5;j++)
        {
            if (s[i][0] < s[j][0])
            {
                int k = s[i][0];
                s[i][0] = s[j][0];
                s[j][0] = k;
                k = s[i][1];
                s[i][1] = s[j][1];
                s[j][1] = k;
            }
        }
    
    chewArray = @[[myAtlas textureNamed:@"mouth0"],[myAtlas textureNamed:@"mouth1"],[myAtlas textureNamed:@"mouth2"],[myAtlas textureNamed:@"mouth3"],[myAtlas textureNamed:@"mouth4"],[myAtlas textureNamed:@"mouth5"],[myAtlas textureNamed:@"mouth6"],[myAtlas textureNamed:@"mouth7"]];
    
    for (int i=0;i<5;i++)
    {
        Hillbilly *hb = [[Hillbilly alloc] init];
        hb.tag = i;
        hb.holderNode = [SKNode node];
        hb.holderNode.zPosition = hillbillyZ[s[i][1]];
        hb.holderNode.position = CGPointMake(hillbillyX[s[i][1]], hillbillyY[s[i][1]]);
        hb.bodyNode = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:[NSString stringWithFormat:@"person%d",i]]];
        hb.bodyNode.anchorPoint = CGPointMake(0.5, 0);
        [hb.holderNode addChild:hb.bodyNode];
        
        hb.mouthNode = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"mouth3"]];
        hb.mouthNode.anchorPoint = CGPointMake(0.5, 0.5);
        hb.mouthNode.position = CGPointMake(mouthX[i], mouthY[i]);
        [hb.holderNode addChild:hb.mouthNode];
        
        hb.armsNode = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:[NSString stringWithFormat:@"hands%d",i]]];
        hb.armsNode.anchorPoint = CGPointMake(0.5, 0.5);
        hb.armsNode.position = CGPointMake(0, armsHighY[i]);
        
        [hb.holderNode addChild:hb.armsNode];
        
        [hillbillies addObject:hb];
        [hb.holderNode runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction rotateToAngle:LEAN_ANGLE duration:leanTimes[i]],[SKAction rotateToAngle:-LEAN_ANGLE duration:leanTimes[i]]]]]];
        [backgroundNode addChild:hb.holderNode];
        [self animateHillbilly:hb];
    }
    
    SKSpriteNode *backs = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"backs"]];
    backs.zPosition = 2;
    backs.anchorPoint = CGPointMake(0, 0);
    backs.position = CGPointMake(0, 105);
    [backgroundNode addChild:backs];
    
    // Start music
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"banjo1" ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath ];
    myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    myAudioPlayer.numberOfLoops = -1; //infinite loop
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    musicOn = [defaults boolForKey:@"musicOn"];
    if (musicOn)
        [myAudioPlayer play];
}


-(void)animateHillbilly:(Hillbilly*)hb
{
    int i = hb.tag;
    [hb.armsNode runAction:[SKAction sequence:@[[SKAction moveToY:armsHighY[i] duration:liftTimes[i]],[SKAction waitForDuration:CHEW_TIME],[SKAction moveToY:armsLowY[i] duration:liftTimes[i]]]]];
    NSMutableArray *chews = [NSMutableArray arrayWithCapacity:40];
    [chews addObject:[chewArray objectAtIndex:2]];
    [chews addObject:[chewArray objectAtIndex:1]];
    for (int j=0;j<(liftTimes[i]-2*FRAME_TIME)/FRAME_TIME;j++)
        [chews addObject:[chewArray objectAtIndex:0]];
    [chews addObject:[chewArray objectAtIndex:0]];
    
    SKEmitterNode *scatter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"scatter" ofType:@"sks"]];
    scatter.position = hb.mouthNode.position;
//    [hb performSelector:@selector(addParticleEffect:) withObject:scatter afterDelay:chews.count*FRAME_TIME];
    [hb performSelector:@selector(addCrumbs) withObject:NULL afterDelay:chews.count*FRAME_TIME];
    
    [chews addObject:[chewArray objectAtIndex:3]];
    for (int j=0;j<numChews[i];j++)
    {
        [chews addObject:[chewArray objectAtIndex:5]];
        [chews addObject:[chewArray objectAtIndex:6]];
        [chews addObject:[chewArray objectAtIndex:5]];
        [chews addObject:[chewArray objectAtIndex:7]];
    }
    [chews addObject:[chewArray objectAtIndex:4]];

    [hb.mouthNode runAction:[SKAction animateWithTextures:chews timePerFrame:FRAME_TIME]];
    
    [self performSelector:@selector(animateHillbilly:) withObject:hb afterDelay:(chews.count+1)*FRAME_TIME];
}

-(void)setMusicOn:(BOOL)mo
{
    musicOn = mo;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:mo forKey:@"soundOn"];
    [defaults synchronize];

    if (mo)
        [myAudioPlayer play];
    else
        [myAudioPlayer stop];
}

-(void)stopEverything
{
    [myAudioPlayer stop];
    [backgroundNode removeAllActions];
    for (SKNode *tmpN in backgroundNode.children)
        [tmpN removeAllActions];
    [hillbillies removeAllObjects];
    [backgroundNode removeAllChildren];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
