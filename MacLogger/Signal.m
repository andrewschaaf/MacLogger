
#import "Signal.h"

#import "UtilVarints.h"


@implementation Signal


@synthesize sampleInterval;


- (void)sample {
	NSLog(@"%@ needs to implement sample", signalName);
}


- (id)init {
	if (self = [super init]) {
		numLogged = 0;
		lastLoggedMs = 0;
	}
	return self;
}

- (void)startSampling {
	NSLog(@"start sampling %f", (float)sampleInterval);
	
	[NSTimer
		 scheduledTimerWithTimeInterval:sampleInterval
		 target:self
		 selector:@selector(tick:)
		 userInfo:nil
		 repeats:YES];
}

- (void)tick:(NSTimer*)timer {
	[self sample];
}

- (void)ensureSignalDirExists {
	
	NSError *err;
	
	signalDir = [NSString stringWithFormat:@"%@/MacLogger/signals/%@",
							[@"~/Library/Application Support" stringByExpandingTildeInPath],
							signalName];
	
	[signalDir retain];
	
	[[NSFileManager defaultManager]
		  createDirectoryAtPath:signalDir
		  withIntermediateDirectories:YES
		  attributes:nil
		  error:&err];
	// HANDLE failure
}

- (void)logData:(NSData*)data {
	
	NSDate *date = [NSDate date];
	unsigned long long ms = (long long)([date timeIntervalSince1970] * 1000);
	
	
	if (! fileHandle) {
		
		[self ensureSignalDirExists];
		
		NSError *err;
		
		NSString *path = [NSString stringWithFormat:@"%@/%@-%.3d-Z.signal",
							signalDir,
							[date
								descriptionWithCalendarFormat:@"%Y-%m-%d-%H-%M-%S"
								timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]
								locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]],
							(int)(ms % 1000)];
		
		//LATER: consider attributes
		if (![[NSFileManager defaultManager] createFileAtPath:path contents:[NSData data] attributes:nil]) {
			NSLog(@"FAIL creating file");//HANDLE
		}
		
		fileHandle = [[NSFileHandle fileHandleForWritingToURL:[NSURL fileURLWithPath:path] error:&err] retain];
		if (!fileHandle) {
			NSLog(@"FAIL opening file %@", err);//HANDLE
		}
	}
	
	
	// time delta
	[fileHandle writeData:[UtilVarints
							encodeUnsignedFromUnsignedLongLong:(ms - lastLoggedMs)]];
	
	// data length
	[fileHandle writeData:[UtilVarints
							encodeUnsignedFromUnsignedLongLong:[data length]]];
	// data
	[fileHandle writeData:data];
	
	 
	numLogged++;
	lastLoggedMs = ms;
}

- (void)dealloc {
	[signalName dealloc];
	[super dealloc];
}

@end
