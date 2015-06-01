//
//  gameView.m
//  FridgeWords
//
//  Created by Sebastian Bastidas on 5/20/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "CutGameView.h"

@implementation CutGameView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
   
        [[UIColor whiteColor] setStroke];
    //[[UIColor blueColor]setFill];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    
        UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:screenRect cornerRadius:0];
        [aPath setLineWidth:4.0];
       [aPath stroke];
  //  [aPath fill];
    
    
    
    
    //Now, draw a blue rect at the center.

}

@end
