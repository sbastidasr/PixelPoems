//
//  RemoveAdsViewController.m
//  PixelPoems
//
//  Created by Sebastian Bastidas on 7/20/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "RemoveAdsViewController.h"
#import <StoreKit/StoreKit.h>

//put the name of your view controller in place of MyViewController
@interface RemoveAdsViewController() <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation RemoveAdsViewController //the name of your view controller (same as above)

-(NSString *)productIdentifier{
    if([self.purchaseType isEqualToString:@"LOVE"]){
        return @"com.sbastidasr.PixelPoems.LoveWordPack";
    }
    if([self.purchaseType isEqualToString:@"asd"]){
        return @"com.sbastidasr.PixelPoems.asd";
    } else {
        return @"com.sbastidasr.PixelPoems.removeads";
    }
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}


- (IBAction)tapsRemoveAds{
    NSLog(@"User requests to remove ads");
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject: [self productIdentifier] ]];
        productsRequest.delegate = self;
        [productsRequest start];
        
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (IBAction)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction) restore{
    //this is called when the user restores purchases, you should hook this up to a button
    
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        // if(transaction.transactionState == SKPaymentTransactionStateRestored){
        //called when the user successfully restores a purchase
        NSLog(@"Transaction state -> Restored");
        [self doStuffWithProductId:transaction.payment.productIdentifier];            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        //  break;
        //}
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doStuffWithProductId:transaction.payment.productIdentifier]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

//Call this method if in app puchase is made ====> [self doRemoveAds];
- (void)doStuffWithProductId:(NSString *)id{
    
    if( [self.purchaseType isEqualToString:@""]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"areAdsRemoved"];
    }
    else {
         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[self.purchaseType uppercaseString]];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Received Id: %@", id);
    
    self 
}
@end
         
         
