#import "RCT3DModelManager.h"
#import "RCT3DModelIO.h"

@implementation RCT3DModelManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(clearDownloadedFiles)
{
    [[RCT3DModelIO sharedInstance] clearDownloadedFiles];
}

@end
