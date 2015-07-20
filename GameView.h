//
//  GameView.h
//  PixelPoems
//
//  Created by Sebastian Bastidas on 7/17/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <WYPopoverController.h>
#import "WordLabel.h"
#import "PlistLoader.h"
#import "WordPackWrapper.h"
#import "PopupTableViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "constants.h"
#import "GameViewController.h"


@interface GameView : UIScrollView

@property (nonatomic, strong) GameViewController *asd;

@property (nonatomic, strong) NSMutableArray *wordLabels; //of dictionaries containing a word+attributes
-(void)removeLabelsFromView;
-(void)addLabelsToView;


@end
