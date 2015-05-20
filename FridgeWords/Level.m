//
//  Level.m
//  FridgeWords
//
//  Created by Sebastian Bastidas on 3/23/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "Level.h"

@implementation Level

-(WordPack *)wordPack{
    if(!_wordPack){
        _wordPack=[[WordPack alloc]init];
    }
    return _wordPack;
}
@end
