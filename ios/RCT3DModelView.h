#import "RCT3DModelIO.h"
#import <React/RCTView.h>
#import <SceneKit/SceneKit.h>
#import <React/RCTConvert.h>

@interface RCT3DModelView : UIView

@property (nonatomic) bool isLoaded;
@property (nonatomic, copy) NSString* source;
@property (nonatomic) int* type;
@property (nonatomic) float scale;
@property (nonatomic, copy) UIColor* color;
@property (nonatomic, copy) SCNNode* modelNode;

@property (nonatomic, copy) RCTBubblingEventBlock onLoadModelStart;
@property (nonatomic, copy) RCTBubblingEventBlock onLoadModelSuccess;
@property (nonatomic, copy) RCTBubblingEventBlock onLoadModelError;

- (void)addModelNode:(SCNNode *)node;
- (void)removeNode:(SCNNode *)node;
@end
