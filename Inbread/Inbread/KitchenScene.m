//
//  KitchenScene.m
//  Inbread
//
//  Created by Karl on 2014-10-17.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import "KitchenScene.h"
#import "DataHandler.h"
#import "Food.h"
#import "SKEase.h"
#import "ViewController.h"
#import "SoundPlayer.h"
#import "Condiment.h"

#define FOOD_START_X -40.0
#define FOOD_END_X 360.0
#define FOOD_DISTANCE 90.0
#define CRUMB_OFFSET 20.0
#define HIT_DISTANCE 30.0

#define TOP_PLANE_Y 168
#define BOTTOM_PLANE_Y 10
#define BELT_THICKNESS 9
#define FALL_SPEED 150.0

#define NOTE_Y 38.0
#define NOTE_SCALE 0.8

#define MAX_VISIBLE_NOTES 3
#define NOTE_STOP_X 280.0
#define NOTE_DISTANCE 70.0
#define NOTE_START_X -40.0

#define BLACK_POINTS 15
#define WHITE_POINTS 5

#define CONDIMENT_Y_MARGIN 40.0
#define CONDIMENT_HIT_DISTANCE 25.0
#define CONDIMENT_SPEED_RATIO 1.6f

@implementation KitchenScene

@synthesize owner;
@synthesize myAtlas;
@synthesize conveyorBelts;
@synthesize backgroundNode;
@synthesize conveyorNode;
@synthesize foodNode;
@synthesize sprites;
@synthesize orderNotes;
@synthesize lastSentNote;
@synthesize clockHand;
@synthesize endTime;
@synthesize scoreLabel;
@synthesize myAudioPlayer;
@synthesize condimentTimer;
@synthesize condiments;

//static float sliceYMargin[4] = {1,1,1,1};
static float sliceHeight[4] = {11,11,11,11};
static float sliceYMargin[4] = {1,1,1,1};
static float ingredientYMargin[4] = {1,1,1,1};
static float ingredientHeight[4] = {54,54,64,53};

static int condimentScores[3] = {5,5,5};

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        ingredientNames = @[@"loaf.png",@"ham.png",@"lettuce.png",@"cheese.png"];
        sliceNames = @[@"slice.png",@"hams.png",@"leaves.png",@"cheeses.png"];
        extraNames = @[@"onion.png",@"tomato.png",@"pickle.png"];
        crumbNames = @[@"crumbs_bread",@"crumbs_ham",@"crumbs_lettuce",@"crumbs_cheese"];
        plusNames = @[@"plus_onion.png",@"plus_tomato.png",@"plus_pickle.png"];
        condimentCrumbNames = @[@"crumbs_onion",@"crumbs_tomato",@"crumbs_pickle"];
        
        sprites = [[NSMutableArray alloc] initWithCapacity:50];
        condiments = [[NSMutableArray alloc] initWithCapacity:20];
        
        backgroundNode = [SKNode node];
        screenHeight = size.height;
 //       backgroundNode.yScale = size.height/568.0f;
        
        myAtlas = [SKTextureAtlas atlasNamed:@"pieces"];

        conveyorNode = [[SKNode alloc] init];
        foodNode = [[SKNode alloc] init];
        conveyorBelts = [[NSMutableArray alloc] initWithCapacity:10];
        
        [self addChild:backgroundNode];
        
        soundPlayer = [SoundPlayer sharedPlayer];
        backgroundTunes = @[@"entertainer1",@"entertainer2",@"beaumont",@"chattanooga"];
    }
    return self;
}

