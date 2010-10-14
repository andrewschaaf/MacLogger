
#import "ScreenshotSignal.h"


@implementation ScreenshotSignal


- (id)init {
	if (self = [super init]) {
		sampleInterval = 15.0;
		signalName = @"screenshot";
	}
	return self;
}


- (void)sample {
	
	[self ensureSignalDirExists];
	
	NSDate *t = [NSDate date];
	
	NSString *pngPathParent = [NSString stringWithFormat:@"%@/%@",
									signalDir,
									[t
										descriptionWithCalendarFormat:@"%Y/%m/%d"
										timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]
										locale:nil]];
	
	NSString *pngPath = [NSString stringWithFormat:@"%@/%@",
									pngPathParent,
									[t
										descriptionWithCalendarFormat:@"%Y-%m-%d-%H-%M-%S.png"
										timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]
										locale:nil]];
	
	NSError *err;
	[[NSFileManager defaultManager]
		 createDirectoryAtPath:pngPathParent
		 withIntermediateDirectories:YES
		 attributes:nil
		 error:&err];
	
	[NSTask
			launchedTaskWithLaunchPath:@"/usr/sbin/screencapture"
			arguments:[NSArray arrayWithObjects: @"-x", pngPath, nil]];
	
}


@end
