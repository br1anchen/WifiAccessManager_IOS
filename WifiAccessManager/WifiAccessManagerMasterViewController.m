//
//  WifiAccessManagerMasterViewController.m
//  WifiAccessManager
//
//  Created by Brian Chen on 10/18/13.
//  Copyright (c) 2013 Brian Chen. All rights reserved.
//

#import "WifiAccessManagerMasterViewController.h"
#import "HttpRequestUtilities.h"

#import "WifiAccessManagerDetailViewController.h"

@interface WifiAccessManagerMasterViewController () {
    NSMutableArray *_objects;
    
    // A dictionary object
    NSDictionary *DeviceDictionary;
    // Define keys
    NSString *deviceName;
    NSString *deviceMac;
    BOOL deviceAccess;
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

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    deviceName = @"request Name";
    deviceMac = @"00:00:00:00:00:00";
    deviceAccess = FALSE;
    _objects = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userPrefs stringForKey:@"Email"];
    
    NSLog(@"%@",userId);
    
    HttpRequestUtilities *httpHelper = [[HttpRequestUtilities alloc] init];
    NSData *deviceSources = [httpHelper getRequestDevices:userId];
    
    if(deviceSources != NULL){
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:
                          deviceSources options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *dataDict in jsonObjects) {
            NSDictionary *client_data = [dataDict objectForKey:@"client"];
            
            NSDictionary *clientInfo_data = [client_data objectForKey:@"client_info"];
            NSDictionary *permissions_data = [client_data objectForKey:@"permissions"];
            
            NSString *deviceName_data = [clientInfo_data objectForKey:@"name"];
            NSString *deviceMac_data = [clientInfo_data objectForKey:@"mac"];
            BOOL deviceAccess_data = (BOOL)[permissions_data objectForKey:@"allow"];
            
            NSLog(@"DEVICENAME: %@",deviceName_data);
            NSLog(@"DEVICEMAC: %@",deviceMac_data);
            NSLog(deviceAccess_data ? @"Yes" : @"No");
            
            DeviceDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                          deviceName_data, deviceName,
                          deviceMac_data, deviceMac,
                          deviceAccess_data,deviceAccess,
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

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    static NSString *CellIdentifier = @"Device";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:
              UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    NSDictionary *tmpDict = [_objects objectAtIndex:indexPath.row];
    
    NSMutableString *text;
    text = [NSMutableString stringWithFormat:@"%@",
            [tmpDict objectForKeyedSubscript:deviceName]];
    
    NSMutableString *detail;
    detail = [NSMutableString stringWithFormat:@"MAC Address: %@ ",
              [tmpDict objectForKey:deviceMac]];
    
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text= detail;
    
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
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
