/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mount.h>
#import <mach/mach.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "UIDevice+Hardware.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation UIDevice (Hardware)

- (NSString *)platform {
    return [self getSysInfoByName:"hw.machine"];
}
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}
/**
 https://www.theiphonewiki.com/wiki/Models
 */
- (NSString *)platformString {
    NSString *platformName=nil;
    NSString *model = [self platform];
    if (!model) return @"unKnown Device";
    NSDictionary *dic = @{
                          // The ever mysterious iFPGA
                          @"iFPGA"    : @"iFPGA",
                          
                          @"Watch1,1" : @"Apple Watch 38mm",
                          @"Watch1,2" : @"Apple Watch 42mm",
                          @"Watch2,3" : @"Apple Watch Series 2 38mm",
                          @"Watch2,4" : @"Apple Watch Series 2 42mm",
                          @"Watch2,6" : @"Apple Watch Series 1 38mm",
                          @"Watch2,7" : @"Apple Watch Series 1 42mm",
                          @"Watch3,1" : @"Apple Watch Series 3 38mm",
                          @"Watch3,2" : @"Apple Watch Series 3 42mm",
                          @"Watch3,3" : @"Apple Watch Series 3 38mm",
                          @"Watch3,4" : @"Apple Watch Series 3 42mm",
                          
                          @"iPod1,1" : @"iPod touch 1",
                          @"iPod2,1" : @"iPod touch 2",
                          @"iPod3,1" : @"iPod touch 3",
                          @"iPod4,1" : @"iPod touch 4",
                          @"iPod5,1" : @"iPod touch 5",
                          @"iPod7,1" : @"iPod touch 6",
                          
                          @"iPhone1,1" : @"iPhone 1G",
                          @"iPhone1,2" : @"iPhone 3G",
                          @"iPhone2,1" : @"iPhone 3GS",
                          @"iPhone3,1" : @"iPhone 4 (GSM)",
                          @"iPhone3,2" : @"iPhone 4",
                          @"iPhone3,3" : @"iPhone 4 (CDMA)",
                          @"iPhone4,1" : @"iPhone 4S",
                          @"iPhone5,1" : @"iPhone 5",
                          @"iPhone5,2" : @"iPhone 5",
                          @"iPhone5,3" : @"iPhone 5c",
                          @"iPhone5,4" : @"iPhone 5c",
                          @"iPhone6,1" : @"iPhone 5s",
                          @"iPhone6,2" : @"iPhone 5s",
                          @"iPhone7,1" : @"iPhone 6 Plus",
                          @"iPhone7,2" : @"iPhone 6",
                          @"iPhone8,1" : @"iPhone 6s",
                          @"iPhone8,2" : @"iPhone 6s Plus",
                          @"iPhone8,4" : @"iPhone SE",
                          @"iPhone9,1" : @"iPhone 7",
                          @"iPhone9,2" : @"iPhone 7 Plus",
                          @"iPhone9,3" : @"iPhone 7",
                          @"iPhone9,4" : @"iPhone 7 Plus",
                          @"iPhone10,1" : @"iPhone 8",
                          @"iPhone10,2" : @"iPhone 8 Plus",
                          @"iPhone10,4" : @"iPhone 8",
                          @"iPhone10,5" : @"iPhone 8 Plus",
                          @"iPhone10,3" : @"iPhone X",
                          @"iPhone10,6" : @"iPhone X",
                          
                          @"iPad1,1" : @"iPad 1",
                          @"iPad2,1" : @"iPad 2 (WiFi)",
                          @"iPad2,2" : @"iPad 2 (GSM)",
                          @"iPad2,3" : @"iPad 2 (CDMA)",
                          @"iPad2,4" : @"iPad 2",
                          @"iPad2,5" : @"iPad mini 1",
                          @"iPad2,6" : @"iPad mini 1",
                          @"iPad2,7" : @"iPad mini 1",
                          @"iPad3,1" : @"iPad 3 (WiFi)",
                          @"iPad3,2" : @"iPad 3 (4G)",
                          @"iPad3,3" : @"iPad 3 (4G)",
                          @"iPad3,4" : @"iPad 4",
                          @"iPad3,5" : @"iPad 4",
                          @"iPad3,6" : @"iPad 4",
                          @"iPad4,1" : @"iPad Air",
                          @"iPad4,2" : @"iPad Air",
                          @"iPad4,3" : @"iPad Air",
                          @"iPad4,4" : @"iPad mini 2",
                          @"iPad4,5" : @"iPad mini 2",
                          @"iPad4,6" : @"iPad mini 2",
                          @"iPad4,7" : @"iPad mini 3",
                          @"iPad4,8" : @"iPad mini 3",
                          @"iPad4,9" : @"iPad mini 3",
                          @"iPad5,1" : @"iPad mini 4",
                          @"iPad5,2" : @"iPad mini 4",
                          @"iPad5,3" : @"iPad Air 2",
                          @"iPad5,4" : @"iPad Air 2",
                          @"iPad6,3" : @"iPad Pro (9.7 inch)",
                          @"iPad6,4" : @"iPad Pro (9.7 inch)",
                          @"iPad6,7" : @"iPad Pro (12.9 inch)",
                          @"iPad6,8" : @"iPad Pro (12.9 inch)",
                          @"iPad6,11" : @"iPad (5th generation)",
                          @"iPad6,12" : @"iPad (5th generation)",
                          @"iPad7,1" : @"iPad Pro (12.9 inch)",
                          @"iPad7,2" : @"iPad Pro (12.9 inch)",
                          @"iPad7,3" : @"iPad Pro (10.5 inch)",
                          @"iPad7,4" : @"iPad Pro (10.5 inch)",
                          @"iPad7,5" : @"iPad (6th generation)",
                          @"iPad7,5" : @"iPad (6th generation)",
                          
                          @"AppleTV2,1" : @"Apple TV 2",
                          @"AppleTV3,1" : @"Apple TV 3",
                          @"AppleTV3,2" : @"Apple TV 3",
                          @"AppleTV5,3" : @"Apple TV 4",
                          @"AppleTV6,2" : @"Apple TV 4K",
                          
                          @"i386" : @"Simulator x86",
                          @"x86_64" : @"Simulator x64",
                          };
    platformName = dic[model];
    if (!platformName) platformName = model;
    return platformName;
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

- (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark platform type and name utils
- (NSUInteger) platformType
{
    NSString *platform = [self platform];
    
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"])            return UIDevice3GSiPhone;
    if ([platform hasPrefix:@"iPhone3"])            return UIDevice4iPhone;
    if ([platform hasPrefix:@"iPhone4"])            return UIDevice4SiPhone;
    if ([platform hasPrefix:@"iPhone5"])            return UIDevice5iPhone;
    if ([platform hasPrefix:@"iPhone6"])            return UIDevice5SiPhone;
    if ([platform hasPrefix:@"iPhone7,1"])          return UIDevice6PiPhone;
    if ([platform hasPrefix:@"iPhone7,2"])          return UIDevice6iPhone;
    if ([platform hasPrefix:@"iPhone8,1"])          return UIDevice6SiPhone;
    if ([platform hasPrefix:@"iPhone8,2"])          return UIDevice6SPiPhone;
    if ([platform hasPrefix:@"iPhone8,3"])          return UIDeviceSEiPhone;
    if ([platform hasPrefix:@"iPhone8,4"])          return UIDeviceSEiPhone;
    if ([platform hasPrefix:@"iPhone9,1"])          return UIDevice7iPhone;
    if ([platform hasPrefix:@"iPhone9,2"])          return UIDevice7PiPhone;
    if ([platform hasPrefix:@"iPhone9,3"])          return UIDevice7iPhone;
    if ([platform hasPrefix:@"iPhone9,4"])          return UIDevice7PiPhone;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])              return UIDevice1GiPod;
    if ([platform hasPrefix:@"iPod2"])              return UIDevice2GiPod;
    if ([platform hasPrefix:@"iPod3"])              return UIDevice3GiPod;
    if ([platform hasPrefix:@"iPod4"])              return UIDevice4GiPod;
    
    // iPad
    if ([platform hasPrefix:@"iPad1"])              return UIDevice1GiPad;
    if ([platform hasPrefix:@"iPad2"])              return UIDevice2GiPad;
    if ([platform hasPrefix:@"iPad3"])              return UIDevice3GiPad;
    if ([platform hasPrefix:@"iPad4"])              return UIDevice4GiPad;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;
    if ([platform hasPrefix:@"AppleTV3"])           return UIDeviceAppleTV3;
    
    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    if ([platform hasPrefix:@"AppleTV"])            return UIDeviceUnknownAppleTV;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
    }
    
    return UIDeviceUnknown;
}