-(void)setUpWithLevel:(int)l
{
    level = l;
    NSLog(@"Level: %d",level);
    DataHandler *dh = [DataHandler sharedDataHandler];
    [conveyorNode removeAllChildren];
    [foodNode removeAllChildren];
    [backgroundNode removeAllChildren];
    
    // Clear arrays
    [sprites removeAllObjects];
    [condiments removeAllObjects];
    [conveyorBelts removeAllObjects];
    for (int i=0;i<MAX_SANDWICHES;i++)
    {
        ordersMet[i] = FALSE;
        ordersShown[i] = FALSE;
        numIngredients[i] = 0;
        for (int j=0;j<MAX_STACK;j++)
            sandwichIngredients[i][j] = 0;
    }
    orderCount = 0;
    
    levDic = [dh getLevelNumber:level];
    NSDictionary *restDic = [dh getRestaurantForLevel:level];
    NSLog(@"levDic: %@",levDic);
    NSLog(@"restDic: %@",restDic);
    
    // Put in background image
    SKSpriteNode *backgroundTiles = [SKSpriteNode spriteNodeWithImageNamed:[restDic objectForKey:@"background"]];
    backgroundTiles.anchorPoint = CGPointMake(0, 0);
    backgroundTiles.position = CGPointMake(0, screenHeight-backgroundTiles.size.height);
    [backgroundNode addChild:backgroundTiles];
    
    
    // Clock
    SKNode *clockNode = [SKNode node];
    clockNode.position = CGPointMake(-97.0, screenHeight);
    SKSpriteNode *clockSprite = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"new_clock.png"]];
    clockSprite.anchorPoint = CGPointMake(0, 1.0);
    clockSprite.position = CGPointMake(0, 0);
    [clockNode addChild:clockSprite];
    clockHand = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"clock_hand.png"]];
    clockHand.anchorPoint = CGPointMake(0.5, 0.125);
    clockHand.position = CGPointMake(38.0, -32.0);
    [clockNode addChild:clockHand];
    scoreLabel = [SKLabelNode node];
    scoreLabel.fontName = @"Knewave";
    score = 0;
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 18.0;
    scoreLabel.fontColor = [UIColor whiteColor];
    scoreLabel.position = CGPointMake(38.0, -78.0);
    [clockNode addChild:scoreLabel];
    [conveyorNode addChild:clockNode];
    [clockNode runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0],[SKEase MoveToWithNode:clockNode EaseFunction:CurveTypeQuadratic Mode:EaseOut Time:0.5 ToVector:CGVectorMake(0, clockNode.position.y)]]]];
    
    // Used for proper random ingredient distribution
    ingredientsString = [NSMutableString stringWithCapacity:100];
    sandwichOrders = [levDic objectForKey:@"orders"];
    numOrders = (int)sandwichOrders.count;
    orderNotes = [NSMutableArray arrayWithCapacity:numOrders];
    int k = 0;
    for (NSString *tmpS in sandwichOrders)
    {
        [ingredientsString appendString:tmpS];
        
        numIngredients[k] = (int)tmpS.length;
        for (int i=0;i<numIngredients[k];i++)
        {
            sandwichIngredients[k][numIngredients[k]-i-1] = ([tmpS characterAtIndex:i]-'0');
        }
        
        // Draw sandwich on order note
        SKNode *noteHolder = [SKNode node];
        SKSpriteNode *notePaper = [SKSpriteNode spriteNodeWithImageNamed:@"paper.png"];
        [noteHolder addChild:notePaper];
        float sandH = 0;
        for (int j=0;j<tmpS.length;j++)
        {
            int tp = ([tmpS characterAtIndex:j]-'0');
            sandH += sliceHeight[tp]*NOTE_SCALE;
        }
        float sandY = (sandH-sliceHeight[0])/2.0; // Slight adjustment
        for (int j=0;j<tmpS.length;j++)
        {
            int tp = ([tmpS characterAtIndex:j]-'0');
            SKSpriteNode *layerSprite = [SKSpriteNode spriteNodeWithImageNamed:[sliceNames objectAtIndex:tp]];
            layerSprite.position = CGPointMake(0, sandY);
            layerSprite.xScale = NOTE_SCALE;
            layerSprite.yScale = NOTE_SCALE;
            [noteHolder addChild:layerSprite];
            sandY -= sliceHeight[tp]*NOTE_SCALE;
        }
        
        noteHolder.zRotation = -0.2;
        noteHolder.position = CGPointMake(NOTE_START_X, screenHeight-NOTE_Y);
        [conveyorNode addChild:noteHolder];
        [orderNotes addObject:noteHolder];
        k++;
    }
    for (int i=0;i<MAX_SANDWICHES;i++)
    {
        ordersMet[i] = FALSE;
        ordersShown[i] = FALSE;
    }
    orderCount = 0;
    ordersComplete = 0;
    topScoreLimit = [dh getTopScoreForLevel:level];
    bottomScoreLimit = [dh getBottomScoreForLevel:level];
    middleScoreLimit = [dh getMiddleScoreForLevel:level];
    
    // Compute conveyor belt positions
    NSArray *beltArr = [levDic objectForKey:@"belts"];
    planeDist = (screenHeight-TOP_PLANE_Y-BOTTOM_PLANE_Y)/beltArr.count;
    numPlanes = (int)beltArr.count + 1;
    int y = BOTTOM_PLANE_Y;
    for (int i=0;i<numPlanes;i++)
    {
        planeY[i] = y;
        y+=planeDist;
    }
    
    // Conveyor belts
