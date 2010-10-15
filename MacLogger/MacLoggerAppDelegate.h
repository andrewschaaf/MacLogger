
#import <Cocoa/Cocoa.h>

// (for 10.5) http://stackoverflow.com/questions/1496788/building-for-10-5-in-xcode-3-2-on-snow-leopard-error
#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
@interface MacLoggerAppDelegate : NSObject
#else
@interface MyAppDelegate : NSObject <NSApplicationDelegate>
#endif
{
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
