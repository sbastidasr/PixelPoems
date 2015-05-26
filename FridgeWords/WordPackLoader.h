//
//  WordPack.h
//  FridgeWords
//
//  Created by Sebastian Bastidas on 3/23/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordPackLoader : NSObject
@property (nonatomic,strong)NSArray *wordPacks;

+(WordPackLoader *)WordPackNamed:(NSString *)packName;

@end
