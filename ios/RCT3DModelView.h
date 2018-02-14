#import "RCT3DModelIO.h"
#import <React/RCTView.h>
#import <SceneKit/SceneKit.h>
#import <React/RCTConvert.h>

@interface RCT3DModelView : UIView

@property (nonatomic) bool isLoading;
@property (nonatomic, copy) NSString* modelSrc;
@property (nonatomic, copy) NSString* textureSrc;
@property (nonatomic) float scale;
@property (nonatomic) bool autoPlayAnimations;
@property (nonatomic, copy) SCNNode* modelNode;
@property (nonatomic) bool isPlaying;
@property (nonatomic) float animationDuration;
@property (nonatomic) float sliderProgress;

@property (nonatomic, copy) RCTBubblingEventBlock loadModelSuccess;
@property (nonatomic, copy) RCTBubblingEventBlock loadModelError;

- (void)loadModel;
- (void)reload;
- (void)addModelNode:(SCNNode *)node;
- (void)removeNode:(SCNNode *)node;
- (void)startAnimation;
- (void)stopAnimation;
- (void)setProgress:(float)progress;
@end
