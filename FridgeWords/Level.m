//
//  Level.m
//  FridgeWords
//
//  Created by Sebastian Bastidas on 3/23/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "Level.h"
#import "NSMutableArray+Shuffling.h"
@implementation Level

-(WordSet *)currentWordPack{
    if(!_currentWordPack){
        _currentWordPack=[PlistLoader WordPackNamed:@"asd"];///HERE CHANGE FOR OTHER WORDPACKS
        [_currentWordPack  shuffleWordPack];
        
    }
    return _currentWordPack;
}
@end
