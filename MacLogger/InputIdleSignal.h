
#import <Cocoa/Cocoa.h>
#import "Signal.h"

@interface InputIdleSignal : Signal {

}

+ (unsigned long long)idleNanoseconds;

@end
