
#import "Controller.h"

#import "Signal.h"
#import "MousePosSignal.h"
#import "InputIdleSignal.h"
#import "FrontWindowSignal.h"
#import "ScreenshotSignal.h"


@implementation Controller

- (void)awakeFromNib {
	
	signals = [NSMutableArray array];
	
	[signals addObject:[[MousePosSignal alloc] init]];
	[signals addObject:[[InputIdleSignal alloc] init]];
	[signals addObject:[[FrontWindowSignal alloc] init]];
	[signals addObject:[[ScreenshotSignal alloc] init]];
	
	// Yes, this code is fugly:
	long ms;
	ms = (long)(((double)(((Signal*)[signals objectAtIndex:0]).sampleInterval)) * 1000);
	[rate0 setStringValue:[NSString stringWithFormat:@"%ld ms/sample", ms]];
	ms = (long)(((double)(((Signal*)[signals objectAtIndex:1]).sampleInterval)) * 1000);
	[rate1 setStringValue:[NSString stringWithFormat:@"%ld ms/sample", ms]];
	ms = (long)(((double)(((Signal*)[signals objectAtIndex:2]).sampleInterval)) * 1000);
	[rate2 setStringValue:[NSString stringWithFormat:@"%ld ms/sample", ms]];
	ms = (long)(((double)(((Signal*)[signals objectAtIndex:3]).sampleInterval)) * 1000);
	[rate3 setStringValue:[NSString stringWithFormat:@"%ld ms/sample", ms]];
	
	
	for (Signal *x in signals) {
		[x startSampling];
	}
}


- (void)dealloc {
	[signals release];
	[super dealloc];
}

@end
