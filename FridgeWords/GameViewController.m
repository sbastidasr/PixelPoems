//
//  ViewController.m
//  FridgeWords
//
//  Created by Sebastian Bastidas on 2/5/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "GameViewController.h"
#import "WordLabel.h"
#import "CutGameView.h"
#import <Parse/Parse.h>
#import "PlistLoader.h"


//self.WordLabels  contains array of 
@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *gameView;

@end

@implementation GameViewController

#define ZOOM_VIEW_TAG 100

#define ARC4RANDOM_MAX 0x100000000
static float const borderWidth = 2.0;
static float const fontSize = 18.0;
const CGSize sizeOfScrollableArea = {.width = 3000.0, .height = 3000.0};


//allocs the level, that has the wordpack.
-(Level *)level{
    if(!_level){
        _level=[[Level alloc]init];
    }
    return _level;
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer{
    gestureRecognizer.view.center =[gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateFailed || gestureRecognizer.state == UIGestureRecognizerStateCancelled)
    {
        [self updateWordPositionsOnDict];   //saves the position of current word on Each label's word Dict
    }
}

- (void)drawRect:(CGRect)rect{
    CGRect rectangle = CGRectMake(0, 0, 100, 100);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.0);   //this is the transparent color
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.5);
    CGContextStrokeRect(context, rectangle);    //this will draw the border
    
}

-(void)createGameView{
    //Setup scrollable view for words.
    [self.gameView setContentSize:sizeOfScrollableArea];
    self.gameView.backgroundColor=self.headerView.backgroundColor;
    
    //center the game view
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float viewStartPointX = (sizeOfScrollableArea.width-screenRect.size.width)/2;
    float viewStartPointY = (sizeOfScrollableArea.height-screenRect.size.height)/2;
    self.gameView.contentOffset= CGPointMake(viewStartPointX, viewStartPointY);
    self.gameView.delegate=self;
    self.gameView.minimumZoomScale=0.5;
    self.gameView.maximumZoomScale=2;
 
    UIView *contentView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, sizeOfScrollableArea.width, sizeOfScrollableArea.height)];
    [self.gameView addSubview:contentView];
    [contentView setTag:ZOOM_VIEW_TAG];
    [self.view addSubview:self.gameView];
    [self.gameView setNeedsDisplay];
    
   // self.gameView.backgroundColor=[UIColor redColor];
   }

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [self.gameView viewWithTag:ZOOM_VIEW_TAG];
}

-(void)addCutView{
    CutGameView *cutView=[[CutGameView alloc]initWithFrame:self.gameView.frame];
    [self.view addSubview:cutView];
    cutView.opaque=NO;
    cutView.backgroundColor=[UIColor clearColor];
    cutView.userInteractionEnabled=NO;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self createGameView];
    
    
    //If coming from Words of the day:
   //[self setupLabels:self.level.currentWordPack.words isWOD:NO]; //for WordPack
//[self loadWoD];
    
    //If coming from savegames.
 
    
    //add
    [self removeLabelsFromView];
    [self addLabelsToView];
    }

-(void)loadWoD{
    PFQuery *query = [PFQuery queryWithClassName:@"WordsOfTheDay"];
    [query orderByDescending:@"createdAt"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
           //LOAD SOME RANDOM WORDS
        } else {
            NSString *wordsOfTheDay=object[@"words"];
            NSArray *stringArray = [wordsOfTheDay componentsSeparatedByString: @" "];
            [self setupLabels:stringArray isWOD:YES];
            [self addLabelsToView];
        }
        
    }];
}

