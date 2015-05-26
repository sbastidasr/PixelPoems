//
//  Level.m
//  FridgeWords
//
//  Created by Sebastian Bastidas on 3/23/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "Level.h"

@implementation Level

-(WordPack *)currentWordPack{
    if(!_currentWordPack){
        NSArray *wordPacks  =  [ WordPack loadWordPacks];
        
        _currentWordPack=[wordPacks firstObject];   ///HERE CHANGE FOR OTHER WORDPACKS
        
    }
    return _currentWordPack;
}
@end
