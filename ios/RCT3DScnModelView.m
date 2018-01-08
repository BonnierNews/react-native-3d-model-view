#import "RCT3DScnModelView.h"
#import <SceneKit/SceneKit.h>
#import <React/RCTConvert.h>

@implementation RCT3DScnModelView
{
    SCNView *_sceneView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _sceneView = [[SCNView alloc] init];
        _sceneView.backgroundColor = [UIColor clearColor];
        SCNScene *scene = [SCNScene scene];

        SCNNode *ambientLightNode = [SCNNode new];
        ambientLightNode.light = [SCNLight new];
        ambientLightNode.light.type = SCNLightTypeAmbient;
        ambientLightNode.light.color = [UIColor colorWithWhite:0.67 alpha:1.0];
        [_sceneView.scene.rootNode addChildNode:ambientLightNode];
        _sceneView.allowsCameraControl = YES;
        _sceneView.scene = scene;
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

@end
