//
//  HelpScene.h
//  Inbread
//
//  Created by Karl on 2015-01-27.
//  Copyright (c) 2015 Karl. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define TYPE_SINGLE_SLICE 0
#define TYPE_BREAD_CHEESE 1
#define TYPE_CONDIMENT 2

@class ViewController;
@class SoundPlayer;

@interface HelpScene : SKScene {
    
    ViewController *owner;
    
    SKTextureAtlas *myAtlas;
    SKNode *backgroundNode;
    
    SoundPlayer *soundPlayer;
    
    int helpType;
    int level;
}

-(int)findTypeForLevel:(int)l;
-(void)setUpWithType:(int)t;
-(SKSpriteNode*)setSprite:(NSString*)spr atX:(float)x andY:(float)y;
-(SKSpriteNode*)hideSprite:(NSString*)spr atX:(float)x andY:(float)y;
-(void)initialHelpAnimation;
-(void)breadCheeseAnimation;
-(void)condimentAnimation;
-(void)putSlice:(SKSpriteNode*)slice atX:(float)x andY:(float)y withLoaf:(SKSpriteNode*)loaf andDrop:(float)h;
-(void)putSlice:(SKSpriteNode*)slice atX:(float)x andY:(float)y withLoaf:(SKSpriteNode*)loaf andDrop:(float)h adjustX:(float)dx;
-(void)dropSlice:(SKSpriteNode*)slice height:(float)h;
-(void)dropGroup:(NSArray*)sprites height:(float)h;

-(void)makeStarsOnSprite:(SKSpriteNode*)sp;

-(void)endEverything;

@property(nonatomic,strong) ViewController *owner;
@property(nonatomic,strong) SKTextureAtlas *myAtlas;
@property(nonatomic,strong) SKNode *backgroundNode;

@end
