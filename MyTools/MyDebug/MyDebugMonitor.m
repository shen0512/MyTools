//
//  MyDebugMonitor.m
//  MyTools
//
//  Created by Shen on 2024/8/24.
//

#import "MyDebugMonitor.h"
#import <UIKit/UIKit.h>

#import <sys/utsname.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <sys/sysctl.h>
#import <sys/stat.h>

#define kMaxPercent 100

@implementation MyDebugMonitor
+(long long unsigned)MemoryUsage{
    task_vm_info_data_t info;
    mach_msg_type_number_t size = TASK_VM_INFO_COUNT;
    kern_return_t kerr = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&info, &size);
    if(kerr == KERN_SUCCESS){
        mach_vm_size_t totalSize = info.internal+info.compressed;
        return totalSize;
    }
    return -1;
}

+(unsigned int)CPUUsage{
    kern_return_t kr;
    mach_msg_type_number_t count;
    static host_cpu_load_info_data_t previous_info = {0, 0, 0, 0};
    host_cpu_load_info_data_t info;

//    CPUUsage usage = {0, 0, 0, 1};
    count = HOST_CPU_LOAD_INFO_COUNT;

    kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&info, &count);
    if (kr != KERN_SUCCESS) {
//        return usage;
        return -1;
    }

    natural_t user   = info.cpu_ticks[CPU_STATE_USER] - previous_info.cpu_ticks[CPU_STATE_USER];
    natural_t nice   = info.cpu_ticks[CPU_STATE_NICE] - previous_info.cpu_ticks[CPU_STATE_NICE];
    natural_t system = info.cpu_ticks[CPU_STATE_SYSTEM] - previous_info.cpu_ticks[CPU_STATE_SYSTEM];
    natural_t idle   = info.cpu_ticks[CPU_STATE_IDLE] - previous_info.cpu_ticks[CPU_STATE_IDLE];
    natural_t total  = user + nice + system + idle;
    return (user + nice + system) * 100.0 / total;
    
//    previous_info    = info;
//    usage.user = user;
//    usage.system = system;
//    usage.nice = nice;
//    usage.idle = idle;
//    return usage;
}

+(CGFloat)APPCPUUsage{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;

    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }

    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;

    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;

    thread_basic_info_t basic_info_th;

    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }

    long total_time     = 0;
    long total_userTime = 0;
    CGFloat total_cpu   = 0;
    int j;

    // for each thread
    for (j = 0; j < (int)thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }

        basic_info_th = (thread_basic_info_t)thinfo;

        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            total_time     = total_time + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            total_userTime = total_userTime + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            total_cpu      = total_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * kMaxPercent;
        }
    }

    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);

    return total_cpu;
}

