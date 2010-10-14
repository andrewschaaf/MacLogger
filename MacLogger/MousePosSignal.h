
#import <Cocoa/Cocoa.h>
#import "Signal.h"


@interface MousePosSignal : Signal {
	long last_x, last_y;
}

@end