- (BOOL) hasRetinaDisplay
{
    return ([UIScreen mainScreen].scale == 2.0f);
}

- (UIDeviceFamily) deviceFamily
{
    NSString *platform = [self platform];
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    if ([platform hasPrefix:@"AppleTV"]) return UIDeviceFamilyAppleTV;
    
    return UIDeviceFamilyUnknown;
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    return outstring;
}

- (NSString *)getCurrentTMobile{
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    //当前手机所属运营商名称
    NSString *mobile = [carrier carrierName];
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        mobile = @"无运营商";
    }
    return mobile;
}

+ (BOOL) isJailbroken
{
    
    //If the app is running on the simulator
#if (TARGET_IPHONE_SIMULATOR)
    return NO;
    
    //If its running on an actual device
#else
    BOOL isJailbroken = NO;
    
    //This line checks for the existence of Cydia
    BOOL cydiaInstalled = [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"];
    
    FILE *f = fopen("/bin/bash", "r");
    
    if (!(errno == ENOENT) || cydiaInstalled) {
        //Device is jailbroken
        isJailbroken = YES;
    }
    
    fclose(f);
    return isJailbroken;
#endif
}

+ (unsigned int)getFreeMemory
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return (unsigned int)(vm_stat.free_count * pagesize);
}

+ (unsigned int)getUsedMemory
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (unsigned int)((kerr == KERN_SUCCESS) ? info.resident_size : 0);
}

- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (NSString*) getNOP
{
    // network info
    NSString* code = @"0";
    
    @try {
        
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        NSString* mnc = [carrier mobileNetworkCode];
        [netInfo release];
        
        if (mnc != nil){
            code = [[carrier mobileCountryCode] stringByAppendingStringSafely:mnc];
            
            if( !code ){
                code = @"0";
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception reason]);
    }
    
    return code;
}

// Illicit Bluetooth check -- cannot be used in App Store
/*
 Class  btclass = NSClassFromString(@"GKBluetoothSupport");
 if ([btclass respondsToSelector:@selector(bluetoothStatus)])
 {
 printf("BTStatus %d\n", ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0);
 bluetooth = ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0;
 printf("Bluetooth %s enabled\n", bluetooth ? "is" : "isn't");
 }
 */
@end

