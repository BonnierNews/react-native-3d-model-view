#import "RCT3DModelIO.h"
#import "RCT3DModelView.h"
#import <React/RCTView.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import <React/RCTConvert.h>
#import "RCT3DModel-Swift.h"

@interface RCT3DARModelView : RCT3DModelView

@property (nonatomic) bool miniature;
@property (nonatomic) float miniatureScale;
@property (nonatomic) float placeOpacity;

@property (nonatomic, copy) RCTBubblingEventBlock onStart;
@property (nonatomic, copy) RCTBubblingEventBlock onSurfaceFound;
@property (nonatomic, copy) RCTBubblingEventBlock onSurfaceLost;
@property (nonatomic, copy) RCTBubblingEventBlock onSessionInterupted;
@property (nonatomic, copy) RCTBubblingEventBlock onSessionInteruptedEnded;
@property (nonatomic, copy) RCTBubblingEventBlock onPlaceObjectSuccess;
@property (nonatomic, copy) RCTBubblingEventBlock onTrackingQualityInfo;
@property (nonatomic, copy) RCTBubblingEventBlock onTapView;
@property (nonatomic, copy) RCTBubblingEventBlock onTapObject;

- (void)restart;
- (void)takeSnapshot:(bool)saveToLibrary completion:(void (^)(BOOL success, NSURL* url))completion;

@end
