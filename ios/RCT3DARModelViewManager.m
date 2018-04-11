#import "RCT3DARModelViewManager.h"

@implementation RCT3DARModelViewManager

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;

- (UIView *)view {
    if (@available(iOS 11.0, *)) {
        if ([ARConfiguration isSupported]) {
            return [[RCT3DARModelView alloc] init];
        }
    }
    return nil;
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

// MARK: - ARView specifics
RCT_EXPORT_VIEW_PROPERTY(miniature, BOOL)
RCT_EXPORT_VIEW_PROPERTY(miniatureScale, float)
RCT_EXPORT_VIEW_PROPERTY(placeOpacity, float)

RCT_EXPORT_VIEW_PROPERTY(onStart, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSurfaceFound, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSurfaceLost, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSessionInterupted, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSessionInteruptedEnded, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPlaceObjectSuccess, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTrackingQualityInfo, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTapView, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTapObject, RCTBubblingEventBlock)

RCT_EXPORT_METHOD(startAnimation:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        RCT3DARModelView *modelView = (RCT3DARModelView*)viewRegistry[reactTag];
        if ([modelView isKindOfClass:[RCT3DARModelView class]]) {
            [modelView startAnimation];
        } else {
            RCTLogError(@"Cannot startAnimation: %@ (tag #%@) is not RCT3DARModelView", modelView, reactTag);
        }
    }];
}

RCT_EXPORT_METHOD(stopAnimation:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        RCT3DARModelView *modelView = (RCT3DARModelView*)viewRegistry[reactTag];
        if ([modelView isKindOfClass:[RCT3DARModelView class]]) {
            [modelView stopAnimation];
        } else {
            RCTLogError(@"Cannot stopAnimation: %@ (tag #%@) is not RCT3DARModelView", modelView, reactTag);
        }
    }];
}

RCT_EXPORT_METHOD(setProgress:(nonnull NSNumber *)reactTag progress:(float)progress)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        RCT3DARModelView *modelView = (RCT3DARModelView*)viewRegistry[reactTag];
        if ([modelView isKindOfClass:[RCT3DARModelView class]]) {
            [modelView setProgress:progress];
        } else {
            RCTLogError(@"Cannot setProgress: %@ (tag #%@) is not RCT3DARModelView", modelView, reactTag);
        }
    }];
}

RCT_EXPORT_METHOD(checkIfARSupported:(RCTResponseSenderBlock)callback)
{
    BOOL isSupported = NO;
    if (@available(iOS 11.0, *)) {
        isSupported = [ARConfiguration isSupported];
    }
    callback(@[@(isSupported)]);
}

RCT_EXPORT_METHOD(restart:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        RCT3DARModelView *modelView = (RCT3DARModelView*)viewRegistry[reactTag];
        if ([modelView isKindOfClass:[RCT3DARModelView class]]) {
            [modelView restart];
        } else {
            RCTLogError(@"Cannot restart: %@ (tag #%@) is not RCT3DARModelView", modelView, reactTag);
        }
    }];
}

RCT_EXPORT_METHOD(getSnapshot:(nonnull NSNumber *)reactTag saveToLibrary:(BOOL)saveToLibrary
                 findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        RCT3DARModelView *modelView = (RCT3DARModelView*)viewRegistry[reactTag];
        if ([modelView isKindOfClass:[RCT3DARModelView class]]) {
            [modelView takeSnapshot:saveToLibrary completion:^(BOOL success, NSURL *url) {
                if (success) {
                    if (saveToLibrary) {
                        resolve(@{@"success":@YES});
                    } else {
                        resolve(@{@"success":@YES, @"url": [url path]});
                    }
                } else {
                    reject(RCTErrorUnspecified, nil, RCTErrorWithMessage(@"RCT3DModelView: Could not save image"));
                }
            }];
        } else {
            RCTLogError(@"Cannot getSnapshot: %@ (tag #%@) is not RCT3DARModelView", modelView, reactTag);
            reject(RCTErrorUnspecified, nil, RCTErrorWithMessage(@"RCT3DModelView: View is not RCT3DARModelView"));
        }
    }];
}

@end
