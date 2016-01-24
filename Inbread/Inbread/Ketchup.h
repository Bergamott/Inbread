//
//  Ketchup.h
//  Inbread
//
//  Created by Karl on 2016-01-24.
//  Copyright © 2016 Karl. All rights reserved.
//

#import "Animal.h"

@interface Ketchup : Animal {
    
    int planeNum;
    BOOL spilling;
}

-(void)startAtX:(float)x andY:(float)y onPlane:(int)p withVelocity:(float)vel;

@property(nonatomic) int planeNum;
@property(nonatomic) BOOL spilling;

@end
