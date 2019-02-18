//
//  MLHudAlert.h
//

#import <Cocoa/Cocoa.h>
#import "MLHudAlertWindow.h"

enum {
    MLHudAlertTypeInfo = 0,
    MLHudAlertTypeWarn,
    MLHudAlertTypeError,
    MLHudAlertTypeSuccess,
    MLHudAlertTypeLoading,
};
typedef int MLHudAlertType;

@interface MLHudAlert : NSWindowController {
    NSTimer *dismissTimer;
    NSEvent *clickEvent;
}



+ (void) alertWithWindow: (NSWindow *) window type: (MLHudAlertType) type message: (NSString *) message;
+ (void) dismisWindow;

@end
