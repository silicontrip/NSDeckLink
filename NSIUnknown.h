#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFPlugInCOM.h>
#import <CoreFoundation/CFUUID.h>

@interface NSIUnknown : NSObject
{

}

// REFIID 
// typedef CFUUIDBytes REFIID;
// typedef struct { UInt8 byte0 .. 15; } CFUUIDBytes;

- (void*)queryInterface:(REFIID)iid error:(NSError**)error;
// - (void*)queryInterfaceWithREFIIDString:(NSString*)string error:(NSError**)error;
- (void)release;
- (NSUInteger)retainCount;
- (id)retain;

@end