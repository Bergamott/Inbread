//
//  MyScene.m
//  Inbread
//
//  Created by Karl on 2014-08-10.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import "MyScene.h"
#import "Food.h"
#import "SKEase.h"


#define NUM_BELTS 5
#define BELT_DY 80.0
#define BELT_BASE_Y
#define SCROLL_INTERVAL 1.0

#define NUM_PLATES 4

#define BREAD_START_X -40.0
#define BREAD_END_X 360.0

@implementation MyScene

@synthesize myAtlas;
@synthesize conveyorBelts;
@synthesize backgroundNode;
@synthesize conveyorNode;
@synthesize breadNode;
@synthesize sprites;

static float ingredientYMargin[4] = {1,1,1,1};
static float ingredientHeight[4] = {54,54,64,53};
static float sliceYMargin[4] = {1,1,1,1};
static float sliceHeight[4] = {11,11,11,11};
static float extraYMargin[3] = {1,1,1};
static float extraHeight[3] = {32,32,20};

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        ingredientNames = @[@"loaf.png",@"ham.png",@"lettuce.png",@"cheese.png"];
        sliceNames = @[@"slice.png",@"hams.png",@"leaves.png",@"cheeses.png"];
        extraNames = @[@"onion.png",@"tomato.png",@"pickle.png"];
        crumbNames = @[@"crumbs_bread",@"crumbs_ham",@"crumbs_lettuce",@"crumbs_cheese"];
        
        sprites = [[NSMutableArray alloc] initWithCapacity:50];
        
//        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        backgroundNode = [SKNode node];
        backgroundNode.yScale = size.height/568.0f;
        SKSpriteNode *backgroundTiles = [SKSpriteNode spriteNodeWithImageNamed:@"background1.jpg"];
        backgroundTiles.anchorPoint = CGPointMake(0, 0);
        backgroundTiles.position = CGPointMake(0, 0);
        [backgroundNode addChild:backgroundTiles];
        
        // Set up conveyor belts
        
        myAtlas = [SKTextureAtlas atlasNamed:@"pieces"];
        conveyorNode = [[SKNode alloc] init];
        [backgroundNode addChild:conveyorNode];
        breadNode = [[SKNode alloc] init];
        [backgroundNode addChild:breadNode];
        conveyorBelts = [[NSMutableArray alloc] initWithCapacity:10];
        
        // Plates
        for (int i=0;i<NUM_PLATES;i++)
        {
            SKSpriteNode *plateS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"plate.png"]];
            plateS.anchorPoint = CGPointMake(0.5, 0);
            plateS.position = CGPointMake(i*320.0/NUM_PLATES+160.0/NUM_PLATES, 0);
            [conveyorNode addChild:plateS];
        }
        
        for (int i=0;i<NUM_BELTS;i++)
        {
            SKSpriteNode *topS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"topbelt.png"]];
            topS.anchorPoint = CGPointMake(0, 0);
            topS.position = CGPointMake(-40.0, BELT_BASE_Y + BELT_DY*(1+i));
            SKAction *moveRight = [SKAction moveToX:0 duration:SCROLL_INTERVAL];
            SKAction *jumpBack = [SKAction moveToX:-40.0 duration:0];
            SKAction *rightSequence = [SKAction repeatActionForever:[SKAction sequence:@[moveRight,jumpBack]]];
            [conveyorBelts addObject:topS];
            [conveyorNode addChild:topS];
            SKSpriteNode *bottomS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:@"bottombelt.png"]];
            bottomS.anchorPoint = CGPointMake(0, 1.0);
            bottomS.position = CGPointMake(0, BELT_BASE_Y + BELT_DY*(1+i));
            SKAction *moveLeft = [SKAction moveToX:-40.0 duration:SCROLL_INTERVAL];
            SKAction *jumpRightBack = [SKAction moveToX:0 duration:0];
            SKAction *leftSequence = [SKAction repeatActionForever:[SKAction sequence:@[moveLeft,jumpRightBack]]];
            if ((i&1) == 0)
            {
                [topS runAction:rightSequence];
                [bottomS runAction:leftSequence];
            }
            else
            {
                [topS runAction:leftSequence];
                [bottomS runAction:rightSequence];
            }
            [conveyorBelts addObject:bottomS];
            [conveyorNode addChild:bottomS];
        }
        
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self
                                       selector:@selector(spawnBread) userInfo:nil repeats:YES];
        [self addChild:backgroundNode];
    }
    return self;
}

-(void)setUpWithLevel:(int)l
{
    
}