//    y = planeY[numPlanes-1];
    y = planeY[1];
    for (int i=0;i<numPlanes-1;i++)
    {
        SKNode *beltNode = [SKNode node];
        beltNode.position = CGPointMake(0, 600.0);
        int beltVelocity = [(NSNumber*)[beltArr objectAtIndex:i] intValue];
        int beltSpeed = beltVelocity;
        if (beltSpeed < 0)
            beltSpeed = -beltSpeed;
        SKSpriteNode *topS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"belt.png"]];
        topS.anchorPoint = CGPointMake(0, 1.0);
        SKSpriteNode *bottomS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"bottom.png"]];
        bottomS.anchorPoint = CGPointMake(0, 1.0);
        
        bottomS.position = CGPointMake(0, -BELT_THICKNESS);
        if (beltVelocity < 0)
        {
            SKAction *moveLeft = [SKAction moveToX:-40.0 duration:40.0/beltSpeed];
            SKAction *returnLeft = [SKAction moveToX:0 duration:0];
            SKAction *leftSequence = [SKAction repeatActionForever:[SKAction sequence:@[moveLeft,returnLeft]]];
            topS.position = CGPointMake(0, 0);
            [topS runAction:leftSequence];
        }
        else
        {
            SKAction *moveRight = [SKAction moveToX:0 duration:40.0/beltSpeed];
            SKAction *returnRight = [SKAction moveToX:-40.0 duration:0];
            SKAction *rightSequence = [SKAction repeatActionForever:[SKAction sequence:@[moveRight,returnRight]]];
            topS.position = CGPointMake(-40.0, 0);
            [topS runAction:rightSequence];
        }
        
        beltVelocities[i+1] = beltVelocity;
        [beltNode addChild:topS];
        [beltNode addChild:bottomS];
        [conveyorNode addChild:beltNode];
        [beltNode runAction:[SKAction sequence:@[[SKAction waitForDuration:0.3*i],[SKEase MoveToWithNode:beltNode EaseFunction:CurveTypeQuadratic Mode:EaseOut Time:0.7 ToVector:CGVectorMake(0, y)]]]];
        
        y+=planeDist;
    }
    
    // Plates
    numPlates = [(NSNumber*)[levDic objectForKey:@"plates"] intValue];
    for (int i=0;i<numPlates;i++)
    {
        SKSpriteNode *plateS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"plate.png"]];
        plateS.anchorPoint = CGPointMake(0.5, 1.0);
        float plateX = i*320.0/numPlates+160.0/numPlates;
        plateS.position = CGPointMake(360.0, planeY[0]);
        [conveyorNode addChild:plateS];
        [plateS runAction:[SKAction sequence:@[[SKAction waitForDuration:i*0.3],[SKEase MoveToWithNode:plateS EaseFunction:CurveTypeQuadratic Mode:EaseOut Time:0.5 ToVector:CGVectorMake(plateX, plateS.position.y)]]]];
    }
    
    // Condiments
    condimentTypes = [levDic objectForKey:@"condiments"];
    condimentInterval = [(NSNumber*)[levDic objectForKey:@"condimentInterval"] floatValue];
    
    [backgroundNode addChild:conveyorNode];
    [backgroundNode addChild:foodNode];
    
    lastSentNote = [NSDate date];
    
    [owner showLevelIndicatorForLevel:l];
    [soundPlayer playLevelWithDelay:0.2 WithNode:conveyorNode];
    
    [self performSelector:@selector(activateLevel) withObject:NULL afterDelay:2.0];
}

-(void)activateLevel
{
    clockTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
                                                selector: @selector(gameLoop:) userInfo: nil repeats: YES];
    
    spawnFoodTimer = [NSTimer scheduledTimerWithTimeInterval:FOOD_DISTANCE/beltVelocities[numPlanes-1] target:self
                                                    selector:@selector(spawnIngredient) userInfo:nil repeats:YES];
    
    if (condimentTypes != NULL)
    {
        condimentTimer = [NSTimer scheduledTimerWithTimeInterval: condimentInterval target: self
                                                        selector: @selector(spawnCondiment) userInfo: nil repeats: YES];
    }
    
    zCounter = 0;
    totalTime = [(NSNumber*)[levDic objectForKey:@"time"] doubleValue];
    endTime = [NSDate dateWithTimeIntervalSinceNow:totalTime];
    
    gameState = STATE_PLAYING;
    
    // Start music
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"musicOn"])
    {
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:[backgroundTunes objectAtIndex:(level % backgroundTunes.count)] ofType: @"mp3"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath ];
        myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        myAudioPlayer.numberOfLoops = -1; //infinite loop
        [myAudioPlayer play];
    }
}

-(void)replayLevel
{
    [self setUpWithLevel:level];
}

-(void)nextLevel
{
    [owner showKitchenSceneWithLevel:level + 1];
//    [self setUpWithLevel:level + 1];
}

