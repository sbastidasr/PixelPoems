//
//  ViewController.m
//  FridgeWords
//
//  Created by Sebastian Bastidas on 2/5/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "GameViewController.h"
#import "WordLabel.h"
#import "GameView.h"
#import <Parse/Parse.h>

@interface GameViewController ()
@property (strong, nonatomic) IBOutlet UIView *movableLabel;
@property(strong,nonatomic) UIScrollView *gameView;
@end

@implementation GameViewController



static float const borderWidth = 2.0;
static float const fontSize = 18.0;
const CGSize CGRectOne = {.width = 2000.0, .height = 2000.0};


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

-(void)createGameView{
    //Setup scrollable view for words.
    self.gameView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.gameView];
    [self.gameView setContentSize:CGRectOne];
    self.gameView.backgroundColor=[UIColor blackColor];
    

    self.gameView.contentOffset= CGPointMake(self.gameView.frame.size.width/2, self.gameView.frame.size.height/2);
    
    [self.view addSubview:self.gameView];
   }

- (void)viewDidLoad{
    [super viewDidLoad];
    [self createGameView];
    [self setupLabels:self.level.currentWordPack.words isWOD:NO]; //for WordPack


    
    PFQuery *query = [PFQuery queryWithClassName:@"WordsOfTheDay"];
   // [query whereKey:@"playerEmail" equalTo:@"dstemkoski@example.com"];
    [query orderByDescending:@"createdAt"];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
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
    for (int i=0; i< wordArray.count; i++)
    {
        
        //inits label
        WordLabel *label = [[WordLabel alloc] init];
        label.isWordOfTheDay=areWordsOfTheDay;
        label.userInteractionEnabled = YES;  //enable user interaction
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)] ;
        [label addGestureRecognizer:gesture];
        
        //Set label text
        NSString *labelText = wordArray[i];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString: [labelText uppercaseString]];
        [attributedString addAttribute:NSKernAttributeName value:@(6.0) range:NSMakeRange(0, attributedString.length)];
        [label setAttributedText:attributedString];
        
        //SetupLooks
        label.layer.borderWidth = borderWidth;
        label.font = [UIFont fontWithName:@"ProximaNova-Bold" size:fontSize];
        
        //SetupSize
        [label sizeToFit];
        label.frame=CGRectMake(0,0, label.frame.size.width+32, label.frame.size.height+17);
        
        [self.wordLabels addObject:label];//add to arrayforlabels
    }
}

-(void)addLabelsToView{
    int x=40;
    int y=40;
    for (int i=0; i< self.wordLabels.count; i++){
        WordLabel *label = self.wordLabels[i];
        
        if (i>0){
            WordLabel *lastLabel = self.wordLabels[i-1];
            int currentX = x + lastLabel.frame.size.width;
            x= currentX+40;
        }
        if ((x + label.frame.size.width)>CGRectOne.width){
            y+=70;
            x=40;
        }
        [label setFrame:CGRectMake(x,y,label.frame.size.width , label.frame.size.height)];
        
        if (label.isWordOfTheDay){
            label.backgroundColor=[UIColor redColor];
        }
        /*Code to slightly twist words by 1 degree
        int minRange = -1;
        int maxRange = 1;
        #define ARC4RANDOM_MAX 0x100000000
        double val = ((double)arc4random() / ARC4RANDOM_MAX)* (maxRange - minRange) + minRange;
        [label setTransform:CGAffineTransformMakeRotation((M_PI /180)*val)];
         */
        [self.gameView addSubview:label]; // add to view
    }
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
