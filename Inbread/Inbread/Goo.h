//
//  Goo.h
//  Inbread
//
//  Created by Karl on 2016-01-10.
//  Copyright © 2016 Karl. All rights reserved.
//

#import "Animal.h"

@interface Goo : Animal {
    
    int planeNum;
}

-(void)startAtX:(float)x andY:(float)y onPlane:(int)p withVelocity:(float)vel;

@property(nonatomic) int planeNum;

@end
