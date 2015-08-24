//
//  ReusableFunctions.m
//  PixelPoems
//
//  Created by Sebastian Bastidas on 8/19/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "ReusableFunctions.h"

@implementation ReusableFunctions



+(NSData *)dataFromColor:(UIColor *)color{
    return [NSKeyedArchiver archivedDataWithRootObject:color];
}

+(UIColor *)colorFromData:(NSData *)data{
    UIColor *theColor=nil;
    if (data != nil){
        theColor =(UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return theColor;
}






@end
