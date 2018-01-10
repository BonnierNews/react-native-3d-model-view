#import "RCT3DARModelViewManager.h"

@implementation RCT3DARModelViewManager
{
  RCT3DARModelView *modelView;
}

RCT_EXPORT_MODULE()

- (UIView *)view
{
    if (@available(iOS 11.0, *)) {
        if ([ARConfiguration isSupported]) {
            modelView = [[RCT3DARModelView alloc] init];
        }
    }
    return modelView;
}

RCT_EXPORT_VIEW_PROPERTY(source, NSString)
RCT_EXPORT_VIEW_PROPERTY(name, NSString)
RCT_EXPORT_VIEW_PROPERTY(type, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(scale, float)
RCT_EXPORT_VIEW_PROPERTY(color, UIColor)

RCT_EXPORT_VIEW_PROPERTY(onLoadModelStart, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadModelSuccess, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadModelError, RCTBubblingEventBlock)

// MARK: - ARView specifics
RCT_EXPORT_VIEW_PROPERTY(focusSquareColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(focusSquareFillColor, UIColor)

RCT_EXPORT_VIEW_PROPERTY(onStart, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSurfaceFound, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSurfaceLost, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSessionInterupted, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSessionInteruptedEnded, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPlaceObjectSuccess, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPlaceObjectError, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(trackingQualityInfo, RCTBubblingEventBlock)

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

RCT_EXPORT_METHOD(getARSnapshot:(bool)saveToLibrary completion:(RCTResponseSenderBlock)callback)
{
    if (modelView) {
        [modelView takeSnapthot:saveToLibrary completion:^(NSURL *url) {
            if (url) {
                return callback(@[@[[url path]]]);
            }
            return callback(@[]);
        }];
    }
    callback(@[]);
}

@end
