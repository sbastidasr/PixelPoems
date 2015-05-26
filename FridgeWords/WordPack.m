//
//  WordPack.m
//  FridgeWords
//
//  Created by Sebastian Bastidas on 3/23/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "WordPack.h"

@implementation WordPack

+ (NSArray *)loadWordPacks{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"wordPacks" withExtension:@"json"];
    
   /* make it async
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int i =0;
    });*/
    
    // Create a NSURLRequest with the given URL
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
    
    // Get the data
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    // Now create a NSDictionary from the JSON data
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // Create a new array to hold the locations
    NSMutableArray *wordPacks = [[NSMutableArray alloc] init];
    
    // Get an array of dictionaries with the key "locations"
    NSArray *array = [jsonDictionary objectForKey:@"packs"];
    
    
    // Iterate through the array of dictionaries
    for(NSDictionary *dict in array) {
        // Create a new Location object for each one and initialise it with information in the dictionary
        WordPack *wordPack = [[WordPack alloc] initWithJSONDictionary:dict];
        // Add the Location object to the array
        [wordPacks addObject:wordPack];
    }
    
    // Return the array of Location objects
    return wordPacks;
}



// Init the object with information from a dictionary
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    if(self = [self init]) {
        // Assign all properties with keyed values from the dictionary
        _packName = [jsonDictionary objectForKey:@"packName"];
        _words = [jsonDictionary objectForKey:@"words"];
       
    }
    return self;
}



//  NSString *myString = @"Now the night is coming to an end The sun will rise and we will try again stay alive, stay alive for me You will die but now your life is free Take pride in what is sure to die I will fear the night again I hope I'm not my only friend Stay alive stay alive for me You will die but now your life is free Take pride in what is sure to die";


@end
