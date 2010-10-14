
#import "FrontWindowSignal.h"
#import "JSON.h"


@implementation FrontWindowSignal


- (id)init {
	if (self = [super init]) {
		sampleInterval = 0.2;
		signalName = @"front-window";
		
		lastJson = nil;
	}
	return self;
}


- (void)sample {
	
	/*
	 
	 AXUIElementCopyElementAtPosition
	 
	 AXUIElementCreateApplication(pid)
	 
	 */
	
	NSMutableDictionary *info = [NSMutableDictionary dictionary];
	
	
	NSDictionary *appInfo = [[NSWorkspace sharedWorkspace] activeApplication];
	long pid = [[appInfo objectForKey:@"NSApplicationProcessIdentifier"] longValue];
	
	[info
		setObject:[appInfo objectForKey:@"NSApplicationBundleIdentifier"]
		forKey:@"app"];
	
	
	// Find main window, if any
	AXUIElementRef appElem = AXUIElementCreateApplication(pid);
	AXUIElementRef mainWindow = [FrontWindowSignal findMainWindowOfApp:appElem];
	
	
	if (mainWindow) {
		
		NSString *s;
		
		s = [FrontWindowSignal findDocUrl:mainWindow];
		if (s) {
			[info setObject:s forKey:@"docUrl"];
		}
		
		s = [FrontWindowSignal findWebUrl:mainWindow];
		if (s) {
			[info setObject:s forKey:@"webUrl"];
		}
	}
	
	NSString *json = [info JSONRepresentation];
	if (
			(!lastJson) ||
			(![lastJson isEqual:json])) {
		
		[self logData:[json dataUsingEncoding:NSUTF8StringEncoding]];
		
		[lastJson dealloc];
		lastJson = [json retain];
	}
}


+ (NSString*)findDocUrl:(AXUIElementRef)window {
	/*
	 AXApplication
		 AXWindow: AXDocument
	 */
	
	CFTypeRef value;
	NSString *s;
	
	if (AXUIElementCopyAttributeValue(window, (CFStringRef)NSAccessibilityDocumentAttribute, &value) == kAXErrorSuccess) {
		s = (NSString*)value;
		if ([s length] > 0) {
			return s;
		}
	}
	
	return nil;
}


+ (NSString*)findWebUrl:(AXUIElementRef)window {
	/*
	 AXApplication
		 AXWindow
			 AXGroup
				 AXScrollArea
					 AXWebArea: AXURL
	 */
	
	AXUIElementRef elem;
	CFTypeRef value;
	NSString *s;
	NSArray *elems = [FrontWindowSignal
							findDescentantsOf:window
							matchingRolePath:[NSArray arrayWithObjects:@"AXGroup", @"AXScrollArea", @"AXWebArea", nil]];
	
	if ([elems count] == 1) {
		elem = (AXUIElementRef)[elems objectAtIndex:0];
		if (AXUIElementCopyAttributeValue(elem, (CFStringRef)NSAccessibilityURLAttribute, &value) == kAXErrorSuccess) {
			if (value) {
				s = [((NSURL*)value) absoluteString];
				if ([s length] > 0) {
					return s;
				}
			}
		}
	}
	return nil;
}


+ (AXUIElementRef)findMainWindowOfApp:(AXUIElementRef)appElem {
	
	/*
	 AXApplication
		AXWindow: AXMain == 1
	 */
	
	NSArray *appWindows = [FrontWindowSignal
								findDescentantsOf:appElem 
								matchingRolePath:[NSArray arrayWithObjects:@"AXWindow", nil]];
	
	AXUIElementRef elem;
	CFTypeRef value;
	for (NSObject *obj in appWindows) {
		elem = (AXUIElementRef)obj;
		if (AXUIElementCopyAttributeValue(elem, (CFStringRef)NSAccessibilityMainAttribute, &value) == kAXErrorSuccess) {
			if ([((NSNumber*)value) intValue] == 1) {
				return elem;
			}
		}
	}
	
	return nil;
}


+ (NSArray*)findDescentantsOf:(AXUIElementRef)top matchingRolePath:(NSArray*)rolePath {
	
	AXUIElementRef elem;
	CFTypeRef value;
	NSArray *children;
	NSMutableArray *result = [NSMutableArray array];
	
	if ([rolePath count] >= 1) {
		NSString *role = [rolePath objectAtIndex:0];
		if (AXUIElementCopyAttributeValue(top, (CFStringRef)NSAccessibilityChildrenAttribute, &value) == kAXErrorSuccess) {
			if (CFGetTypeID(value) == CFArrayGetTypeID()) {
				children = (NSArray*)value;
				for (NSObject *obj in children) {
					elem = (AXUIElementRef)obj;
					if (AXUIElementCopyAttributeValue(elem, (CFStringRef)NSAccessibilityRoleAttribute, &value) == kAXErrorSuccess) {
						if (value && [role isEqual:(NSString*)value]) {
							
							if ([rolePath count] == 1) {
								[result addObject:obj];
							}
							else {
								NSMutableArray *subpath = [NSMutableArray arrayWithArray:rolePath];
								[subpath removeObjectAtIndex:0];
								NSArray *subresult = [FrontWindowSignal findDescentantsOf:elem matchingRolePath:subpath];
								for (NSObject *x in subresult) {
									[result addObject:x];
								}
							}
						}
					}
				}
			}
		}
	}
	
	return result;
}


@end
