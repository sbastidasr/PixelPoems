//
//  gameView.m
//  PixelPoems
//
//  Created by Sebastian Bastidas on 7/17/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "gameView.h"
#import "GameViewController.h"
#import "WordLabel.h"
#import <Parse/Parse.h>
#import "PlistLoader.h"
#import "WordPackWrapper.h"
#import <WYPopoverController.h>
#import "PopupTableViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "gameView.h"
@implementation gameView

static float const borderWidth = 2.0;
static float const fontSize = 18.0;
#define ZOOM_VIEW_TAG 100
#define ARC4RANDOM_MAX 0x100000000
#define ZOOM_VIEW_TAG 100


-(void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer{
    gestureRecognizer.view.center =[gestureRecognizer locationInView:gestureRecognizer.view.superview];
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateFailed || gestureRecognizer.state == UIGestureRecognizerStateCancelled){
        [self updateWordPositionsOnDict];   //saves the position of current word on Each label's word Dict
    }
}

-(void)updateWordPositionsOnDict{
    NSArray *labels = [[self viewWithTag:ZOOM_VIEW_TAG] subviews];
    for (int i=0; i< labels.count; i++){
        WordLabel *label=labels[i];
        NSMutableDictionary *wordDict = label.wordDictionary;
        wordDict[@"X"]=[NSNumber numberWithFloat:label.frame.origin.x];
        wordDict[@"Y"]=[NSNumber numberWithFloat:label.frame.origin.y];
    }
}


-(void)initGameView{
    self.delegate=self;
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [self viewWithTag:ZOOM_VIEW_TAG];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    [self initGameView];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self initGameView];
    return self;
}
-(void)addLabelsToView{
    for (int i=0; i< self.wordLabels.count; i++){
        WordLabel *label = [[WordLabel alloc]init];
        NSMutableDictionary *wordDict=self.wordLabels[i];
        
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString: [wordDict[@"attributedText"] uppercaseString]];
        [attributedString addAttribute:NSKernAttributeName value:@(6.0) range:NSMakeRange(0, attributedString.length)];
        
        [label setAttributedText: attributedString];
        label.wordDictionary=wordDict;
        
        //PLACE ON LABEL
        label.userInteractionEnabled = YES;
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] ;
        [label addGestureRecognizer:gesture];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            label.layer.borderWidth = borderWidth*1.5;
            label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize*1.5];
        }
        else{
            label.layer.borderWidth = borderWidth;
            label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize];
        }
        
        //SetupLooks
        label.layer.borderColor = [UIColor whiteColor].CGColor;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor=[UIColor colorWithRed:35.0/255.0  green:40.0/255.0 blue:44.0/255.0 alpha:1.0f];
        //asd
        
        if([wordDict objectForKey:@"sizeX"]==nil){
            //SetupSize
            [label sizeToFit];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
                wordDict[@"sizeX"]=[NSNumber numberWithFloat:label.frame.size.width+(32*1.5)];
                wordDict[@"sizeY"]=[NSNumber numberWithFloat:label.frame.size.height+(17*1.5)];
            }
            else{
                wordDict[@"sizeX"]=[NSNumber numberWithFloat:label.frame.size.width+32];
                wordDict[@"sizeY"]=[NSNumber numberWithFloat:label.frame.size.height+17];
            }
        }
        if ([wordDict[@"isWordOfTheDay"] isEqual:@YES]){
            // label.backgroundColor=[UIColor redColor];
        }
        
        if(wordDict[@"X"]==nil){//if it has no place in map, yet.
            if ([wordDict[@"isWordOfTheDay"] isEqual:@YES]){
                
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                
                float minRangeX = (sizeOfScrollableArea.width-screenRect.size.width)/2;
                float minRangeY = (sizeOfScrollableArea.height-screenRect.size.height)/2;
                
                float maxRangeX=minRangeX+screenRect.size.width-100; //should instead be maxwordView

#pragma warning the 100 in maxRange calculation should be the headersize.
                float maxRangeY=minRangeY+screenRect.size.height-100 -60;
                
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    //label.transform = CGAffineTransformMakeScale(1.5, 1.5);
                    minRangeX+=100;
                    maxRangeX-=100;
                    minRangeY+=140;
                    maxRangeY-=200;
                }
                double valX = ((double)arc4random() / ARC4RANDOM_MAX) * (maxRangeX - minRangeX) + minRangeX ;
                double valY = ((double)arc4random() / ARC4RANDOM_MAX) * (maxRangeY - minRangeY) + minRangeY;
                wordDict[@"X"]=[NSNumber numberWithFloat:valX];
                wordDict[@"Y"]=[NSNumber numberWithFloat:valY];
            }
            else{
                float minRange=0;
                float maxRangeX=sizeOfScrollableArea.width -200; //should instead be maxwordView
                float maxRangeY=sizeOfScrollableArea.height-60;
                double valX = ((double)arc4random() / ARC4RANDOM_MAX) * (maxRangeX - minRange) + minRange ;
                double valY = ((double)arc4random() / ARC4RANDOM_MAX) * (maxRangeY - minRange) + minRange ;
                wordDict[@"X"]=[NSNumber numberWithFloat:valX];
                wordDict[@"Y"]=[NSNumber numberWithFloat:valY];
            }
        }
        label.frame=CGRectMake([wordDict[@"X"] floatValue],[wordDict[@"Y"] floatValue], [wordDict[@"sizeX"] floatValue], [wordDict[@"sizeY"] floatValue]);
        
        if ([[wordDict objectForKey:@"inView"] boolValue]==NO){
            [[self viewWithTag:ZOOM_VIEW_TAG] addSubview:label]; // add to view
            wordDict[@"inView"]=[NSNumber numberWithBool:YES];
        }
    }
}


-(void)removeLabelsFromView{
    [[[self viewWithTag:ZOOM_VIEW_TAG] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];  //Clears words
    for (int i=0; i< self.wordLabels.count; i++){
        NSMutableDictionary *wordDict=self.wordLabels[i];
        wordDict[@"inView"]=[NSNumber numberWithBool:NO];
    }
}


@end
