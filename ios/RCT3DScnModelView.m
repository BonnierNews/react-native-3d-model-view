#import "RCT3DScnModelView.h"

@implementation RCT3DScnModelView
{
    SCNView *_sceneView;
    float _sliderProgress;
    float _lastSceneTime;
    float _sceneTime;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _sceneTime = 0;
        _sliderProgress = 0;
        
        _sceneView = [[SCNView alloc] init];
        _sceneView.backgroundColor = [UIColor clearColor];
        SCNScene *scene = [SCNScene scene];
        SCNNode *ambientLightNode = [SCNNode new];
        ambientLightNode.light = [SCNLight new];
        ambientLightNode.light.type = SCNLightTypeAmbient;
        ambientLightNode.light.color = [UIColor colorWithWhite:0.67 alpha:1.0];
        ambientLightNode.castsShadow = YES;
        [_sceneView.scene.rootNode addChildNode:ambientLightNode];
        
        SCNNode *spotLightNode = [SCNNode new];
        spotLightNode.light = [SCNLight light];
        spotLightNode.light.type = SCNLightTypeSpot;
        spotLightNode.light.spotInnerAngle = 0;
        spotLightNode.light.spotOuterAngle = 45;
        spotLightNode.light.shadowRadius = 10.0;
        spotLightNode.light.zFar = 10000;
        spotLightNode.light.shadowColor = [UIColor colorWithRed: 0.0 green: 1.0 blue:0.0 alpha: 1.0];
        spotLightNode.castsShadow = YES;
        spotLightNode.position = SCNVector3Make(100, 100, 170);
        _sceneView.allowsCameraControl = YES;
        _sceneView.scene = scene;
        _sceneView.delegate = self;
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupAnimations];
        if (self.autoPlayAnimations) {
            [self startAnimation];
        } else {
            [self stopAnimation];
        }
        [_sceneView.scene.rootNode addChildNode:node];
    });
}

-(void) removeNode:(SCNNode *)node {
    [super removeNode:node];
    [node removeFromParentNode];
}

-(void) setScale:(float)scale {
    [super setScale:scale];
    [_sceneView.scene.rootNode setScale:SCNVector3Make(scale, scale, scale)];
}

- (void) startAnimation {
    _sceneView.playing = true;
    _lastSceneTime = CACurrentMediaTime();
    if (self.onAnimationStart) {
        self.onAnimationStart(@{});
    }
}

- (void) stopAnimation {
    _sceneView.playing = false;
    if (self.onAnimationStop) {
        self.onAnimationStop(@{});
    }
}

-(void) setProgress:(float)progress {
    _sliderProgress = progress;
    [self stopAnimation];
    _sceneTime = progress * self.animationDuration;
    _sceneView.sceneTime = _sceneTime;
    if (self.onAnimationUpdate) {
        self.onAnimationUpdate(@{@"progress":[NSNumber numberWithFloat:fmod(_sceneTime, self.animationDuration) / self.animationDuration]});
    }
}

-(void) renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time {
    if (_sceneView.isPlaying) {
        _sceneTime += (time - _lastSceneTime);
        _lastSceneTime = time;
        _sceneView.sceneTime = _sceneTime;
        if (self.onAnimationUpdate) {
            NSNumber *progress = [NSNumber numberWithFloat:fmod(_sceneTime, self.animationDuration) / self.animationDuration];
            self.onAnimationUpdate(@{@"progress":progress});
        }
    }
}

@end
