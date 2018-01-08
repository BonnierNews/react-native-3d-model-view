#import "RCT3DARModelView.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import <React/RCTConvert.h>

@interface RCT3DARModelView () <ARSCNViewDelegate, ARSessionDelegate>
@end

@implementation RCT3DARModelView
{
    ARSCNView *_sceneView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _sceneView = [[ARSCNView alloc] init];
        _sceneView.backgroundColor = [UIColor clearColor];
        _sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
        _sceneView.autoenablesDefaultLighting = YES;
        _sceneView.automaticallyUpdatesLighting = YES;
        _sceneView.delegate = self;
        
        SCNScene *scene = [SCNScene scene];
        _sceneView.scene = scene;
        
        ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
        configuration.planeDetection = ARPlaneDetectionHorizontal;
        [_sceneView.session runWithConfiguration:configuration];
        
        [self addSubview:_sceneView];
    }
    return self;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    _sceneView.frame = self.bounds;
}

-(void) addModelNode:(SCNNode *)node {
    [super addModelNode:node];
    [_sceneView.scene.rootNode addChildNode:node];
}

-(void) removeNode:(SCNNode *)node {
    [node removeFromParentNode];
}


//
// ARSCNViewDelegate, ARSessionDelegate
//

-(void) renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time {
//    DispatchQueue.main.async {
//        self.virtualObjectInteraction.updateObjectToCurrentTrackingPosition()
//        self.updateFocusSquare()
//    }
    
    double baseIntensity = 40;
    SCNMaterialProperty *lightningEnvironment = _sceneView.scene.lightingEnvironment;
    if (_sceneView.session.currentFrame.lightEstimate != nil) {
        lightningEnvironment.intensity = _sceneView.session.currentFrame.lightEstimate.ambientIntensity / baseIntensity;
    } else {
        lightningEnvironment.intensity = baseIntensity;
    }
}



@end
