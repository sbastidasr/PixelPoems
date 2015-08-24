//
//  RemoveAdsViewController.h
//  PixelPoems
//
//  Created by Sebastian Bastidas on 7/20/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
//#import "GADBannerView.h"

@interface RemoveAdsViewController : UIViewController

@property (nonatomic,strong) NSString *purchaseType;





- (IBAction)restore;
- (IBAction)tapsRemoveAds;

@end
