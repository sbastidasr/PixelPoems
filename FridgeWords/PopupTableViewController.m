//
//  WordPackListTableViewController.m
//  PixelPoems
//
//  Created by Sebastian Bastidas on 7/8/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "PopupTableViewController.h"

#import "SavedGamesTableViewController.h"
#import "PlistLoader.h"
#import "GameViewController.h"
#import "WordPackWrapper.h"

@interface PopupTableViewController ()
@property (nonatomic, strong) NSMutableArray* menuItems;
@end

@implementation PopupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setColorsAndFonts];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    switch (self.typeOfController) {
    case 0:
            self.navigationItem.title=@"Customize";
            self.menuItems=@[@"Word Color",@"Word Border",@"Word Background", @"Background"];
        break;
    case 1:
            self.navigationItem.title=@"WordPacks";
            self.menuItems= [[PlistLoader loadWordPacks]mutableCopy];
        break;
        
    case 2:
            self.navigationItem.title=@"Share";
            self.menuItems=@[@"Twitter",@"Facebook",@"9Gag",@"Save to Photos"];
        break;
    default:
        break;
    }
    

}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    switch (self.typeOfController) {
        case 1:/*WordPacks*/{
            WordPackWrapper *wordPack = self.menuItems[indexPath.row];
            cell.textLabel.text = wordPack.packName;
        }
            break;
        default:
            cell.textLabel.text = self.menuItems[indexPath.row];
            break;
    }
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *selectedCell= [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableDictionary *argsDict = [[NSMutableDictionary alloc]init];
    [argsDict setObject:self.navigationItem.title forKey:@"Action"];
    [argsDict setObject:selectedCell.text forKey:@"SelectedCellText"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverAction" object:argsDict];
}




////colors
-(void)setColorsAndFonts{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
 
    self.tableView.backgroundColor=[UIColor colorWithRed:36.0/255.0  green:41.0/255.0 blue:45.0/255.0 alpha:1.0f];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor=[UIColor colorWithRed:36.0/255.0  green:41.0/255.0 blue:45.0/255.0 alpha:1.0f];
    
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:[cell.textLabel.text uppercaseString]];
    [attributedString addAttribute:NSKernAttributeName value:@(6.0) range:NSMakeRange(0, attributedString.length)];
    [cell.textLabel setAttributedText: attributedString];
    
    UIFont *myFont = [ UIFont fontWithName: @"ProximaNova-Bold" size: 18.0 ];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        myFont = [UIFont fontWithName:@"ProximaNova-Bold" size:27];
    }
    cell.textLabel.font  = myFont;
    cell.textLabel.textColor=[UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        return 60;
    }
    return 50;
}



@end
