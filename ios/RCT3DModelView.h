#import "RCT3DModelIO.h"
#import <React/RCTView.h>
#import <SceneKit/SceneKit.h>
#import <React/RCTConvert.h>

@interface RCT3DModelView : UIView<SCNSceneRendererDelegate>

@property (nonatomic) bool isLoading;
@property (nonatomic, copy) NSString* modelSrc;
@property (nonatomic, copy) NSString* textureSrc;
@property (nonatomic) float scale;
@property (nonatomic) bool autoPlayAnimations;
@property (nonatomic, copy) SCNNode* modelNode;
@property (nonatomic) float animationDuration;

@property (nonatomic, copy) RCTBubblingEventBlock onLoadModelSuccess;
@property (nonatomic, copy) RCTBubblingEventBlock onLoadModelError;
@property (nonatomic, copy) RCTBubblingEventBlock onAnimationStart;
@property (nonatomic, copy) RCTBubblingEventBlock onAnimationStop;
@property (nonatomic, copy) RCTBubblingEventBlock onAnimationUpdate;

- (void)loadModel;
- (void)addModelNode:(SCNNode *)node;
- (void)removeNode:(SCNNode *)node;
- (void)setupAnimations;
- (void)startAnimation;
- (void)stopAnimation;
- (void)setProgress:(float)progress;
@end
