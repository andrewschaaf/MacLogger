
#import "MousePosSignal.h"

#import <Carbon/Carbon.h>
#import "UtilVarints.h"


@implementation MousePosSignal


- (id)init {
	if (self = [super init]) {
		sampleInterval = 0.01;
		signalName = @"mouse-pos";
		
		last_x = -1;
		last_y = -1;
	}
	return self;
}

- (void)sample {
	
	int x, y;
	HIPoint hiPoint;
	HIGetMousePosition(kHICoordSpaceScreenPixel, NULL, &hiPoint);
	x = hiPoint.x;
	y = hiPoint.y;
	
	if ((x != last_x) || (y != last_y)) {
		
		NSMutableData *data = [NSMutableData data];
		[data appendData:[UtilVarints encodeUnsignedFromUnsignedLongLong:x]];
		[data appendData:[UtilVarints encodeUnsignedFromUnsignedLongLong:y]];
		
		[self logData:data];
		
		last_x = x;
		last_y = y;
	}
}

@end
