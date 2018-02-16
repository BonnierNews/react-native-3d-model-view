#import "RCT3DARModelView.h"

@interface RCT3DARModelView () <ARViewDelegate>
@end

@implementation RCT3DARModelView
{
    ARView *_arView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        if (@available(iOS 11.0, *)) {
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupAnimations];
        if (self.autoPlayAnimations) {
            [self startAnimation];
        } else {
            [self stopAnimation];
        }
        self.modelNode = [_arView addVirtualObject:self.modelNode];
    });
}

-(void) removeNode:(SCNNode *)node {
    [super removeNode:node];
    [node removeFromParentNode];
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
    [_arView restartExperience];
}

-(void) takeSnapshot:(bool)saveToLibrary completion:(void (^)(BOOL success, NSURL *))completion {
    [_arView snapshotWithSaveToPhotoLibrary:saveToLibrary completion:completion];
}

-(void) startAnimation {
    [_arView startAnimation];
    if (self.onAnimationStart) {
        self.onAnimationStart(@{});
    }
}

-(void) stopAnimation {
    [_arView stopAnimation];
    if (self.onAnimationStop) {
        self.onAnimationStop(@{});
    }
}

-(void) setProgress:(float)progress {
}

// MARK: - ARViewDelegate
-(void) start {
    if (self.onStart) {
        self.onStart(@{});
    }
}

-(void) surfaceFound {
    if (self.onSurfaceFound) {
        self.onSurfaceFound(@{});
    }
}

-(void) surfaceLost {
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
