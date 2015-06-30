//
//  SavedGamesTableViewController.m
//  PixelPoems
//
//  Created by Sebastian Bastidas on 6/30/15.
//  Copyright (c) 2015 sbastidasr. All rights reserved.
//

#import "SavedGamesTableViewController.h"
#import "PlistLoader.h"
#import "GameViewController.h"

@interface SavedGamesTableViewController ()

@property (nonatomic, strong) NSMutableDictionary* savedGamesDictionary;
@end

@implementation SavedGamesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.savedGamesDictionary= [[PlistLoader loadSavedGameDictionaryFromPList]mutableCopy];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self.savedGamesDictionary allKeys]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.savedGamesDictionary allKeys][indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GameViewController *viewController = (GameViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
    
    NSString *key = [self.savedGamesDictionary allKeys][indexPath.row];
    NSMutableArray *wordArray = (NSMutableArray *)self.savedGamesDictionary[key];
    viewController.wordLabels = wordArray;
    [self.navigationController pushViewController:viewController animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
