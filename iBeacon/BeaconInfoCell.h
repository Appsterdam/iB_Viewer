//
//  BeaconInfoCell.h
//  iBeacon
//
//  Created by Marc van de Langenberg on 11-01-14.
//  Copyright (c) 2014 Appsterdam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BeaconInfoCell : UITableViewCell

- (void)setBeacon:(CLBeacon *)beacon beaconRegion:(CLBeaconRegion *)region;

@end
