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
#import "WordPackWrapper.h"
#import <WYPopoverController.h>
#import "PopupTableViewController.h"
#import "QuartzCore/QuartzCore.h"

//self.WordLabels  contains array of words. Everything can be recreated from it. with addlabels to view
@interface GameViewController () <WYPopoverControllerDelegate>{
    WYPopoverController *popoverController;
}
@property(nonatomic,strong) IBOutletCollection(UIView) NSArray *headerItems;
@property (weak, nonatomic) IBOutlet UILabel *wordPackLabel;
@property (weak, nonatomic) IBOutlet UIImageView *WODbadge;
@property (weak, nonatomic) IBOutlet UIScrollView *gameView;
- (IBAction)showPopover:(id)sender;
@end

@implementation GameViewController
#define ZOOM_VIEW_TAG 100
#define ARC4RANDOM_MAX 0x100000000
static float const borderWidth = 2.0;
static float const fontSize = 18.0;
const CGSize sizeOfScrollableArea = {.width = 3000.0, .height = 3000.0};

-(void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer{
    gestureRecognizer.view.center =[gestureRecognizer locationInView:gestureRecognizer.view.superview];
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateFailed || gestureRecognizer.state == UIGestureRecognizerStateCancelled){
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
    self.gameView.backgroundColor=self.WODbadge.backgroundColor;
    
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
    if(_wordLabels==nil){
        _wordLabels = [[NSMutableArray alloc]init];
        WordPackWrapper *wp =[PlistLoader defaultWordPack];///HERE CHANGE FOR OTHER WORDPACKS
        [wp  shuffleWordPack];
        [self setupLabels:[wp getNumberOfWordsFromWordPack:100] isWOD:NO]; //restricted words to 100, check playability
        [self loadWoD];
        [self addLabelsToView];
    }
    //If coming from savegames.
    else{
    [self removeLabelsFromView];
    [self addLabelsToView];
    }
    //listen to popover notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"PopOverAction"
                                               object:nil];
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
                float maxRangeY=minRangeY+screenRect.size.height-self.WODbadge.frame.size.height -60;
                
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

//THIS HANDLES POPOVER CONTROLLER
- (IBAction)showPopover:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PopupTableViewController *listViewController = (PopupTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PopupTVC"];
    listViewController.preferredContentSize = CGSizeMake(320, 280);
    UIView *btn = (UIView *)sender;

    listViewController.typeOfController=btn.tag;
    
    [listViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
    
    listViewController.modalInPopover = NO;
    
    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:listViewController];

    popoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
    popoverController.delegate = self;
    popoverController.passthroughViews = @[btn];
    popoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    popoverController.wantsDefaultContentAppearance = NO;
    
    WYPopoverBackgroundView *appearance = [WYPopoverBackgroundView appearance];
    [appearance setBackgroundColor:[UIColor orangeColor]];
    
        [popoverController presentPopoverAsDialogAnimated:YES
                                                          options:WYPopoverAnimationOptionFadeWithScale];
 

}


- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller{
    popoverController.delegate = nil;
    popoverController = nil;
}

- (void)close:(id)sender{
    [popoverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:popoverController];
    }];
}

//recevie notifications
- (void) receiveTestNotification:(NSNotification *) notification{
    [self close:nil];
    
    if ([[notification name] isEqualToString:@"PopOverAction"]){
        NSMutableDictionary *argsDict = [notification object];
        NSString *action = [argsDict objectForKey:@"Action"];

        NSLog (@"Action: %@ Cellname: %@", argsDict[@"Action"], argsDict[@"SelectedCellText"]);
        
        if([action isEqualToString:@"WordPacks"]){
            [self changeToWordPackNamed:argsDict[@"SelectedCellText"]];
        }
    }
}

//POPOVER ACTIONS
-(void)changeToWordPackNamed:(NSString *)name{

    [self removeLabelsFromView];
    NSMutableArray *wodArray=[[NSMutableArray alloc]
                              init];
    
    for (int i=0; i< self.wordLabels.count; i++){
            NSMutableDictionary *wordDict=self.wordLabels[i];
            
            if ([wordDict[@"isWordOfTheDay"] isEqual:@NO]){
                [self.wordLabels removeObjectAtIndex:i];
            }
            else{
                [wodArray addObject:wordDict];
                //    wordDict[@"inView"]=[NSNumber numberWithBool:NO];
            }
        }
    self.wordLabels = wodArray;
//    self.wordLabels = [[NSMutableArray alloc]init];
        
        WordPackWrapper *wp =[PlistLoader WordPackNamed:name];///HERE CHANGE FOR OTHER WORDPACKS
        [wp  shuffleWordPack];
        [self setupLabels:[wp getNumberOfWordsFromWordPack:100] isWOD:NO]; //restricted words to 100, check playability
    [self addLabelsToView];
    
    
    self.wordPackLabel.text=[NSString stringWithFormat:@"WordPack: %@", wp.packName];
}

-(IBAction)share:(id)sender{
/*
    for (int i =0; i<self.headerItems.count; i++){
        UIView *headerView=self.headerItems[i];
        headerView.alpha =0.0f;
    }
    self.wordPackLabel.alpha=0.0f;
  */
    CGSize gameViewSize=self.gameView.frame.size;
    //CGRect frame = [firstView convertRect:buttons.frame fromView:secondView];
    
    gameViewSize.height+=self.gameView.frame.origin.y;

    UIGraphicsBeginImageContext(gameViewSize);
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
 
    screenshot =  [self croppIngimageByImageName:screenshot toRect:CGRectMake(0, self.gameView.frame.origin.y, screenshot.size.width, screenshot.size.height-self.gameView.frame.origin.y)];
    
    // The result is *screenshot
    
    NSString *text = @"Check out the poem I made with PixelPoems app";
   // NSURL *url = [NSURL URLWithString:@"http://roadfiresoftware.com/2014/02/how-to-add-facebook-and-twitter-sharing-to-an-ios-app/"];
    UIImage *image =screenshot;
    //[UIImage imageNamed:@"Gallery"];
    
    UIActivityViewController *controller =
    [[UIActivityViewController alloc]
     initWithActivityItems:@[text, /*url,*/ image]
     applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
}

-(UIImage *)imageCrop:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGContextClipToRect( currentContext, clippedRect);
    
    CGRect drawRect = CGRectMake(rect.origin.x, rect.origin.y, imageToCrop.size.width, imageToCrop.size.height);
    CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cropped;
}

- (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    //CGRect CropRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+15);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

@end