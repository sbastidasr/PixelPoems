//
//  ViewController.h
//  FridgeWords
//
//  Created by Sebastian Bastidas on 2/5/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gameView.h"


@interface GameViewController : UIViewController  <UIScrollViewDelegate>  //most user custmizable settings of current level.
@property (weak, nonatomic) IBOutlet gameView *gameView;


//Theme (Contains WordStyle&Background  )
//WordStyle (i.e. font etc)
//Background {image | Pattern}

//Game Title  (For saving)

#pragma mark - Methods
//Saving
//Loading.

@end

