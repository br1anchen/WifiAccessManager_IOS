//
//  WifiAccessManagerMasterViewController.m
//  WifiAccessManager
//
//  Created by Brian Chen on 10/18/13.
//  Copyright (c) 2013 Brian Chen. All rights reserved.
//

#import "WifiAccessManagerMasterViewController.h"
#import "HttpRequestUtilities.h"
#import "TLSwipeForOptionsCell.h"

#import "WifiAccessManagerDetailViewController.h"

@interface WifiAccessManagerMasterViewController () <TLSwipeForOptionsCellDelegate>{
    NSMutableArray *_objects;
    
    // A dictionary object
    NSDictionary *DeviceDictionary;
    // Define keys
    NSString *deviceName;
    NSString *deviceMac;
    NSString *deviceAccess;
}
@end

@implementation WifiAccessManagerMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(LogoutUser:)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    deviceName = @"request Name";
    deviceMac = @"request Mac";
    deviceAccess = @"request Result";
    _objects = [[NSMutableArray alloc] init];
    
    [self loadTableData];
    
    NSTimer *updateTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadTableData) userInfo:nil repeats:YES];
    [updateTimer fire];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TLSwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification object:self.tableView];
}

- (void)loadTableData
{
    NSLog(@"load data");
    
    [_objects removeAllObjects];
    
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userPrefs stringForKey:@"Email"];
    
    HttpRequestUtilities *httpHelper = [[HttpRequestUtilities alloc] init];
    NSData *deviceSources = [httpHelper getRequestDevices:userId];
    
    if(deviceSources != NULL){
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:
                          deviceSources options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *dataDict in jsonObjects) {
            NSDictionary *client_data = [dataDict objectForKey:@"client"];
            
            NSDictionary *clientInfo_data = [client_data objectForKey:@"client_info"];
            NSDictionary *permissionsDic = [client_data objectForKey:@"permissions"];
            
            NSString *deviceName_data = [clientInfo_data objectForKey:@"name"];
            NSString *deviceMac_data = [clientInfo_data objectForKey:@"mac"];
            
            NSString *deviceRequestResult_data;
            
            if(permissionsDic != NULL)
            {
                NSDictionary *deviceAccess_data = [permissionsDic objectForKey:@"access"];
                deviceRequestResult_data = [[deviceAccess_data objectForKey:@"allow"] boolValue] ? @"YES": @"NO";
            }else
            {
                deviceRequestResult_data = @"NULL";
            }

            
//            NSLog(@"DEVICENAME: %@",deviceName_data);
//            NSLog(@"DEVICEMAC: %@",deviceMac_data);
//            NSLog(deviceAccess_data ? @"Yes" : @"No");
            
            DeviceDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                deviceName_data, deviceName,
                                deviceMac_data, deviceMac,
                                deviceRequestResult_data,deviceAccess,
                                nil];
            [_objects addObject:DeviceDictionary];
        }
        
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LogoutUser:(id)sender
{
    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
    [userPref removeObjectForKey:@"Email"];
    [userPref synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TLSwipeForOptionsCell *cell = [[TLSwipeForOptionsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Device"];
    
    NSDictionary *tmpDict = [_objects objectAtIndex:indexPath.row];
    
    NSMutableString *text;
    text = [NSMutableString stringWithFormat:@"%@  MAC: %@",
            [tmpDict objectForKeyedSubscript:deviceName],[tmpDict objectForKey:deviceMac]];
    
    cell.textLabel.text = text;
    
    if([[tmpDict objectForKey:deviceAccess] isEqualToString:@"YES"]){
        cell.textLabel.textColor = [UIColor greenColor];
    }else if([[tmpDict objectForKey:deviceAccess] isEqualToString:@"NO"]){
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.delegate = self;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *selectedDict = [_objects objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:selectedDict];
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    [self.delegate tableViewController:self didChangeEditing:editing];
}

#pragma UIScrollViewDelegate Methods

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:TLSwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification object:scrollView];
}

#pragma mark - TLSwipeForOptionsCellDelegate Methods

-(void)cellDidSelectApprove:(TLSwipeForOptionsCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSDictionary *selectedDict = [_objects objectAtIndex:indexPath.row];
    
    NSMutableString *clientName;
    clientName = [NSMutableString stringWithFormat:@"%@",
            [selectedDict objectForKeyedSubscript:deviceName]];
    
    NSMutableString *clientMac;
    clientMac = [NSMutableString stringWithFormat:@"%@",
              [selectedDict objectForKey:deviceMac]];

    NSLog(@"%@",[NSString stringWithFormat:@"Approved: %@:%@",clientName,clientMac]);
    
    HttpRequestUtilities *httpHelper = [[HttpRequestUtilities alloc] init];
    if([httpHelper postClientAccess:clientName withMac:clientMac andStatus:true]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Approve Success"
                                                                 delegate:nil
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Approve Failed"
                                                                 delegate:nil
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }
    
    [self loadTableData];
}

-(void)cellDidSelectBlock:(TLSwipeForOptionsCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSDictionary *selectedDict = [_objects objectAtIndex:indexPath.row];
    
    NSMutableString *clientName;
    clientName = [NSMutableString stringWithFormat:@"%@",
                  [selectedDict objectForKeyedSubscript:deviceName]];
    
    NSMutableString *clientMac;
    clientMac = [NSMutableString stringWithFormat:@"%@",
                 [selectedDict objectForKey:deviceMac]];
    
    NSLog(@"%@",[NSString stringWithFormat:@"Blocked: %@:%@",clientName,clientMac]);
    
    HttpRequestUtilities *httpHelper = [[HttpRequestUtilities alloc] init];
    if([httpHelper postClientAccess:clientName withMac:clientMac andStatus:false]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Block Success"
                                                                 delegate:nil
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Block Failed"
                                                                 delegate:nil
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }
    
    [self loadTableData];
}

@end
