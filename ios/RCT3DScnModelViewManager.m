#import "RCT3DScnModelViewManager.h"

@implementation RCT3DScnModelViewManager

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;

- (UIView *)view {
    return [[RCT3DScnModelView alloc] init];
}

- (dispatch_queue_t)methodQueue {
    return _bridge.uiManager.methodQueue;
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

RCT_EXPORT_METHOD(startAnimation:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        RCT3DScnModelView *modelView = (RCT3DScnModelView*)viewRegistry[reactTag];
        if ([modelView isKindOfClass:[RCT3DScnModelView class]]) {
            [modelView startAnimation];
        } else {
            RCTLogError(@"Cannot startAnimation: %@ (tag #%@) is not RCT3DScnModelView", modelView, reactTag);
        }
    }];
}

RCT_EXPORT_METHOD(stopAnimation:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        RCT3DScnModelView *modelView = (RCT3DScnModelView*)viewRegistry[reactTag];
        if ([modelView isKindOfClass:[RCT3DScnModelView class]]) {
            [modelView stopAnimation];
        } else {
            RCTLogError(@"Cannot stopAnimation: %@ (tag #%@) is not RCT3DScnModelView", modelView, reactTag);
        }
    }];
}

RCT_EXPORT_METHOD(setProgress:(nonnull NSNumber *)reactTag progress:(float)progress)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        RCT3DScnModelView *modelView = (RCT3DScnModelView*)viewRegistry[reactTag];
        if ([modelView isKindOfClass:[RCT3DScnModelView class]]) {
            [modelView setProgress:progress];
        } else {
            RCTLogError(@"Cannot setProgress: %@ (tag #%@) is not RCT3DScnModelView", modelView, reactTag);
        }
    }];
}
@end
