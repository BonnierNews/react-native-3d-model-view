#import <React/RCTBridge.h>

#import "RCT3DModelViewManager.h"

@implementation RCT3DModelViewManager
{
  RCT3DModelView *modelView;
}

RCT_EXPORT_MODULE()

- (UIView *)view
{
  modelView = [[RCT3DModelView alloc] init];
  return modelView;
}

RCT_EXPORT_VIEW_PROPERTY(source, NSString)
RCT_EXPORT_VIEW_PROPERTY(name, NSString)
RCT_EXPORT_VIEW_PROPERTY(type, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(color, NSNumber)

RCT_EXPORT_VIEW_PROPERTY(onLoadModelStart, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadModelSuccess, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadModelError, RCTBubblingEventBlock)

@end
