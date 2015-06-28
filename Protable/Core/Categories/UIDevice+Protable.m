//  UIDevice+UIDeviceExt.h
//  Created by hou zhenyong on 13-12-13.

#import "UIDevice+Protable.h"
#include <sys/sysctl.h>
#include <sys/types.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <netdb.h>
#import <AdSupport/AdSupport.h>

@import CoreTelephony;

@implementation UIDevice (Protable)


+ (NSString *)deviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    
    return deviceModel;
}

+ (NSString *)deviceName {
    NSString *deviceModel = [UIDevice deviceModel];
    
    if ([deviceModel isEqualToString:@"i386"])          return @"Simulator";
    if ([deviceModel isEqualToString:@"iPhone1,1"])     return @"iPhone1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])     return @"iPhone3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])     return @"iPhone3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"]
        || [deviceModel isEqualToString:@"iPhone3,2"]
        || [deviceModel isEqualToString:@"iPhone3,3"])  return @"iPhone4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])     return @"iPhone4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"]
        || [deviceModel isEqualToString:@"iPhone5,2"])  return @"iPhone5";
    if ([deviceModel isEqualToString:@"iPhone5,3"]
        || [deviceModel isEqualToString:@"iPhone5,4"])  return @"iPhone5c";
    if ([deviceModel isEqualToString:@"iPhone6,1"]
        || [deviceModel isEqualToString:@"iPhone6,2"])  return @"iPhone5s";
    if ([deviceModel isEqualToString:@"iPhone7,1"])     return @"iPhone6Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])     return @"iPhone6";
    
    if ([deviceModel hasPrefix:@"iPhone"]) {
        return @"iPhone";
    }

    if ([deviceModel isEqualToString:@"iPod1,1"])       return @"iPod1";
    if ([deviceModel isEqualToString:@"iPod2,1"])       return @"iPod2";
    if ([deviceModel isEqualToString:@"iPod3,1"])       return @"iPod3";
    if ([deviceModel isEqualToString:@"iPod4,1"])       return @"iPod4";
    if ([deviceModel isEqualToString:@"iPod5,1"])       return @"iPod5";
    
    if ([deviceModel hasPrefix:@"iPod"]) {
        return @"iPod";
    }
    
    if ([deviceModel isEqualToString:@"iPad1,1"]
        || [deviceModel isEqualToString:@"iPad1,2"])    return @"iPad1";

    if ([deviceModel isEqualToString:@"iPad2,1"]
        || [deviceModel isEqual:@"iPad2,2"]
        || [deviceModel isEqualToString:@"iPad2,3"])    return @"iPad2";
    
    if ([deviceModel isEqualToString:@"iPad3,1"]
        || [deviceModel isEqualToString:@"iPad3,2"]
        || [deviceModel isEqualToString:@"iPad3,3"])    return @"iPad3";
    
    if ([deviceModel isEqualToString:@"iPad3,4"])       return @"iPad4";
    
    if ([deviceModel hasPrefix:@"iPad"]) {
        return @"iPad";
    }
    
    //If none was found, send the original string
    return deviceModel;
}

+ (BOOL)isJailbroken
{
    
#if TARGET_IPHONE_SIMULATOR
    return NO;
    
#else
    BOOL isJailbroken = NO;
    
    BOOL cydiaInstalled = [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"];
    
    FILE *f = fopen("/bin/bash", "r");
    
    if (!(errno == ENOENT) && cydiaInstalled) {
        
        //Device is jailbroken
        isJailbroken = YES;
    }
    fclose(f);
    return isJailbroken;
#endif
    
}

+ (NSString*)getCellularProviderName
{
    
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc]init];
    
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    NSString *imsi=@"";
    if (carrier!=NULL) {
//        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
//        [dic setObject:[carrier carrierName] forKey:@"Carriername"];
//        [dic setObject:[carrier mobileCountryCode] forKey:@"MobileCountryCode"];
//        [dic setObject:[carrier mobileNetworkCode]forKey:@"MobileNetworkCode"];
//        [dic setObject:[carrier isoCountryCode] forKey:@"ISOCountryCode"];
//        [dic setObject:[carrier allowsVOIP]?@"YES":@"NO" forKey:@"AllowsVOIP"];
//        imsi = [dic toJsonString];
        
        imsi = [carrier carrierName];
    }
    
    return imsi;//cellularProviderName;
    
}

+ (NSString *)deviceNameWithDeviceModel:(BOOL)shouldIncludeDeviceModel {
    if (shouldIncludeDeviceModel) {
        return [NSString stringWithFormat:@"%@ (%@)", [UIDevice deviceName], [UIDevice deviceModel]];
    }
    
    return [UIDevice deviceName];
}

+ (NSArray *)localIPAddresses
{
    NSMutableArray *ipAddresses = [NSMutableArray array] ;
    struct ifaddrs *allInterfaces;
    
    // Get list of all interfaces on the local machine:
    if (getifaddrs(&allInterfaces) == 0) {
        struct ifaddrs *interface;

        // For each interface ...
        for (interface = allInterfaces; interface != NULL; interface = interface->ifa_next) {
            unsigned int flags = interface->ifa_flags;
            struct sockaddr *addr = interface->ifa_addr;
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if ((flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING)) {
                if (addr->sa_family == AF_INET || addr->sa_family == AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    char host[NI_MAXHOST];
                    getnameinfo(addr, addr->sa_len, host, sizeof(host), NULL, 0, NI_NUMERICHOST);
                    
                    [ipAddresses addObject:[[NSString alloc] initWithUTF8String:host]];
                }
            }
        }
        
        freeifaddrs(allInterfaces);
    }
    
    return ipAddresses;
}

+ (NSString*)IDFV
{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

//+ (NSString*)IDFA
//{
//    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//}

@end
