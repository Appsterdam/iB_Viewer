//
//  BeaconInfoCell.m
//  iBeacon
//
//  Created by Marc van de Langenberg on 11-01-14.
//  Copyright (c) 2014 Appsterdam. All rights reserved.
//

#import "BeaconInfoCell.h"

@interface BeaconInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;

@end

@implementation BeaconInfoCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBeacon:(CLBeacon *)beacon beaconRegion:(CLBeaconRegion *)region
{
    self.nameLabel.text = region.identifier;
    self.uuidLabel.text = beacon.proximityUUID.UUIDString;
    self.majorLabel.text = [NSString stringWithFormat:@"Major: %@", beacon.major];
    self.minorLabel.text = [NSString stringWithFormat:@"Minor: %@", beacon.minor];
    self.rssiLabel.text = [NSString stringWithFormat:@"%ld dBm", (long)beacon.rssi];
    self.accuracyLabel.text = [NSString stringWithFormat:@"Accuracy: %f meter", beacon.accuracy];
}

@end