+(NSString*)DeviceName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];

    static NSDictionary* deviceNamesByCode = nil;

    if(!deviceNamesByCode){
        // source: https://theapplewiki.com/wiki/Models?source=post_page-----5cee991ace1e--------------------------------
        deviceNamesByCode = @{
            @"i386"      : @"Simulator",
            @"x86_64"    : @"Simulator",
            @"iPod1,1"   : @"iPod Touch",        // (Original)
            @"iPod2,1"   : @"iPod Touch",        // (Second Generation)
            @"iPod3,1"   : @"iPod Touch",        // (Third Generation)
            @"iPod4,1"   : @"iPod Touch",        // (Fourth Generation)
            @"iPod7,1"   : @"iPod Touch",        // (6th Generation)
            @"iPhone1,1" : @"iPhone",// (Original)
            @"iPhone1,2" : @"iPhone",// (3G)
            @"iPhone2,1" : @"iPhone",// (3GS)
            @"iPhone3,1" : @"iPhone 4",          // (GSM)
            @"iPhone3,3" : @"iPhone 4",          // (CDMA/Verizon/Sprint)
            @"iPhone4,1" : @"iPhone 4S",         //
            @"iPhone5,1" : @"iPhone 5",          // (model A1428, AT&T/Canada)
            @"iPhone5,2" : @"iPhone 5",          // (model A1429, everything else)
            @"iPhone5,3" : @"iPhone 5c",         // (model A1456, A1532 | GSM)
            @"iPhone5,4" : @"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
            @"iPhone6,1" : @"iPhone 5s",         // (model A1433, A1533 | GSM)
            @"iPhone6,2" : @"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
            @"iPhone7,1" : @"iPhone 6 Plus",     //
            @"iPhone7,2" : @"iPhone 6",          //
            @"iPhone8,1" : @"iPhone 6S",         //
            @"iPhone8,2" : @"iPhone 6S Plus",    //
            @"iPhone8,4" : @"iPhone SE",         //
            @"iPhone9,1" : @"iPhone 7",          //
            @"iPhone9,3" : @"iPhone 7",          //
            @"iPhone9,2" : @"iPhone 7 Plus",     //
            @"iPhone9,4" : @"iPhone 7 Plus",     //
            @"iPhone10,1": @"iPhone 8",          // CDMA
            @"iPhone10,4": @"iPhone 8",          // GSM
            @"iPhone10,2": @"iPhone 8 Plus",     // CDMA
            @"iPhone10,5": @"iPhone 8 Plus",     // GSM
            @"iPhone10,3": @"iPhone X",          // CDMA
            @"iPhone10,6": @"iPhone X",          // GSM
            @"iPhone11,2": @"iPhone XS",         //
            @"iPhone11,4": @"iPhone XS Max",     //
            @"iPhone11,6": @"iPhone XS Max",     // China
            @"iPhone11,8": @"iPhone XR",         //
            @"iPhone12,1": @"iPhone 11",         //
            @"iPhone12,3": @"iPhone 11 Pro",     //
            @"iPhone12,5": @"iPhone 11 Pro Max", //
            @"iPhone13,1": @"iPhone 12 Mini",
            @"iPhone13,2": @"iPhone 12",
            @"iPhone13,3": @"iPhone 12 Pro",
            @"iPhone13,4": @"iPhone 12 Pro Max",
            @"iPhone14,4": @"iPhone 13 Mini",
            @"iPhone14,5": @"iPhone 13",
            @"iPhone14,2": @"iPhone 13 Pro",
            @"iPhone14,3": @"iPhone 13 Pro Max",
            @"iPhone14,7": @"iPhone 14",
            @"iPhone14,8": @"iPhone 14 Plus",
            @"iPhone15,2": @"iPhone 14 Pro",
            @"iPhone15,3": @"iPhone 14 Pro Max",
            @"iPhone15,4": @"iPhone 15",
            @"iPhone15,5": @"iPhone 15 Plus",
            @"iPhone16,1": @"iPhone 15 Pro",
            @"iPhone16,2": @"iPhone 15 Pro Max",
            @"iPhone12,8": @"iPhone SE (2nd generation)",
            @"iPhone14,6": @"iPhone SE (3rd generation)",

            @"iPad1,1"   : @"iPad",  // (Original)
            @"iPad2,1"   : @"iPad 2",//
            @"iPad2,2"   : @"iPad 2",//
            @"iPad2,3"   : @"iPad 2",//
            @"iPad2,4"   : @"iPad 2",//
            @"iPad2,5"   : @"iPad Mini",
            @"iPad2,6"   : @"iPad Mini",
            @"iPad2,7"   : @"iPad Mini",
            @"iPad3,1"   : @"iPad (3rd generation)",  // (3rd Generation)
            @"iPad3,2"   : @"iPad (3rd generation)",  // (3rd Generation)
            @"iPad3,3"   : @"iPad (3rd generation)",  // (3rd Generation)
            @"iPad3,4"   : @"iPad (4th generation)",
            @"iPad3,5"   : @"iPad (4th generation)",
            @"iPad3,6"   : @"iPad (4th generation)",
            @"iPad4,1"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
            @"iPad4,2"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
            @"iPad4,3"   : @"iPad Air",
            @"iPad4,4"   : @"iPad Mini 2",         // (2nd Generation iPad Mini - Wifi)
            @"iPad4,5"   : @"iPad Mini 2",         // (2nd Generation iPad Mini - Cellular)
            @"iPad4,6"   : @"iPad Mini 2",
            @"iPad4,7"   : @"iPad Mini 3",
            @"iPad4,8"   : @"iPad Mini 3",
            @"iPad4,9"   : @"iPad Mini 3",
            @"iPad5,1"   : @"iPad Mini 4",
            @"iPad5,2"   : @"iPad Mini 4",
            @"iPad5,3"   : @"iPad Air 2",
            @"iPad5,4"   : @"iPad Air 2",
            @"iPad6,3"   : @"iPad Pro (9.7-inch)",
            @"iPad6,4"   : @"iPad Pro (9.7-inch)",
            @"iPad6,7"   : @"iPad Pro (12.9-inch)",   // iPad Pro 12.9 inches - (model A1584)
            @"iPad6,8"   : @"iPad Pro (12.9-inch)",   // iPad Pro 12.9 inches - (model A1652)
            @"iPad6,11"  : @"iPad (5th generation)",
            @"iPad6,12"  : @"iPad (5th generation)",
            @"iPad7,1"   : @"iPad Pro (12.9-inch) (2nd generation)",
            @"iPad7,2"   : @"iPad Pro (12.9-inch) (2nd generation)",
            @"iPad7,3"   : @"iPad Pro (10.5-inch)",
            @"iPad7,4"   : @"iPad Pro (10.5-inch)",
            @"iPad7,5"   : @"iPad (6th generation)",
            @"iPad7,6"   : @"iPad (6th generation)",
            @"iPad7,11"  : @"iPad (7th generation)",
            @"iPad7,12"  : @"iPad (7th generation)",
            @"iPad8,1"   : @"iPad Pro (11-inch) (1st generation)",
            @"iPad8,2"   : @"iPad Pro (11-inch) (1st generation)",
            @"iPad8,3"   : @"iPad Pro (11-inch) (1st generation)",
            @"iPad8,4"   : @"iPad Pro (11-inch) (1st generation)",
            @"iPad8,5"   : @"iPad Pro (12.9-inch) (3rd generation)",
            @"iPad8,6"   : @"iPad Pro (12.9-inch) (3rd generation)",
            @"iPad8,7"   : @"iPad Pro (12.9-inch) (3rd generation)",
            @"iPad8,8"   : @"iPad Pro (12.9-inch) (3rd generation)",
            @"iPad8,9"   : @"iPad Pro (11-inch) (2nd generation)",
            @"iPad8,10"  : @"iPad Pro (11-inch) (2nd generation)",
            @"iPad8,11"  : @"iPad Pro (12.9-inch) (4th generation)",
            @"iPad8,12"  : @"iPad Pro (12.9-inch) (4th generation)",
            @"iPad11,1"  : @"iPad Mini (5th generation)",
            @"iPad11,2"  : @"iPad Mini (5th generation)",
            @"iPad11,3"  : @"iPad Air (3rd generation)",
            @"iPad11,4"  : @"iPad Air (3rd generation)",
            @"iPad11,6"  : @"iPad (8th generation)",
            @"iPad11,7"  : @"iPad (8th generation)",
            @"iPad12,1"  : @"iPad (9th generation)",
            @"iPad12,2"  : @"iPad (9th generation)",
            @"iPad13,18" : @"iPad (10th generation)",
            @"iPad13,19" : @"iPad (10th generation)",
            @"iPad13,1"  : @"iPad Air (4th generation)",
            @"iPad13,2"  : @"iPad Air (4th generation)",
            @"iPad13,4"  : @"iPad Pro (11-inch) (3rd generation)",
            @"iPad13,5"  : @"iPad Pro (11-inch) (3rd generation)",
            @"iPad13,6"  : @"iPad Pro (11-inch) (3rd generation)",
            @"iPad13,7"  : @"iPad Pro (11-inch) (3rd generation)",
            @"iPad13,8"  : @"iPad Pro (12.9-inch) (5th generation)",
            @"iPad13,9"  : @"iPad Pro (12.9-inch) (5th generation)",
            @"iPad13,10" : @"iPad Pro (12.9-inch) (5th generation)",
            @"iPad13,11" : @"iPad Pro (12.9-inch) (5th generation)",
            @"iPad13,16" : @"iPad Air (5th generation)",
            @"iPad13,17" : @"iPad Air (5th generation)",
            @"iPad14,1"  : @"iPad Mini (6th generation)",
            @"iPad14,2"  : @"iPad Mini (6th generation)",
            @"iPad14,3"  : @"iPad Pro (11-inch) (4th generation)",
            @"iPad14,4"  : @"iPad Pro (11-inch) (4th generation)",
            @"iPad14,5"  : @"iPad Pro (12.9-inch) (6th generation)",
            @"iPad14,6"  : @"iPad Pro (12.9-inch) (6th generation)",
            @"iPad14,8"  : @"iPad Air (11-inch) (M2)",
            @"iPad14,9"  : @"iPad Air (11-inch) (M2)",
            @"iPad14,10" : @"iPad Air (13-inch) (M2)",
            @"iPad14,11" : @"iPad Air (13-inch) (M2)",
            @"iPad16,3"  : @"iPad Pro (11-inch) (M4)",
            @"iPad16,4"  : @"iPad Pro (11-inch) (M4)",
            @"iPad16,5"  : @"iPad Pro (13-inch) (M4)",
            @"iPad16,6"  : @"iPad Pro (13-inch) (M4)"};
    }

    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    if(deviceName){
        return [deviceName stringByAppendingFormat:@"(%@)",code];
    }
    return [NSString stringWithFormat:@"null(%@)", code];
}

+(NSString*)IOSVersion{
    return [[UIDevice currentDevice] systemVersion];
}

@end
