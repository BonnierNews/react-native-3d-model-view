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

RCT_EXPORT_VIEW_PROPERTY(modelSrc, NSString)
RCT_EXPORT_VIEW_PROPERTY(textureSrc, NSString)
RCT_EXPORT_VIEW_PROPERTY(scale, float)
RCT_EXPORT_VIEW_PROPERTY(autoPlayAnimations, BOOL)

RCT_EXPORT_VIEW_PROPERTY(onLoadModelSuccess, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadModelError, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAnimationStart, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAnimationStop, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAnimationUpdate, RCTBubblingEventBlock)

RCT_EXPORT_METHOD(startAnimation)
{
    if (modelView) {
        [modelView startAnimation];
    }
}

RCT_EXPORT_METHOD(stopAnimation)
{
    if (modelView) {
        [modelView stopAnimation];
    }
}

RCT_EXPORT_METHOD(setProgress:(float)progress)
{
    if (modelView) {
        [modelView setProgress:progress];
    }
}
@end