-(void)spawnBread
{
    float breadY = BELT_BASE_Y + BELT_DY*NUM_BELTS + 5.0;
    Food *breadFood = [[Food alloc] initAtPosition:CGPointMake(BREAD_START_X, breadY)];
    
    int foodType = arc4random()%4;
    
    SKSpriteNode *breadS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:[ingredientNames objectAtIndex:foodType    ]]];
    breadS.anchorPoint = CGPointMake(0.5, 0);
    [breadFood.holderNode addChild:breadS];
    breadFood.height = breadS.size.height;
    breadFood.width = breadS.size.width;
    breadFood.overallType = foodType;
    breadFood.plane = NUM_BELTS;

    [breadNode addChild:breadFood.holderNode];
    
    [breadFood.holderNode runAction:
     [SKAction sequence:@[
                          [SKAction moveToX:BREAD_END_X duration:10*SCROLL_INTERVAL],
                          [SKAction runBlock:^{ [self removeFood:breadFood]; }]
                          ]]
     ];
    [sprites addObject:breadFood];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:backgroundNode];
        
        Food *touchF = NULL;
        for (Food *tmpF in sprites)
            if ([tmpF isTouchingAtX:location.x andY:location.y])
            {
                touchF = tmpF;
            }
        if (touchF != NULL)
        {
            if (touchF.overallType >= TYPE_LOAF && touchF.overallType <= TYPE_CHEESE)
            {
                [touchF.holderNode runAction:[SKAction sequence:@[[SKAction scaleTo:1.1 duration:0.1],[SKAction scaleTo:1.0 duration:0.1]]]];
                // Spawn slice
                int sliceType = TYPE_SLICE+(touchF.overallType - TYPE_LOAF);
                SKSpriteNode *sliceS = [SKSpriteNode spriteNodeWithTexture:[myAtlas textureNamed:[sliceNames objectAtIndex:sliceType-TYPE_SLICE]]];
                sliceS.anchorPoint = CGPointMake(0.5, 0);
                Food *sliceFood = [[Food alloc] initAtPosition:touchF.holderNode.position];
                [sliceFood.holderNode addChild:sliceS];
                sliceFood.height = sliceS.size.height + 10; // Margin
                sliceFood.width = sliceS.size.width; // Margin
                sliceFood.overallType = TYPE_COMPOUND;
                sliceFood.plane = touchF.plane-1;
                [breadNode addChild:sliceFood.holderNode];
                SKEmitterNode *crumbs = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:[crumbNames objectAtIndex:sliceType-TYPE_SLICE] ofType:@"sks"]];
                crumbs.position = CGPointMake(touchF.holderNode.position.x,touchF.holderNode.position.y+20);
                [breadNode addChild:crumbs];
                [sliceFood.holderNode runAction:
                 [SKAction sequence:@[
                                      [SKEase MoveToWithNode:touchF.holderNode EaseFunction:CurveTypeCartoony Mode:EaseOut Time:0.5f ToVector:CGVectorMake(touchF.holderNode.position.x, BELT_BASE_Y + BELT_DY*(touchF.plane-1) + 5.0)],
//                                      [SKAction moveToY:BELT_BASE_Y + BELT_DY*(touchF.plane-1) + 5.0 duration:0.5],
                                      [SKAction moveToX:-40.0 duration:SCROLL_INTERVAL*(touchF.holderNode.position.x+40.0)/40.0],
                                      [SKAction runBlock:^{ [self removeFood:sliceFood]; }]
                                      ]]
                 ];
                [sprites addObject:sliceFood];
            }
            else if (touchF.overallType >= TYPE_SLICE && touchF.overallType <= TYPE_CHEESES)
            {
                touchF.plane--;
                [touchF.holderNode removeAllActions];
                if (touchF.plane == 0) // Bottom
                {
                    [touchF.holderNode runAction:
                        [SKEase MoveToWithNode:touchF.holderNode EaseFunction:CurveTypeCartoony Mode:EaseOut Time:0.5f ToVector:CGVectorMake(touchF.holderNode.position.x, BELT_BASE_Y + BELT_DY*touchF.plane + 5.0)]
                                          
                     ];
                }
                else if ((touchF.plane&1) == 0)
                {
                    [touchF.holderNode runAction:
                     [SKAction sequence:@[
                                          [SKEase MoveToWithNode:touchF.holderNode EaseFunction:CurveTypeCartoony Mode:EaseOut Time:0.5f ToVector:CGVectorMake(touchF.holderNode.position.x, BELT_BASE_Y + BELT_DY*touchF.plane + 5.0)],
//                                          [SKAction moveToY:BELT_BASE_Y + BELT_DY*touchF.plane + 5.0 duration:0.5],
                                          [SKAction moveToX:-40.0 duration:SCROLL_INTERVAL*(touchF.holderNode.position.x+40.0)/40.0],
                                          [SKAction runBlock:^{ [self removeFood:touchF]; }]
                                          ]]
                     ];
                }
                else
                {
                    [touchF.holderNode runAction:
                     [SKAction sequence:@[
                                          [SKEase MoveToWithNode:touchF.holderNode EaseFunction:CurveTypeCartoony Mode:EaseOut Time:0.5f ToVector:CGVectorMake(touchF.holderNode.position.x, BELT_BASE_Y + BELT_DY*touchF.plane + 5.0)],
//                                          [SKAction moveToY:BELT_BASE_Y + BELT_DY*touchF.plane + 5.0 duration:0.5],
                                          [SKAction moveToX:BREAD_END_X duration:SCROLL_INTERVAL*(BREAD_END_X-touchF.holderNode.position.x)/40.0],
                                          [SKAction runBlock:^{ [self removeFood:touchF]; }]
                                          ]]
                     ];
                }
            }
        }
        
/*        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];*/
    }
}

-(void)removeFood:(Food*)fObj
{
    [fObj removeSprites];
    [sprites removeObject:fObj];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