-(void)gameLoop:(NSTimer*)t
{
    if ([lastSentNote timeIntervalSinceNow] < -0.5)
    {
        int visibleOrderCount = 0;
        for (int i=0;i<numOrders;i++)
        {
            if (ordersShown[i])
                visibleOrderCount++;
        }
        if (visibleOrderCount < MAX_VISIBLE_NOTES && orderCount < numOrders)
        {
            // See if we can move anything already visible up
            for (int i=0;i<orderCount;i++)
            {
                if (ordersShown[i])
                {
                    int filledPositions = 0;
                    for (int j=0;j<i;j++)
                        if (ordersShown[j])
                            filledPositions++;
                    SKNode *noteNode = (SKNode*)[orderNotes objectAtIndex:i];
                    float dist = NOTE_STOP_X-filledPositions*NOTE_DISTANCE-noteNode.position.x;
                    if (dist > 1.0)
                    {
                        [soundPlayer playSlideWithNode:backgroundNode];
                        [noteNode runAction:[SKEase MoveToWithNode:noteNode EaseFunction:CurveTypeQuadratic Mode:EaseOut Time:dist/300.0 ToVector:CGVectorMake(NOTE_STOP_X-filledPositions*NOTE_DISTANCE, screenHeight-NOTE_Y)]];
                    }
                }
            }
            
            // Show next order in line
            SKNode *noteNode = (SKNode*)[orderNotes objectAtIndex:orderCount];
            float dist = NOTE_STOP_X-visibleOrderCount*NOTE_DISTANCE + NOTE_START_X;
            
            [soundPlayer playSlideWithNode:backgroundNode];
            [noteNode runAction:[SKEase MoveToWithNode:noteNode EaseFunction:CurveTypeQuadratic Mode:EaseOut Time:dist/300.0 ToVector:CGVectorMake(NOTE_STOP_X-visibleOrderCount*NOTE_DISTANCE, screenHeight-NOTE_Y)]];
            
            ordersShown[orderCount] = TRUE;
            visibleOrderCount++;
            orderCount++;
        }
        
        lastSentNote = [NSDate date];
    }
    [self checkPlates];
    // Update clock
    float handAngle = 6.28*(([endTime timeIntervalSinceNow]-totalTime)/totalTime);
    clockHand.zRotation = handAngle;
    if (handAngle < -5.5) // Red area
        [soundPlayer playBlipWithNode:backgroundNode];
    if (handAngle <= -6.28) // Out of time
    {
        [self levelFailed];
    }
    else if (gameState == STATE_PLAYING && ordersComplete == numOrders)
    {
        [self levelFinished];
    }
}

-(void)spawnIngredient
{
    float breadY = planeY[numPlanes-1];
    Food *breadFood = [[Food alloc] initAtPosition:CGPointMake(FOOD_START_X, breadY)];
    
    int foodType = (int)([ingredientsString characterAtIndex:(arc4random()%ingredientsString.length)]-'0');
    
    SKSpriteNode *breadS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:[ingredientNames objectAtIndex:foodType]]];
    breadS.anchorPoint = CGPointMake(0.5, ingredientYMargin[foodType]/ingredientHeight[foodType]);
    [breadFood.holderNode addChild:breadS];
    breadFood.height = breadS.size.height;
    breadFood.width = breadS.size.width;
    breadFood.overallType = foodType;
    breadFood.plane = numPlanes-1;
    
    [foodNode addChild:breadFood.holderNode];
    
    [breadFood.holderNode runAction:
     [SKAction sequence:@[
                          [SKAction moveToX:FOOD_END_X duration:(FOOD_END_X-FOOD_START_X)/beltVelocities[numPlanes-1]],
                          [SKAction runBlock:^{ [self removeFood:breadFood]; }]
                          ]]
     ];
    [sprites addObject:breadFood];
}

-(void)removeFood:(Food*)fObj
{
    [fObj removeSprites];
    [sprites removeObject:fObj];
}

-(void)spawnCondiment
{
    int cPlane = 1+(arc4random()%(numPlanes-2));
    float cY = planeY[cPlane];
    int cType = [(NSNumber*)[condimentTypes objectAtIndex:arc4random()%condimentTypes.count] intValue];
    
    SKSpriteNode *cS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:[extraNames objectAtIndex:cType]]];
    cS.anchorPoint = CGPointMake(0.5, 0);
    
    Condiment *cond = [[Condiment alloc] init];
    cond.condimentType = cType;
    cond.condimentSprite = cS;
    cond.plane = cPlane;
    SKNode *cH = [SKNode node];
    cond.condimentHolder = cH;
    [cH addChild:cS];
    [foodNode addChild:cH];
    
    cond.xVelocity = CONDIMENT_SPEED_RATIO * beltVelocities[cPlane];
    if (beltVelocities[cPlane] > 0)
    {
        cH.position = CGPointMake(FOOD_START_X, cY);
        [cH runAction:[SKAction sequence:@[[SKAction moveToX:FOOD_END_X duration:(FOOD_END_X-FOOD_START_X)/cond.xVelocity],
                                       [SKAction runBlock:^{ [self removeCondiment:cond];}]
                                       ]]
         ];
    }
    else
    {
        cH.position = CGPointMake(FOOD_END_X, cY);
        [cH runAction:[SKAction sequence:@[
                                           [SKAction moveToX:FOOD_START_X duration:(FOOD_START_X-FOOD_END_X)/cond.xVelocity],
                                           [SKAction runBlock:^{ [self removeCondiment:cond];}]
                                           ]]
         ];
    }
    SKAction *moveUp = [SKAction moveByX:0 y:CONDIMENT_JUMP_HEIGHT duration:CONDIMENT_JUMP_TIME];
    moveUp.timingMode = SKActionTimingEaseOut;
    SKAction *moveDown = [SKAction moveByX:0 y:-CONDIMENT_JUMP_HEIGHT duration:CONDIMENT_JUMP_TIME];
    moveDown.timingMode = SKActionTimingEaseIn;
    
    [cS runAction:[SKAction repeatActionForever:[SKAction sequence:@[moveUp,moveDown,[SKAction scaleXTo:1.1 y:0.75 duration:0.1f],[SKAction scaleXTo:1.0 y:1.0 duration:0.1f]]]]];
    [soundPlayer playBoingWithNode:cS];
    [condiments addObject:cond];
}

