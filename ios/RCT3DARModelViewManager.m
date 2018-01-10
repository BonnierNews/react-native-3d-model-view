#import "RCT3DARModelViewManager.h"

@implementation RCT3DARModelViewManager
{
  RCT3DARModelView *modelView;
}

RCT_EXPORT_MODULE()

- (UIView *)view
{
  modelView = [[RCT3DARModelView alloc] init];
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

@end
