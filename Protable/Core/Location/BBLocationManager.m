//
//  BALocationManager.m
//  lxLocation
//
//  Created by hou zhenyong on 14-1-11.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "BALocationManager.h"

@implementation BAAddress

- (NSString*)description
{
    NSString* str = [NSString stringWithFormat:@"\n contry = %@ \n state = %@ \n city = %@ \n subLocality = %@ \n addressLines = %@ \n",
                     self.contry, self.state, self.city, self.subLocality, self.addressLines];
    return str;
}

@end


@implementation BALocationManager

- (id)init
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;     // 精度
        _locationManager.distanceFilter = 1000.f;   // 距离过滤器，设备移动更新位置信息的最小距离，它的单位是米
        _locationManager.pausesLocationUpdatesAutomatically = YES;
        _locationManager.delegate = self;
    }
    return self;
}

- (void)startLocate
{
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
    else {
        NSLog(@"Location services are not enabled");
    }
}

- (void)stopLocate
{
    [self.locationManager stopUpdatingLocation];
}

- (void)reverseLocation:(CLLocation*)location
              successed:(void (^)(BAAddress* address))successedBlock
                 failed:(void(^)(NSError* error))failedBlock
{
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        BAAddress* address = nil;
        if (nil == error && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@", placemark.addressDictionary);
            address = [[BAAddress alloc] init];
            address.contry = placemark.addressDictionary[@"Country"];
            address.state = placemark.addressDictionary[@"State"];
            address.city = placemark.addressDictionary[@"City"];
            address.subLocality = placemark.addressDictionary[@"SubLocality"];
            address.addressLines = placemark.addressDictionary[@"FormattedAddressLines"];
            
            successedBlock(address);
            
        } else if (nil == error && [placemarks count] == 0) {
            NSLog(@"No results were returned.");
            failedBlock(nil);
        } else{
            NSLog(@"An error occurred = %@", error);
            failedBlock(error);
        }
    }];
}

#pragma mark- CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations objectAtIndex:[locations count] - 1];
    [self.delegate locationManager:self didUpdateLocation:location];
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSString* subtitle = [NSString stringWithFormat:@"latitude=%f, longitude=%f", coordinate.latitude, coordinate.longitude];
    NSLog(@"%@", subtitle);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}


@end