-(void)removeCondiment:(Condiment*)cObj
{
    NSLog(@"Removing condiment");
    [cObj removeSprite];
    [condiments removeObject:cObj];
}

-(void)splatCondiment:(Condiment*)cObj withFood:(Food*)fObj
{
    SKEmitterNode *crumbs = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:[condimentCrumbNames objectAtIndex:cObj.condimentType] ofType:@"sks"]];
    crumbs.position = cObj.condimentHolder.position;
    [foodNode addChild:crumbs];
    SKSpriteNode *plusSprite = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:[plusNames objectAtIndex:cObj.condimentType]]];
    plusSprite.anchorPoint = CGPointMake(0, 0.5f);
    [plusSprite runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction rotateToAngle:0.2 duration:0.3],[SKAction rotateToAngle:-0.2 duration:0.3]]]]];
    [fObj addCondimentType:cObj.condimentType withSprite:plusSprite];
    [soundPlayer playSplatWithNode:foodNode];
    [self removeCondiment:cObj];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (gameState == STATE_PLAYING)
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:backgroundNode];
        
        Food *touchF = NULL;
        NSLog(@"Touchdown %f,%f",location.x,location.y);
        for (Food *tmpF in sprites)
        {
            NSLog(@"Food position: %f,%f",tmpF.holderNode.position.x,tmpF.holderNode.position.y);
            if ([tmpF isTouchingAtX:location.x andY:location.y])
            {
                NSLog(@"Touching");
                touchF = tmpF;
            }
        }
        if (touchF != NULL)
        {
            if (touchF.overallType >= TYPE_LOAF && touchF.overallType <= TYPE_CHEESE)
            {
                // Mark touch with scale animation
                [soundPlayer playChopWithNode:backgroundNode];
                [touchF.holderNode runAction:[SKAction sequence:@[[SKAction scaleTo:1.1 duration:0.1],[SKAction scaleTo:1.0 duration:0.1]]]];
                // Spawn slice
                int sliceType = touchF.overallType;
                Food *sliceFood = [[Food alloc] initAtPosition:touchF.holderNode.position];
                SKSpriteNode *sliceS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:[sliceNames objectAtIndex:sliceType]]];
                sliceFood.overallType = TYPE_FALLING;
                sliceS.anchorPoint = CGPointMake(0.5, sliceYMargin[sliceType]/sliceHeight[sliceType]);
                [sliceFood addType:sliceType withSprite:sliceS];
                
                sliceFood.plane = touchF.plane-1;
                [foodNode addChild:sliceFood.holderNode];
                SKEmitterNode *crumbs = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:[crumbNames objectAtIndex:sliceType] ofType:@"sks"]];
                crumbs.position = CGPointMake(touchF.holderNode.position.x,touchF.holderNode.position.y+CRUMB_OFFSET);
                [foodNode addChild:crumbs];
                
                [self dropFood:sliceFood];
                
                [sprites addObject:sliceFood];
            }
            else if (touchF.overallType == TYPE_COMPOUND && touchF.plane > 0)
            {
                [soundPlayer playKnockWithNode:backgroundNode];
                [touchF.holderNode removeAllActions];
                touchF.plane--;
                [self dropFood:touchF];
            }
        }
    }
}

