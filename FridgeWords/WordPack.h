//
//  WordPack.h
//  FridgeWords
//
//  Created by Sebastian Bastidas on 3/23/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordPack : NSObject

//Words that arent necessary, can be chosen.
@property (nonatomic, strong) NSArray* words;
@property (nonatomic, strong) NSString* packName;


+ (NSArray *)loadWordPacks;
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end
