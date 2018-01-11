#import "RCT3DScnModelViewManager.h"

@implementation RCT3DScnModelViewManager
{
  RCT3DScnModelView *modelView;
}

RCT_EXPORT_MODULE()

- (UIView *)view
{
  modelView = [[RCT3DScnModelView alloc] init];
  return modelView;
}

RCT_EXPORT_VIEW_PROPERTY(source, NSString)
RCT_EXPORT_VIEW_PROPERTY(type, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(scale, float)
RCT_EXPORT_VIEW_PROPERTY(color, UIColor)

RCT_EXPORT_VIEW_PROPERTY(onLoadModelStart, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadModelSuccess, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadModelError, RCTBubblingEventBlock)

RCT_EXPORT_METHOD(clearDownloadedFiles)
{
    [[RCT3DModelIO sharedInstance] clearDownloadedFiles];
}
@end
