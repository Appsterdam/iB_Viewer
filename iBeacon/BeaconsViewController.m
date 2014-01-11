//
//  BeaconsViewController.m
//  iBeacon
//
//  Created by Marc van de Langenberg on 11-01-14.
//  Copyright (c) 2014 Appsterdam. All rights reserved.
//

#import "BeaconsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BeaconInfoCell.h"

#define BeaconProximityUUID @"74278bda-b644-4520-8f0c-720eaf059935"
#define BeaconRegionIdentifier @"glmaxi"

@interface BeaconsViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSArray *inRangeBeacons; // of CLBeacon
@property (strong, nonatomic) CLBeaconRegion *inRangeBeaconRegion;

@end

@implementation BeaconsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"iBeacon Appsterdam";
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSString *proximityUUIDString = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProximityUUID_preference"];
    if (!proximityUUIDString){
        proximityUUIDString = BeaconProximityUUID;
    }
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:proximityUUIDString];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    NSString *beaconRegionIdentifierString = [[NSUserDefaults standardUserDefaults] objectForKey:@"RegionIdentifier_preference"];
    if (!beaconRegionIdentifierString){
        beaconRegionIdentifierString = BeaconRegionIdentifier;
    }
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:beaconRegionIdentifierString];
    
    /*
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    */
    
    // Tell location manager to start monitoring for the beacon region
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
    //self.statusLabel.text = @"Monitoring...";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.inRangeBeacons count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BeaconInfoCellIdentifier = @"BeaconInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BeaconInfoCellIdentifier forIndexPath:indexPath];
    
    [cell setUserInteractionEnabled:NO];
    
    if ([cell isKindOfClass:[BeaconInfoCell class]]){
        BeaconInfoCell *beaconInfoCell = (BeaconInfoCell *)cell;
        
        CLBeacon *beacon = self.inRangeBeacons[indexPath.row];
        [beaconInfoCell setBeacon:beacon beaconRegion:self.inRangeBeaconRegion];
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - LocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"LocationManager didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSString *stateStr = @"RegionStateUnknown";
    if (state == CLRegionStateInside)
        stateStr = @"RegionStateInside";
    else if (state == CLRegionStateOutside)
        stateStr = @"RegionStateOutside";
    
    NSLog(@"%s, State: %@, Region: %@", __PRETTY_FUNCTION__, stateStr, region.identifier);
}

-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
{
    self.inRangeBeacons = beacons;
    self.inRangeBeaconRegion = region;
    
    [self.tableView reloadData];
}


@end
