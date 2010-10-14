
#import <Cocoa/Cocoa.h>
#import "Signal.h"

@interface FrontWindowSignal : Signal {
	
	NSString *lastJson;
}

+ (NSString*)findDocUrl:(AXUIElementRef)window;
+ (NSString*)findWebUrl:(AXUIElementRef)window;
+ (AXUIElementRef)findMainWindowOfApp:(AXUIElementRef)appElem;
+ (NSArray*)findDescentantsOf:(AXUIElementRef)elem matchingRolePath:(NSArray*)rolePath;


@end
