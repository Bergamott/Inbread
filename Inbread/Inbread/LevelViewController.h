//
//  LevelViewController.h
//  Inbread
//
//  Created by Karl on 2014-11-15.
//  Copyright (c) 2014 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelViewController : UIViewController {
    
    IBOutlet UIView *containerView;
    
    IBOutlet UIImageView *mouth0;
    IBOutlet UIImageView *lock0;
    IBOutlet UIImageView *mouth1;
    IBOutlet UIImageView *lock1;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIView *holderView0;
    IBOutlet UIView *holderView1;
}

-(IBAction)breadPressed:(id)sender;

@end
