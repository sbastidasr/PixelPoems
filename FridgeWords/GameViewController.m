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

@interface GameViewController ()
@property (strong, nonatomic) IBOutlet UIView *movableLabel;
@property(strong,nonatomic) UIScrollView *gameView;
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
    
    
    self.gameView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
 //   [self.view addSubview:self.gameView];
    [self.gameView setContentSize:sizeOfScrollableArea];
   // self.gameView.backgroundColor=[UIColor blackColor];
    self.gameView.backgroundColor=[UIColor colorWithRed:36.0/255 green:41.0/255 blue:45.0/255.0 alpha:1];
    
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
    [self.gameView setNeedsDisplay];
 //   [self.view addSubview:self.gameView];
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
    //[self addCutView];
    
    [self setupLabels:self.level.currentWordPack.words isWOD:NO]; //for WordPack
    [self addLabelsToView];
    [self loadWoD];

 
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
        NSString *labelText = wordArray[i];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString: [labelText uppercaseString]];
        [attributedString addAttribute:NSKernAttributeName value:@(6.0) range:NSMakeRange(0, attributedString.length)];
        label[@"attributedText"]=attributedString;
        [self.wordLabels addObject:label];//add to arrayforlabels
    }
}

-(void)addLabelsToView{
    for (int i=0; i< self.wordLabels.count; i++){
        WordLabel *label = [[WordLabel alloc]init];
        NSMutableDictionary *wordDict=self.wordLabels[i];
        [label setAttributedText:wordDict[@"attributedText"]];
        label.data=wordDict;
        
        //PLACE ON LABEL
        label.userInteractionEnabled = YES;
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] ;
        [label addGestureRecognizer:gesture];
        
        //SetupLooks
        label.layer.borderWidth = borderWidth;
        label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize];
        label.layer.borderColor = [UIColor whiteColor].CGColor;
        label.backgroundColor = nil;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        if([wordDict objectForKey:@"sizeX"]==nil){
            //SetupSize
            [label sizeToFit];
            wordDict[@"sizeX"]=[NSNumber numberWithFloat:label.frame.size.width+32];
            wordDict[@"sizeY"]=[NSNumber numberWithFloat:label.frame.size.height+17];
        }
        
        if(wordDict[@"X"]==nil){
        float minRange=0;
        float maxRangeX=sizeOfScrollableArea.width -200; //200 should instead be maxwordView
        float maxRangeY=sizeOfScrollableArea.height-60;
        double valX = ((double)arc4random() / ARC4RANDOM_MAX) * (maxRangeX - minRange) + minRange ;
        double valY = ((double)arc4random() / ARC4RANDOM_MAX) * (maxRangeY - minRange) + minRange ;
        wordDict[@"X"]=[NSNumber numberWithFloat:valX];
        wordDict[@"Y"]=[NSNumber numberWithFloat:valY];
        }
        
       label.frame=CGRectMake([wordDict[@"X"] floatValue],[wordDict[@"Y"] floatValue], [wordDict[@"sizeX"] floatValue], [wordDict[@"sizeY"] floatValue]);
        
        if ([wordDict[@"isWordOfTheDay"] isEqual:@YES]){
            label.backgroundColor=[UIColor redColor];
        }
        
        /*
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
    self.gameView.zoomScale=0.9;
}

-(NSMutableArray *)wordLabels{
    if(_wordLabels==nil){
        _wordLabels = [[NSMutableArray alloc]init];
    }
    return _wordLabels;
}

//CREATE PARSE OBJECT
// PFObject *testObject = [PFObject objectWithClassName:@"WordsOfTheDay"];
// testObject[@"words"] = @"hvgjhv.kbar";
// [testObject saveInBackground];

@end
