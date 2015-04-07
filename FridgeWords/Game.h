//
//  Game.h
//  FridgeWords
//
//  Created by Sebastian Bastidas on 3/23/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//
//  MAIN GAME CLASS!!!

#import <Foundation/Foundation.h>
#import "Level.h"

@interface Game : NSObject


@property (nonatomic, strong) Level* currentLevel; //1 Level. that has necessary words+wordpack.
@property (nonatomic, strong) NSString* title;



//Theme (Contains WordStyle&Background  )
//WordStyle (i.e. font etc)
//Background {image | Pattern}


//Game Title  (For saving)




#pragma mark - Methods
//Saving
//Loading.


@end
