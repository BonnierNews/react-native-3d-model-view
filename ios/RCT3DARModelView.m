#import "RCT3DARModelView.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import <React/RCTConvert.h>
#import "RCT3DModel-Swift.h"

@interface RCT3DARModelView ()
@end

@implementation RCT3DARModelView
{
    ARView *_arView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
//        _sceneView = [[ARSCNView alloc] init];
//        _sceneView.backgroundColor = [UIColor clearColor];
//        _sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
//        _sceneView.autoenablesDefaultLighting = YES;
//        _sceneView.automaticallyUpdatesLighting = YES;
//        _sceneView.delegate = self;
//
//        SCNScene *scene = [SCNScene scene];
//        _sceneView.scene = scene;
//
//        ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
//        configuration.planeDetection = ARPlaneDetectionHorizontal;
//        [_sceneView.session runWithConfiguration:configuration];
//
//        [self addSubview:_sceneView];
        if (@available(iOS 11.0, *)) {
            _arView = [[ARView alloc] initWithFrame:frame];
            [self addSubview:_arView];
        }
    }
    return self;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    if (@available(iOS 11.0, *)) {
        _arView.frame = self.bounds;
    }
}

-(void) addModelNode:(SCNNode *)node {
    [super addModelNode:node];
    [_arView addVirtualObject:(VirtualObject *)node];
}

-(void) removeNode:(SCNNode *)node {
    [node removeFromParentNode];
}

@end