-(void)dropFood:(Food*)sliceFood
{
    Food *targetFood = NULL;
    zCounter += 1.0;
    sliceFood.holderNode.zPosition = zCounter;
    sliceFood.overallType = TYPE_FALLING;
    float heightDifference = 0.0;
    float dropTime = 0.0;
    float impactX = 0.0;
    for (Food *tmpF in sprites)
        if (tmpF.overallType == TYPE_COMPOUND && tmpF.plane == sliceFood.plane && tmpF.typeCount+sliceFood.typeCount <= MAX_STACK)
        {
            // Check if falling food is close enough to hit
            heightDifference = planeY[sliceFood.plane+1] - planeY[sliceFood.plane] - tmpF.height;
            dropTime = heightDifference/FALL_SPEED;
            impactX = tmpF.holderNode.position.x + dropTime*beltVelocities[sliceFood.plane];
            if (sliceFood.holderNode.position.x < impactX+HIT_DISTANCE && sliceFood.holderNode.position.x > impactX-HIT_DISTANCE) // Success!
            {
                targetFood = tmpF;
                break;
            }
        }
    
    if (targetFood != NULL) // Land on food
    {
        [soundPlayer playLandWithDelay:dropTime*0.8 withNode:backgroundNode];
        targetFood.overallType = TYPE_CATCHING;
        [sliceFood.holderNode runAction:[SKAction sequence:@[
                                                             [SKAction group:@[
                                                                               [SKEase MoveToWithNode:sliceFood.holderNode EaseFunction:CurveTypeCartoony Mode:EaseOut Time:dropTime ToVector:CGVectorMake(sliceFood.holderNode.position.x, sliceFood.holderNode.position.y-heightDifference)],
                                                                               [SKAction moveToX:impactX duration:dropTime]
                                                                               
                                                                               ]],
                                                             [SKAction runBlock:^{ [targetFood putOnTop:sliceFood]; }],
                                                             [SKAction runBlock:^{ [self removeFood:sliceFood]; }]
                                                             ]]];
    }
    else if (sliceFood.plane > 0) // Land on belt
    {
        float landX = sliceFood.holderNode.position.x;
        float landY = planeY[sliceFood.plane];
        float fallTime = (sliceFood.holderNode.position.y - landY)/FALL_SPEED;
        SKAction *slideOutAction;
        if (beltVelocities[sliceFood.plane] < 0)
            slideOutAction = [SKAction moveToX:FOOD_START_X duration:(FOOD_START_X-sliceFood.holderNode.position.x)/beltVelocities[sliceFood.plane]];
        else
            slideOutAction = [SKAction moveToX:FOOD_END_X duration:(FOOD_END_X-sliceFood.holderNode.position.x)/beltVelocities[sliceFood.plane]];
        [soundPlayer playLandWithDelay:fallTime*0.8 withNode:backgroundNode];
        [sliceFood.holderNode runAction:[SKAction sequence:@[
                                                             [SKEase MoveToWithNode:sliceFood.holderNode EaseFunction:CurveTypeCartoony Mode:EaseOut Time:fallTime ToVector:CGVectorMake(landX, landY)],
                                                             [SKAction runBlock:^{ [sliceFood makeCompoundClickable]; }],
                                                             slideOutAction,
                                                             [SKAction runBlock:^{ [self removeFood:sliceFood]; }]
                                                             ]]];
        // Check if food hits condiment
        for (Condiment *cond in condiments)
        {
            if (cond.plane == sliceFood.plane)
            {
                // Check if falling food is close enough to hit
                heightDifference = planeY[sliceFood.plane+1] - planeY[sliceFood.plane] - CONDIMENT_Y_MARGIN;
                dropTime = heightDifference/FALL_SPEED;
                impactX = cond.condimentHolder.position.x + dropTime*cond.xVelocity;
                if (sliceFood.holderNode.position.x < impactX+CONDIMENT_HIT_DISTANCE && sliceFood.holderNode.position.x > impactX-CONDIMENT_HIT_DISTANCE) // Success!
                {
                    cond.plane = -1; // Block against further impacts
                    [cond.condimentHolder runAction:[SKAction sequence:@[[SKAction waitForDuration:dropTime],[SKAction runBlock:^{[self splatCondiment:cond withFood:sliceFood];}]]]];
                }
            }
        }
    }
    else // Possibly land on plate
    {
        float landX = sliceFood.holderNode.position.x;
        float landY = -sliceFood.height-40;
        BOOL foundPlate = FALSE;
        for (int i=0;i<numPlates;i++)
        {
            float plateX = i*320.0/numPlates+160.0/numPlates;
            if (landX < plateX + HIT_DISTANCE && landX > plateX - HIT_DISTANCE)
            {
                foundPlate = TRUE;
                landX = plateX;
                landY = planeY[0];
            }
        }
        float fallTime = (sliceFood.holderNode.position.y - landY)/FALL_SPEED;
        if (foundPlate)
        {
            [soundPlayer playLandWithDelay:fallTime*0.8 withNode:backgroundNode];
            [sliceFood.holderNode runAction:[SKAction sequence:@[
                                                                 [SKEase MoveToWithNode:sliceFood.holderNode EaseFunction:CurveTypeCartoony Mode:EaseOut Time:fallTime ToVector:CGVectorMake(landX, landY)],
                                                                 [SKAction runBlock:^{ [sliceFood makeCompoundClickable]; }]
                                                                 ]]];
        }
        else // Fall off screen
        {
            [sliceFood.holderNode runAction:[SKAction sequence:@[
                                                                 // Change curve later
                                                                 [SKEase MoveToWithNode:sliceFood.holderNode EaseFunction:CurveTypeCartoony Mode:EaseOut Time:fallTime ToVector:CGVectorMake(landX, landY)],
                                                                 [SKAction runBlock:^{ [self removeFood:sliceFood]; }]
                                                                 ]]];
        }
    }
}

