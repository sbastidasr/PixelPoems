//
//  ViewController.h
//  FridgeWords
//
//  Created by Sebastian Bastidas on 2/5/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "WordLabel.h"
#import "WordPackWrapper.h"
#import "PlistLoader.h"

#import <WYPopoverController.h>
#import "PopupTableViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "constants.h"
#import "HomeViewController.h"

@class GameView;

@interface GameViewController : HomeViewController   //most user custmizable settings of current level.

@property (weak, nonatomic) IBOutlet GameView *gameView;


//Theme (Contains WordStyle&Background  )
//WordStyle (i.e. font etc)
//Background {image | Pattern}

//Game Title  (For saving)

#pragma mark - Methods
//Saving
//Loading.

@end

