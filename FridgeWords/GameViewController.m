//
//  ViewController.m
//  FridgeWords
//
//  Created by Sebastian Bastidas on 2/5/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "GameViewController.h"
#import "GameView.h"
#import "AdBannerViewController.h"


//self.gameView.wordLabels  contains array of words. Everything can be recreated from it. with addlabels to view
@interface GameViewController () <WYPopoverControllerDelegate>{
    WYPopoverController *popoverController;
}

@property(nonatomic,strong) IBOutletCollection(UIView) NSArray *headerItems;
@property (weak, nonatomic) IBOutlet UILabel *wordPackLabel;
@property (weak, nonatomic) IBOutlet UIImageView *WODbadge;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
///
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AdContainerViewHeight;
///
- (IBAction)showPopover:(id)sender;

@end

@implementation GameViewController

#define ZOOM_VIEW_TAG 100
#define ARC4RANDOM_MAX 0x100000000



-(void)createGameView{
    //Setup scrollable view for words.

    [self.gameView setContentSize:sizeOfScrollableArea];
    self.gameView.backgroundColor=self.WODbadge.backgroundColor;
    
    //center the game view
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float viewStartPointX = (sizeOfScrollableArea.width-screenRect.size.width)/2;
    float viewStartPointY = (sizeOfScrollableArea.height-screenRect.size.height)/2;
    self.gameView.contentOffset= CGPointMake(viewStartPointX, viewStartPointY);

    self.gameView.minimumZoomScale=0.5;
    self.gameView.maximumZoomScale=2;
    
    UIView *contentView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, sizeOfScrollableArea.width, sizeOfScrollableArea.height)];
    [self.gameView addSubview:contentView];
    [contentView setTag:ZOOM_VIEW_TAG];
    [self.view addSubview:self.gameView];
    [self.gameView setNeedsDisplay];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self createGameView];
    [self setUpWords];
    [self hideAdsIfPaid];
   
}

 //Call this method if in app puchase is made ====> [self doRemoveAds];
- (void)doRemoveAds{
    bool areAdsRemoved = NO;
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    //use NSUserDefaults so that you can load wether or not they bought it
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)hideAdsIfPaid{
    bool areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(areAdsRemoved){
            self.AdContainerViewHeight.constant=0;
    }
}

-(void)setUpWords{
    //If coming from Words of the day:
    if(!self.gameView.wordLabels){
        self.gameView.wordLabels = [[NSMutableArray alloc]init];
        WordPackWrapper *wp =[PlistLoader defaultWordPack];///HERE CHANGE FOR OTHER WORDPACKS
        [wp  shuffleWordPack];
        [self setupLabels:[wp getNumberOfWordsFromWordPack:100] isWOD:NO]; //restricted words to 100, check playability
        [self loadWoD];
        [self.gameView addLabelsToView];
    }
    //If coming from savegames.
    else{
        [self.gameView removeLabelsFromView];
        [self.gameView addLabelsToView];
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
            [self.gameView addLabelsToView];
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
       [self.gameView.wordLabels addObject:label];//add to arrayforlabels
        
        
        label[@"Font Color"] = [UIColor whiteColor];
         label[@"Border Color"] = [UIColor whiteColor];
        label[@"Background Color"] = [UIColor colorWithRed:35.0/255.0  green:40.0/255.0 blue:44.0/255.0 alpha:1.0f];
        

    }
}




- (IBAction)HomeButton:(id)sender {
    [self showSaveAlert];
}

-(void)cleanGameView{
    [self.gameView removeLabelsFromView]; //removes every label on screen.
    self.gameView.wordLabels=nil;
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
        [PlistLoader saveGameArrayToPlist:self.gameView.wordLabels Named:[[alertView textFieldAtIndex:0] text]];
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
    listViewController.preferredContentSize = CGSizeMake(320, 350);
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
        
        //When WordPacks are modified
        if([action isEqualToString:@"WordPacks"]){
            [self changeToWordPackNamed:argsDict[@"SelectedCellText"]];
        }
        
        if([action isEqualToString:@"Customize"]){
            NSArray *customizeOpts =@[@"FONT COLOR", @"BORDER COLOR",@"BACKGROUND COLOR", @"GAME BACKGROUND"];
            
            if([customizeOpts containsObject:argsDict[@"SelectedCellText"]])
            {
                 int index = [customizeOpts indexOfObject: argsDict[@"SelectedCellText"]];
                UIColor *color = argsDict[@"Color"];
                switch (index) {
                    case 0:
                        [self.gameView changeFontColorTo:color];
                        break;
                    case 1:
                        [self.gameView changeBorderColorTo:color];
                        break;
                    case 2:
                        [self.gameView changeBackgroundColorTo:color];
                        break;
                    case 3:
                        [self.gameView changeGameBackgroundTo:color];
                        break;
                    default:
                        break;
                }
                
                
            }
            
     
         
        }
    }
    
    
    
    /*
    - (void)setSelectedColor:(UIColor *)color {
        NSMutableDictionary *argsDict = [[NSMutableDictionary alloc]init];
        [argsDict setObject:@"Customize" forKey:@"Action"];
        [argsDict setObject:self.selectedItemToChangeColor forKey:@"SelectedCellText"];
        [argsDict setObject:color forKey:@"Color"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverAction" object:argsDict];
    }
    */
}

//POPOVER ACTIONS
-(void)changeToWordPackNamed:(NSString *)name{

    [self.gameView removeLabelsFromView];

    NSMutableArray *wodArray=[[NSMutableArray alloc]
                              init];
    
    for (int i=0; i< self.gameView.wordLabels.count; i++){
            NSMutableDictionary *wordDict=self.gameView.wordLabels[i];
            
            if ([wordDict[@"isWordOfTheDay"] isEqual:@NO]){
                [self.gameView.wordLabels removeObjectAtIndex:i];
            }
            else{
                [wodArray addObject:wordDict];
                //    wordDict[@"inView"]=[NSNumber numberWithBool:NO];
            }
        }
    self.gameView.wordLabels = wodArray;
//    self.gameView.wordLabels = [[NSMutableArray alloc]init];
        
        WordPackWrapper *wp =[PlistLoader WordPackNamed:name];///HERE CHANGE FOR OTHER WORDPACKS
        [wp  shuffleWordPack];
        [self setupLabels:[wp getNumberOfWordsFromWordPack:100] isWOD:NO]; //restricted words to 100, check playability
    [self.gameView addLabelsToView];
    
    
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