-(void)checkPlates
{
    for (Food *tmpF in sprites)
    {
        if (tmpF.overallType == TYPE_COMPOUND && tmpF.plane == 0)
        {
            int matchedFood = -1;
            int foodScore = 0;
            int mismatches = 0;
            int numVisibleOrders = 0;
            for (int i=0;i<MAX_ORDERS;i++)
                if (ordersShown[i])
                {
                    numVisibleOrders++;
                    int s[MAX_STACK];
                    // Count exact matches
                    int exactMatches = 0;
                    for (int j=0;j<numIngredients[i];j++)
                    {
                        s[j] = sandwichIngredients[i][j];
                        if (j < tmpF.typeCount && s[j] == [tmpF getTypeAt:j])
                            exactMatches++;
                    }
                    if (tmpF.typeCount == numIngredients[i] && tmpF.typeCount == exactMatches) // Perfect
                    {
                        foodScore = exactMatches * BLACK_POINTS;
                        matchedFood = i;
                        break;
                    }
                    // Count near matches
                    int nearMatches = 0;
                    BOOL mismatched = FALSE;
                    for (int j=0;j<tmpF.typeCount;j++)
                    {
                        int k=0;
                        while (k<numIngredients[i] && s[k] != [tmpF getTypeAt:j])
                            k++;
                        if (k<numIngredients[i])
                        {
                            s[k] = -1;
                            nearMatches++;
                        }
                        else
                            mismatched = TRUE;
                    }
                    if (tmpF.typeCount == numIngredients[i] && tmpF.typeCount == nearMatches) // Close enough
                    {
                        int scoreCandidate = exactMatches * BLACK_POINTS + (nearMatches-exactMatches) * WHITE_POINTS;
                        if (scoreCandidate > foodScore)
                        {
                            foodScore = scoreCandidate;
                            matchedFood = i;
                        }
                    }
                    else if (mismatched)
                    {
                        mismatches++;
                    }
                }
            
            if (numVisibleOrders > 0 && mismatches == numVisibleOrders) // Unworkable combination
            {
                [soundPlayer playErrorWithNode:backgroundNode];
                tmpF.plane = -1;
                NSLog(@"Number of mismatches: %d",mismatches);
                SKSpriteNode *handSprite = [SKSpriteNode spriteNodeWithImageNamed:@"sweephand.png"];
                handSprite.anchorPoint = CGPointMake(0.5, 0);
                handSprite.position = CGPointMake(tmpF.holderNode.position.x, -30.0);
                handSprite.zRotation = 1.5;
                zCounter += 1.0;
                handSprite.zPosition = zCounter;
                [backgroundNode addChild:handSprite];
                tmpF.overallType = 1000;

                for (SKSpriteNode *tmpS in tmpF.holderNode.children)
                {
                    [tmpS runAction:[SKAction sequence:@[[SKAction waitForDuration:0.25],
                                                         [SKAction group:@[
                                                         [SKAction moveBy:CGVectorMake(200.0+(arc4random()%100),50+(arc4random()%150)) duration:0.5],
                                                         [SKAction rotateByAngle:0.02*(arc4random()%100) duration:0.5]]]]]];
                }
                [tmpF.holderNode runAction:[SKAction sequence:@[
                                                                [SKAction waitForDuration:0.25],
                                                                [SKEase MoveToWithNode:tmpF.holderNode EaseFunction:CurveTypeCubic Mode:EaseIn Time:0.5 ToVector:CGVectorMake(tmpF.holderNode.position.x, -160.0)]
                                                                ]]];
                [handSprite runAction:[SKAction sequence:@[
                                                           [SKAction rotateToAngle:-1.5 duration:0.5 shortestUnitArc:TRUE],
                                                           [SKAction waitForDuration:0.3],
                                                           [SKAction runBlock:^{[self removeFood:tmpF];}],
                                                           [SKAction removeFromParent]
                                                           ]]];
                break;
            }
            else if (matchedFood >= 0)
            {
                for (int i=0;i<tmpF.plusCount;i++)
                    foodScore += condimentScores[[tmpF getPlusNum:i]];
                
                [soundPlayer playScoreWithNode:backgroundNode];
                [self updateScore:foodScore];
                tmpF.plane = -1;
                SKSpriteNode *handPlateSprite = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"handplate.png"]];
                handPlateSprite.anchorPoint = CGPointMake(0.5, 0.8);
                [tmpF.holderNode addChild:handPlateSprite];
                zCounter += 1.0;
                tmpF.holderNode.zPosition = zCounter;
                
                // Stars
                SKEmitterNode *stars = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"starburst" ofType:@"sks"]];
                stars.position = CGPointMake(tmpF.holderNode.position.x,tmpF.holderNode.position.y+CRUMB_OFFSET);
                stars.numParticlesToEmit = foodScore/WHITE_POINTS;
                zCounter += 1.0;
                stars.zPosition = zCounter;
                [foodNode addChild:stars];
                
                SKNode *noteNode = (SKNode*)[orderNotes objectAtIndex:matchedFood];
                [noteNode runAction:[SKAction fadeAlphaTo:0 duration:1.0]];
                ordersMet[matchedFood] = TRUE;
                ordersShown[matchedFood] = FALSE;
                ordersComplete++;
                
                [tmpF.holderNode runAction:[SKAction sequence:@[
                                                                [SKAction moveBy:CGVectorMake(15.0, 30.0) duration:0.7],
                                                                [SKAction moveBy:CGVectorMake(15.0, -150.0) duration:2.0],
                                                                [SKAction runBlock:^{[self removeFood:tmpF];}]
                                                                ]]];
                
                break;
            }
        }
    }
}

