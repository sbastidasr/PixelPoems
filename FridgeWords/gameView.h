//
//  gameView.h
//  PixelPoems
//
//  Created by Sebastian Bastidas on 7/17/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"

@interface gameView : UIScrollView


@property (nonatomic, strong) NSMutableArray* wordLabels; //of dictionaries containing a word+attributes


-(void)removeLabelsFromView;
-(void)addLabelsToView;
@end
