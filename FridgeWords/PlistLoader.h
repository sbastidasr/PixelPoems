//
//  WordPack.h
//  FridgeWords
//
//  Created by Sebastian Bastidas on 3/23/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordPackWrapper.h"

@interface PlistLoader : NSObject
@property (nonatomic,strong)NSArray *wordPacks;

+(PlistLoader *)defaultWordPack;
+(NSArray *)loadWordPacks;
+(WordPackWrapper *)WordPackNamed:(NSString *)packName;
    
    
+(NSDictionary *)loadSavedGameDictionaryFromPList;
+(void)saveGameArrayToPlist:(NSArray *)wordLabels Named:(NSString *)name;
+(void)saveSavedGameDictionaryFromPList:(NSMutableDictionary *) savedGameDictionary;
@end