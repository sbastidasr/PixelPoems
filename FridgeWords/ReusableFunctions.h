//
//  ReusableFunctions.h
//  PixelPoems
//
//  Created by Sebastian Bastidas on 8/19/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ReusableFunctions : NSObject

+(NSData *)dataFromColor:(UIColor *)color;
+(UIColor *)colorFromData:(NSData *)data;
@end
