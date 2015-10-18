//
//  DataHandler.h
//  Inbread
//
//  Created by Karl on 2014-10-07.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NUM_LEVELS 36

#define LEVELS_PER_RESTAURANT 12

@interface DataHandler : NSObject {
    NSMutableDictionary *levelDic;
    
    int topScores[NUM_LEVELS];
    int middleScores[NUM_LEVELS];
    int bottomScores[NUM_LEVELS];
    
    int currentLevelAccess;
    int availableLevels;
}

+(DataHandler*)sharedDataHandler;
-(NSString*)getFullPathNameForFile:(NSString*)fName;
-(void)loadEverything;

-(NSMutableDictionary*)getLevelNumber:(int)l;
-(NSMutableDictionary*)getRestaurantForLevel:(int)l;
-(void)saveLevels;

-(int)getTopScoreForLevel:(int)lev;
-(int)getMiddleScoreForLevel:(int)lev;
-(int)getBottomScoreForLevel:(int)lev;

-(void)recomputeLevelAccessWithScore:(int)sc andLevel:(int)lv;

@property(nonatomic,strong) NSMutableDictionary *levelDic;
@property(nonatomic) int currentLevelAccess;
@property(nonatomic) int availableLevels;

@end