-(void)updateScore:(int)delta
{
    score += delta;
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    [scoreLabel runAction:[SKAction sequence:@[[SKAction scaleTo:1.3 duration:0.2],[SKAction scaleTo:1.0 duration:0.2]]]];
}

-(void)stopEverything
{
//    [myAudioPlayer stop];
    if (clockTimer)
    {
        [clockTimer invalidate];
        clockTimer = NULL;
    }
    if (spawnFoodTimer)
    {
        [spawnFoodTimer invalidate];
        spawnFoodTimer = NULL;
    }
    if (condimentTimer)
    {
        [condimentTimer invalidate];
        condimentTimer = NULL;
    }
    [backgroundNode removeAllActions];
    for (SKNode *tmpN in conveyorNode.children)
        for (SKNode *tmpN2 in tmpN.children)
            [tmpN2 removeAllActions];
    for (SKNode *tmpN in foodNode.children)
        [tmpN removeAllActions];
    for (Condiment *cond in condiments)
    {
        [cond fadeOut];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (myAudioPlayer != NULL)
        [myAudioPlayer stop];
}

-(void)levelFailed
{
    gameState = STATE_DONE;
    [self stopEverything];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *highscores = [[defaults objectForKey:@"highscores"] mutableCopy];
    int prevScore = [((NSNumber*)[highscores objectAtIndex:level]) intValue];
    if (score > prevScore)
    {
        [highscores replaceObjectAtIndex:level withObject:[NSNumber numberWithInt:score]];
        [defaults setObject:highscores forKey:@"highscores"];
        [defaults synchronize];
    }
    DataHandler *dh = [DataHandler sharedDataHandler];
    [owner showFailDialogWithNext:(level < dh.availableLevels-1 && level < dh.currentLevelAccess)];
}

-(void)levelFinished
{
    if (clockTimer)
    {
        [clockTimer invalidate];
        clockTimer = NULL;
    }
    if (myAudioPlayer != NULL)
        [myAudioPlayer stop];
    gameState = STATE_DONE;
    rundownTime = [endTime timeIntervalSinceNow];
    if (rundownTime >= 1.0)
    {
        rundownTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self
                                                    selector: @selector(clockRundown:) userInfo: nil repeats: NO];
        [backgroundNode runAction:[SKAction repeatAction:[SKAction sequence:@[[SKAction playSoundFileNamed:@"drop.wav" waitForCompletion:FALSE],[SKAction waitForDuration:0.1]]] count:(int)rundownTime]];
    }
    else
    {
        [self performSelector:@selector(showLevelCompleteDialog) withObject:NULL afterDelay:1.5];
    }
    if (condimentTimer)
    {
        [condimentTimer invalidate];
        condimentTimer = NULL;
    }
}

-(void)clockRundown:(NSTimer*)t
{
    rundownTime--;
    clockHand.zRotation = 6.28*((rundownTime-totalTime)/totalTime);
    score++;
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    if (rundownTime > 0)
        rundownTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self
                                                  selector: @selector(clockRundown:) userInfo: nil repeats: NO];
    else
    {
        clockHand.zRotation = 0;
        [self performSelector:@selector(showLevelCompleteDialog) withObject:NULL afterDelay:1.5];
    }
}

-(void)showLevelCompleteDialog
{
    [self stopEverything];
    DataHandler *dh = [DataHandler sharedDataHandler];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *highscores = [[defaults objectForKey:@"highscores"] mutableCopy];
    int prevScore = [((NSNumber*)[highscores objectAtIndex:level]) intValue];
    if (score > prevScore)
    {
        [highscores replaceObjectAtIndex:level withObject:[NSNumber numberWithInt:score]];
        [defaults setObject:highscores forKey:@"highscores"];
        [defaults synchronize];
        [dh recomputeLevelAccessWithScore:score andLevel:level];
    }
    [owner showPlusDialog:score>=topScoreLimit?3:(score>=middleScoreLimit?2:1) nextLevelAvailable:(level < dh.availableLevels-1 && level < dh.currentLevelAccess)];
}

@end