-(void)setupLabels:(NSArray *)wordArray isWOD:(BOOL)areWordsOfTheDay{
    //Iterate through labels.
    for (int i=0; i< wordArray.count; i++){
        //inits label
        NSMutableDictionary *label = [[NSMutableDictionary alloc] init];
        label[@"isWordOfTheDay"]=[NSNumber numberWithBool:areWordsOfTheDay];

        //Set label text
        label[@"attributedText"] = wordArray[i];
       [self.wordLabels addObject:label];//add to arrayforlabels
    }
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
        label.backgroundColor = nil;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor=self.gameView.backgroundColor;

        
        if([wordDict objectForKey:@"sizeX"]==nil){
            //SetupSize
            [label sizeToFit];
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                wordDict[@"sizeX"]=[NSNumber numberWithFloat:label.frame.size.width+(32*1.5)];
                wordDict[@"sizeY"]=[NSNumber numberWithFloat:label.frame.size.height+(17*1.5)];
            }
            else{
                wordDict[@"sizeX"]=[NSNumber numberWithFloat:label.frame.size.width+32];
                wordDict[@"sizeY"]=[NSNumber numberWithFloat:label.frame.size.height+17];
            }
        }
        /*if(wordDict[@"X"]==nil){//if it has no place in map, yet.
         
         float minRange=0;
         float maxRangeX=sizeOfScrollableArea.width -200; //should instead be maxwordView
         float maxRangeY=sizeOfScrollableArea.height-60;
         double valX = ((double)arc4random() / ARC4RANDOM_MAX) * (maxRangeX - minRange) + minRange ;
         double valY = ((double)arc4random() / ARC4RANDOM_MAX) * (maxRangeY - minRange) + minRange ;
         wordDict[@"X"]=[NSNumber numberWithFloat:valX];
         wordDict[@"Y"]=[NSNumber numberWithFloat:valY];
         }
         */
        
        if ([wordDict[@"isWordOfTheDay"] isEqual:@YES]){
            label.backgroundColor=[UIColor redColor];
        }
        
        if(wordDict[@"X"]==nil){//if it has no place in map, yet.
            if ([wordDict[@"isWordOfTheDay"] isEqual:@YES]){
                
                CGRect screenRect = [[UIScreen mainScreen] bounds];

                float minRangeX = (sizeOfScrollableArea.width-screenRect.size.width)/2;
                float minRangeY = (sizeOfScrollableArea.height-screenRect.size.height)/2;
                
                float maxRangeX=minRangeX+screenRect.size.width-100; //should instead be maxwordView
                float maxRangeY=minRangeY+screenRect.size.height-self.headerView.frame.size.height -60;
                
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
        
        /* s;
        //Code to slightly twist words by 1 degree
        int minRange = -1;
        int maxRange = 1;
        #define ARC4RANDOM_MAX 0x100000000
        double val = ((double)arc4random() / ARC4RANDOM_MAX)* (maxRange - minRange) + minRange;
        [label setTransform:CGAffineTransformMakeRotation((M_PI /180)*val)];
        */
        
        if ([[wordDict objectForKey:@"inView"] boolValue]==NO){
            [[self.gameView viewWithTag:ZOOM_VIEW_TAG] addSubview:label]; // add to view
            wordDict[@"inView"]=[NSNumber numberWithBool:YES];
        }
    }
}


-(void)removeLabelsFromView{
    [[[self.gameView viewWithTag:ZOOM_VIEW_TAG] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];  //Clears words
    for (int i=0; i< self.wordLabels.count; i++){
        NSMutableDictionary *wordDict=self.wordLabels[i];
        wordDict[@"inView"]=[NSNumber numberWithBool:NO];
    }
}

-(void)updateWordPositionsOnDict{

    NSArray *labels = [[self.gameView viewWithTag:ZOOM_VIEW_TAG] subviews];
    
  for (int i=0; i< labels.count; i++){
      WordLabel *label=labels[i];
      NSMutableDictionary *wordDict = label.wordDictionary;
      
      wordDict[@"X"]=[NSNumber numberWithFloat:label.frame.origin.x];
      wordDict[@"Y"]=[NSNumber numberWithFloat:label.frame.origin.y];
  
  }

}



- (IBAction)HomeButton:(id)sender {
   
    [self showSaveAlert];
    
  //  [self loadGame];
   // [self removeLabelsFromView];
   // [self addLabelsToView]; //recreates labels, from self.wordLabels Array of label Dictinaries.
 
}

-(void)cleanGameView{
    [self removeLabelsFromView]; //removes every label on screen.
    self.wordLabels=nil;
}


- (IBAction)showSaveAlert {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                      message:@"Please enter a title to save your game"
                                                     delegate:self
                                            cancelButtonTitle:@"Don't Save"
                                            otherButtonTitles:@"Save Game", nil];
    
    message.alertViewStyle = UIAlertViewStylePlainTextInput;
    [message show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Save Game"]){
        [PlistLoader saveGameArrayToPlist:self.wordLabels Named:[[alertView textFieldAtIndex:0] text]];
        [self cleanGameView];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    else if([title isEqualToString:@"Don't Save"]){
        [self cleanGameView];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
        if([[[alertView textFieldAtIndex:0] text] length] >= 1 ) {
            return YES;}
        else{return NO;}
    }else{return YES;}
}

-(NSMutableArray *)wordLabels{
    if(_wordLabels==nil){
        _wordLabels = [[NSMutableArray alloc]init];
    }
    return _wordLabels;
}
@end
