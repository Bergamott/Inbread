//
//  KitchenScene.h
//  Inbread
//
//  Created by Karl on 2014-10-17.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define MAX_SANDWICHES 20
#define MAX_PLANES 10

#define MAX_ORDERS 25
#define MAX_STACK 7

#define STATE_PLAYING 1
#define STATE_DONE 2

@class Food;
@class ViewController;
@class SoundPlayer;

@interface KitchenScene : SKScene {
    
    ViewController *owner;
    
    SKTextureAtlas *myAtlas;
    
    NSMutableArray *conveyorBelts;
    SKNode *backgroundNode;
    SKNode *conveyorNode;
    SKNode *foodNode;
    
    NSMutableArray *sprites;
    
    NSArray *ingredientNames;
    NSArray *sliceNames;
    NSArray *extraNames;
    NSArray *crumbNames;
    
    int level;
    int numPlates;
    int gameState;
    
    NSMutableDictionary *levDic;
    NSMutableString *ingredientsString;
    NSArray *sandwichOrders;
    int sandwichIngredients[MAX_ORDERS][MAX_STACK];
    int numIngredients[MAX_ORDERS];
    
    NSMutableArray *orderNotes;
    
    int planeY[MAX_PLANES];
    int planeDist;
    int numPlanes;
    int beltVelocities[MAX_PLANES];
    NSTimer *spawnFoodTimer;
    NSTimer *clockTimer;
    NSTimer *rundownTimer;
    
    int numOrders;
    int orderCount;
    BOOL ordersShown[MAX_SANDWICHES];
    BOOL ordersMet[MAX_SANDWICHES];
    int ordersComplete;
    
    NSDate *lastSentNote;
    
    float zCounter;
    
    SKSpriteNode *clockHand;
    NSDate *endTime;
    double totalTime;
    double rundownTime;
    SKLabelNode *scoreLabel;
    int score;
    int bottomScoreLimit,middleScoreLimit,topScoreLimit;
    
    SoundPlayer *soundPlayer;
    AVAudioPlayer *myAudioPlayer;
    NSArray *backgroundTunes;
}

-(void)setUpWithLevel:(int)l;
-(void)activateLevel;
-(void)replayLevel;
-(void)nextLevel;

-(void)spawnIngredient;

-(void)removeFood:(Food*)fObj;

-(void)gameLoop:(NSTimer*)t;

-(void)dropFood:(Food*)sliceFood;

-(void)checkPlates;

-(void)updateScore:(int)delta;

-(void)stopEverything;

-(void)levelFailed;
-(void)levelFinished;
-(void)clockRundown:(NSTimer*)t;
-(void)showLevelCompleteDialog;

@property(nonatomic,strong) ViewController *owner;
@property(nonatomic,strong) SKTextureAtlas *myAtlas;
@property(nonatomic,strong) NSMutableArray *conveyorBelts;
@property(nonatomic,strong) SKNode *backgroundNode;
@property(nonatomic,strong) SKNode *conveyorNode;
@property(nonatomic,strong) SKNode *foodNode;
@property(nonatomic,strong) NSMutableArray *sprites;
@property(nonatomic,strong) NSMutableArray *orderNotes;
@property(nonatomic,strong) NSDate *lastSentNote;
@property(nonatomic,strong) SKSpriteNode *clockHand;
@property(nonatomic,strong) NSDate *endTime;
@property(nonatomic,strong) SKLabelNode *scoreLabel;
@property(nonatomic,strong) AVAudioPlayer *myAudioPlayer;

@end
