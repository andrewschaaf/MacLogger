
#import <Cocoa/Cocoa.h>


@interface Signal : NSObject {
	
	NSTimeInterval sampleInterval;
	NSString *signalName;
	NSString *signalDir;
	
	NSFileHandle *fileHandle;
	unsigned long long numLogged;
	unsigned long long lastLoggedMs;
}

- (void)sample;

- (void)startSampling;
- (void)ensureSignalDirExists;
- (void)logData:(NSData*)data;

- (void)tick:(NSTimer*)timer;


@property (readonly) NSTimeInterval sampleInterval;

@end
