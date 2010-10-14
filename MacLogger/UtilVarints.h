
#import <Cocoa/Cocoa.h>


@interface UtilVarints : NSObject {
	
}


+ (NSData*)encodeUnsignedFromNumber:(NSNumber*)n;
+ (NSData*)encodeUnsignedFromUnsignedLongLong:(unsigned long long)x;


@end