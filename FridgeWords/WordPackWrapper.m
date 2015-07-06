//
//  WordPack.m
//  PixelPoems
//
//  Created by Sebastian Bastidas on 5/26/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "WordPackWrapper.h"

@implementation WordPackWrapper


// Init the object with information from a dictionary
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    if(self = [self init]) {
        // Assign all properties with keyed values from the dictionary
        _packName = [jsonDictionary objectForKey:@"packName"];
        _words = [jsonDictionary objectForKey:@"words"];
        
    }
    return self;
}


-(void)shuffleWordPack{
    NSMutableArray *asd = [self.words mutableCopy];
    NSInteger count = [asd count];
    for (NSInteger i = 0; i < count - 1; i++){
        NSInteger swap = random() % (count - i) + i;
        [asd exchangeObjectAtIndex:swap withObjectAtIndex:i];
    }
    self.words =asd;
}

@end
