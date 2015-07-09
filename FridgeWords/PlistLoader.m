//
//  WordPack.m
//  FridgeWords
//
//  Created by Sebastian Bastidas on 3/23/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "PlistLoader.h"


@implementation PlistLoader


+(WordPackWrapper *)WordPackNamed:(NSString *)packName{
    NSArray *wordPacks  =  [ PlistLoader loadWordPacks];
    
    for (WordPackWrapper *wpw in wordPacks) {
        if ([wpw.packName isEqualToString:packName])
            return wpw;
    }
    return nil;
}



+(WordPackWrapper *)defaultWordPack{
    NSArray *wordPacks  =  [ PlistLoader loadWordPacks];
    return [wordPacks firstObject];//HERE CHANGE FOR MORE WORDPACKS
}

+(NSArray *)loadWordPacks{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"wordPacks" withExtension:@"json"];

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
        WordPackWrapper *wordPack = [[WordPackWrapper alloc] initWithJSONDictionary:dict];
        // Add the Location object to the array
        [wordPacks addObject:wordPack];
    }
    
    // Return the array of Location objects
    return wordPacks;
}


#pragma mark - SAVE/LOAD  Games

+(NSString *)getSavedGamesFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:@"savedGames.plist"];
}

//Save Only one game.
+(void)saveGameArrayToPlist:(NSArray *)wordLabels Named:(NSString *)name{ //saves wordlabels to plist
    NSString *savedGamesFilePath = [self getSavedGamesFilePath];
    NSMutableDictionary *savedGameDictionary =  [[self loadSavedGameDictionaryFromPList] mutableCopy];
    if (savedGameDictionary!=nil){
        savedGameDictionary[name]=wordLabels;
    }
    else{
        savedGameDictionary = [[NSMutableDictionary alloc]init];
        savedGameDictionary[name]=wordLabels;
    }
    [savedGameDictionary writeToFile:savedGamesFilePath atomically:YES]; //Write
}

//Load COMPLETE PList
+(NSDictionary *)loadSavedGameDictionaryFromPList{
    NSString *savedGamesFilePath = [self getSavedGamesFilePath];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:savedGamesFilePath];
    if (fileExists){
        return [NSDictionary dictionaryWithContentsOfFile:savedGamesFilePath];
    }
    return nil;
}

//Save COMPLETE PList
+(void)saveSavedGameDictionaryFromPList:(NSMutableDictionary *) savedGameDictionary { //saves wordlabels to plist
    NSString *savedGamesFilePath = [self getSavedGamesFilePath];
    [savedGameDictionary writeToFile:savedGamesFilePath atomically:YES]; //Write
}

@end