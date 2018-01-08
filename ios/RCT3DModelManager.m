#import "RCT3DModelManager.h"
#import "RCT3DModelIO.h"
#import <ARKit/ARKit.h>

@implementation RCT3DModelManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(clearDownloadedFiles)
{
    [[RCT3DModelIO sharedInstance] clearDownloadedFiles];
}

RCT_EXPORT_METHOD(checkIfARSupported:(RCTResponseSenderBlock)callback)
{
    BOOL isSupported = NO;
    if (@available(iOS 11.0, *)) {
        isSupported = [ARConfiguration isSupported];
    }
    callback(@[@(isSupported)]);
}

@end
