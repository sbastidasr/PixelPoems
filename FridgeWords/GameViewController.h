//
//  ViewController.h
//  FridgeWords
//
//  Created by Sebastian Bastidas on 2/5/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Level.h"

@interface GameViewController : UIViewController  <UIScrollViewDelegate>  //most user custmizable settings of current level.

@property (nonatomic, strong) Level* level; //1 Level. that has necessary words+wordpack.
@property (nonatomic, strong) NSMutableArray* wordLabels; 



//Theme (Contains WordStyle&Background  )
//WordStyle (i.e. font etc)
//Background {image | Pattern}


//Game Title  (For saving)




#pragma mark - Methods
//Saving
//Loading.

@end

