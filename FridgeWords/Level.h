//
//  Level.h
//  FridgeWords
//
//  Created by Sebastian Bastidas on 3/23/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlistLoader.h"
#import "WordSet.h"
@interface Level : NSObject

@property(nonatomic, strong) WordSet* levelWords; //words That MUST go.
@property(nonatomic, strong) WordSet* currentWordPack;  //words from wordpack
//Words that must go.
//Wordpack

@end
