#import "RCT3DARModelView.h"

@interface RCT3DARModelView () <ARViewDelegate>
@end

@implementation RCT3DARModelView
{
    ARView *_arView;
    bool _hasSurface;
    bool _modelIsAddedToScene;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        if (@available(iOS 11.0, *)) {
            _hasSurface = false;
            _modelIsAddedToScene = false;
            _arView = [[ARView alloc] initWithFrame:frame];
            _arView.delegate = self;
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
    [self addScaleToModelNode];
    if (_hasSurface && !_modelIsAddedToScene) {
        [_arView addVirtualObject:node];
        _modelIsAddedToScene = YES;
    }
}

-(void) removeNode:(SCNNode *)node {
    [super removeNode:node];
    [node removeFromParentNode];
}

-(void) setFocusSquareColor:(UIColor*)color {
    [[_arView focusSquare] setColorWithPrimary:color fill:nil];
}

-(void) setFocusSquareFillColor:(UIColor*)color {
    [[_arView focusSquare] setColorWithPrimary:nil fill:color];
}

-(void) setScale:(float)scale {
    [super setScale:scale];
    [self addScaleToModelNode];
}

-(void) addScaleToModelNode {
    if (self.scale && self.modelNode) {
        SCNVector3 scaleV = SCNVector3Make(self.scale, self.scale, self.scale);
        for(SCNNode *child in self.modelNode.childNodes) {
            [child setScale:scaleV];
        }
    }
}

-(void) restart {
    _modelIsAddedToScene = NO;
    [self removeNode:self.modelNode];
    [_arView restartExperience];
    [self loadModel];
}

-(void) takeSnapshot:(bool)saveToLibrary completion:(void (^)(BOOL success, NSURL *))completion {
    [_arView snapshotWithSaveToPhotoLibrary:saveToLibrary completion:completion];
}

-(SCNView*) getScnView {
    return _arView.sceneView;
}

// MARK: - ARViewDelegate
-(void) start {
    if (self.onStart) {
        self.onStart(@{});
    }
}

-(void) surfaceFound {
    _hasSurface = YES;
    if (self.modelNode && !_modelIsAddedToScene) {
        [_arView addVirtualObject:self.modelNode];
        _modelIsAddedToScene = YES;
    }
    if (self.onSurfaceFound) {
        self.onSurfaceFound(@{});
    }
}

-(void) surfaceLost {
    _hasSurface = NO;
    if (self.onSurfaceLost) {
        self.onSurfaceLost(@{});
    }
}

-(void) sessionInterupted {
    if (self.onSessionInterupted) {
        self.onSessionInterupted(@{});
    }
}

-(void) sessionInteruptedEnded {
    if (self.onSessionInteruptedEnded) {
        self.onSessionInteruptedEnded(@{});
    }
}

-(void) trackingQualityInfoWithId:(NSInteger)id presentation:(NSString*)presentation recommendation:(NSString*)recommendation {
    if (self.onTrackingQualityInfo) {
        self.onTrackingQualityInfo(@{@"id": [NSNumber numberWithInteger:id], @"presentation": presentation, @"recommendation": recommendation});
    }
}

-(void) placeObjectSuccess {
    if (self.onPlaceObjectSuccess) {
        self.onPlaceObjectSuccess(@{});
    }
}

-(void) placeObjectError {
    if (self.onPlaceObjectError) {
        self.onPlaceObjectError(@{});
    }
}

@end
