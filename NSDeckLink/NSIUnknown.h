#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFPlugInCOM.h>
//#import <CoreFoundation/CFUUID.h>
#import <DeckLinkAPI/DeckLinkAPI.h>

// typedef struct __CF

@interface NSIUnknown : NSObject
{
}

// REFIID 
// typedef CFUUIDBytes REFIID;
// typedef struct { UInt8 byte0 .. 15; } CFUUIDBytes;

//  CFTypeRef ... so close but just not compiling
//- (CFTypeRef)queryInterface:(REFIID)iid;
//- (NSIUnknown*)queryInterface:(REFIID)iid;
- (NSIUnknown*)queryInterface:(REFIID)iid;
- (REFIID)iunknownType;
- (NSString *)iunknownTypeString;
- (NSString *)description;

//error:(NSError**)error;
// - (void*)queryInterfaceWithREFIIDString:(NSString*)string error:(NSError**)error;
- (void)release;
- (NSUInteger)retainCount;
- (id)retain;

@end
