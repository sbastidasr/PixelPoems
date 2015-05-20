//
//  WordLabel.m
//  FridgeWords
//
//  Created by Sebastian Bastidas on 5/20/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "WordLabel.h"

@implementation WordLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//border width.
//NSString *word
//font
//size.
//color (border+font)
//background color or image.

    
#pragma mark - Initialization
    - (instancetype)initWithFrame:(CGRect)frame{
        self = [super initWithFrame:frame];
        if (self) {
            [self setup];
            
        }
        return self;
    }
    
    -(void)setup{
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2.0;
        self.backgroundColor = nil;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:30];
 
        self.textAlignment = NSTextAlignmentCenter;
        
   
      //  self.opaque=NO;
  
    //    self.contentMode=UIViewContentModeRedraw;
    }
    
    -(void)awakeFromNib{
        [self setup];
    }

@end
