//
//  DataHandler.m
//  Inbread
//
//  Created by Karl on 2014-10-07.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import "DataHandler.h"

#define BLACK_POINTS 15
#define WHITE_POINTS 5

@implementation DataHandler

@synthesize levelDic;
@synthesize currentLevelAccess;
@synthesize availableLevels;

+(DataHandler*)sharedDataHandler
{
	static DataHandler *sharedDataHandler;
	
	@synchronized(self)
	{
		if (!sharedDataHandler)
			sharedDataHandler = [[DataHandler alloc] init];
		return sharedDataHandler;
	}
}

-(NSString*)getFullPathNameForFile:(NSString*)fName
{
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [applicationDocumentsDir stringByAppendingPathComponent:fName];
}

-(void)loadEverything
{
/*    NSString *ownedFilePath = [self getFullPathNameForFile:@"levels.data"];
    NSMutableDictionary *tmpD = [[NSMutableDictionary alloc] initWithContentsOfFile:ownedFilePath];
    if (tmpD == NULL)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"txt"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSError *err;
        NSDictionary *json = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        tmpD = [json mutableCopy];
        [tmpD writeToFile:ownedFilePath atomically:TRUE];
    }*/
    
    NSString *ownedFilePath = [self getFullPathNameForFile:@"levels.data"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *err;
    NSDictionary *json = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    NSMutableDictionary *tmpD = [json mutableCopy];
    [tmpD writeToFile:ownedFilePath atomically:TRUE];
    self.levelDic = tmpD;
    
    // Compute scores
    int ix = 0;
    NSArray *restaurants = [levelDic objectForKey:@"restaurants"];
    for (NSDictionary *tmpD1 in restaurants)
    {
        NSArray *levA = [tmpD1 objectForKey:@"levels"];
        for (NSDictionary *tmpD2 in levA)
        {
            NSArray *orderA = [tmpD2 objectForKey:@"orders"];
            int topScore = 0;
            int bottomScore = 0;
            for (NSString *tmpS in orderA)
            {
                topScore += BLACK_POINTS*tmpS.length;
                bottomScore += WHITE_POINTS*tmpS.length;
            }
            
            topScores[ix] = topScore;
            bottomScores[ix] = bottomScore;
            middleScores[ix] = (topScore + bottomScore)/2;
            ix++;
        }
    }
    availableLevels = ix;
    
    currentLevelAccess = 0;
    NSArray *highscores = [[NSUserDefaults standardUserDefaults] objectForKey:@"highscores"];
    ix = 0;
    for (NSNumber *tmpN in highscores)
    {
        int sc = [tmpN intValue];
        if (sc > 0 && sc >= bottomScores[ix])
            currentLevelAccess = ix + 1;
        ix++;
    }
    
    currentLevelAccess = NUM_LEVELS; // TODO: Remove later
}

-(NSMutableDictionary*)getLevelNumber:(int)l
{
    int levCount = 0;
    NSMutableDictionary *result = NULL;
    NSMutableArray *restaurants = [levelDic objectForKey:@"restaurants"];
    for (NSMutableDictionary *tmpD in restaurants)
    {
        if (result == NULL)
        {
            NSMutableArray *levs = [tmpD objectForKey:@"levels"];
            if (levs.count + levCount > l)
            {
                result = [levs objectAtIndex:l-levCount];
            }
            levCount+=levs.count;
        }
    }
    return result;
}

-(NSMutableDictionary*)getRestaurantForLevel:(int)l
{
    int levCount = 0;
    NSMutableDictionary *result = NULL;
    NSMutableArray *restaurants = [levelDic objectForKey:@"restaurants"];
    for (NSMutableDictionary *tmpD in restaurants)
    {
        if (result == NULL)
        {
            NSMutableArray *levs = [tmpD objectForKey:@"levels"];
            if (levs.count + levCount > l)
            {
                result = tmpD;
            }
            levCount+=levs.count;
        }
    }
    return result;
}


-(void)saveLevels
{
    NSString *ownedFilePath = [self getFullPathNameForFile:@"levels.data"];
    [levelDic writeToFile:ownedFilePath atomically:TRUE];
}

-(int)getTopScoreForLevel:(int)lev
{
    return topScores[lev];
}
-(int)getMiddleScoreForLevel:(int)lev
{
    return middleScores[lev];
}
-(int)getBottomScoreForLevel:(int)lev
{
    return bottomScores[lev];
}

-(void)recomputeLevelAccessWithScore:(int)sc andLevel:(int)lv
{
    if (lv == currentLevelAccess)
    {
        if (sc >= bottomScores[lv])
            currentLevelAccess = lv+1;
    }
}

@end
