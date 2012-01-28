//  Copyright (c) 2012 Jonathan 'Wolf' Rentzsch: http://rentzsch.com
//  Some rights reserved: http://opensource.org/licenses/MIT

#import "ForceQuitUnresponsiveAppsAppDelegate.h"
#import "CGSNotifications.h"

void MyNotifyProc(CGSNotificationType type, void *data, unsigned int dataLength, void *userData) {
    assert(kCGSNotificationAppUnresponsive == type);
    assert(data);
    assert(dataLength >= sizeof(CGSProcessNotificationData));
    
    CGSProcessNotificationData *noteData = (CGSProcessNotificationData*)data;
    
    NSRunningApplication *unresponsiveProcess = [NSRunningApplication runningApplicationWithProcessIdentifier:noteData->pid];
    
    NSLog(@"Force-Quitting Unresponsive Application: %@", unresponsiveProcess.localizedName);
    
    [unresponsiveProcess forceTerminate];
}

@implementation ForceQuitUnresponsiveAppsAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification*)notification_ {
	CGError err = CGSRegisterNotifyProc(MyNotifyProc,
                                        kCGSNotificationAppUnresponsive,
                                        NULL);
    if (err) {
        CGSGlobalError(err, "");
        [NSApp terminate:nil];
    }
}

@end
