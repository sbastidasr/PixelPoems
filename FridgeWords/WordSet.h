//
//  WordPack.h
//  PixelPoems
//
//  Created by Sebastian Bastidas on 5/26/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordSet : NSObject


//Words that arent necessary, can be chosen.
@property (nonatomic, strong) NSMutableArray* words;
@property (nonatomic, strong) NSString* packName;


- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;


-(void)shuffleWordPack;
@end
