#import "RCT3DModelView.h"

@implementation RCT3DModelView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.isLoading = NO;
        self.scale = 1.0;
    }
    return self;
}

- (void)loadModel {
    if (self.isLoading || self.modelSrc == nil || self.textureSrc == nil) {
        return;
    }

    self.isLoading = YES;
    [[RCT3DModelIO sharedInstance] loadModel:self.modelSrc textureSrc:self.textureSrc completion:^(SCNNode *node) {
        if (node != nil) {
            self.isLoading = NO;
            [self addModelNode:node];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.loadModelSuccess) {
                    self.loadModelSuccess(@{});
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.loadModelError) {
                    self.loadModelError(@{});
                }
            });
        }
    }];
}

- (void)addModelNode:(SCNNode *)node {
    if (_modelNode != nil) {
        [self removeNode:_modelNode];
    }
    _modelNode.scale = SCNVector3Make(_scale, _scale, _scale);
    _modelNode = node;
    if (!_autoPlayAnimations) {
        [self stopAnimation];
    }
}

- (void)removeNode:(SCNNode *)node {
    _modelNode = nil;
}

- (void)reload {
    [self removeNode:_modelNode];
    [self loadModel];
}

- (void)setModelSrc:(NSString *)modelSrc {
    if (modelSrc == nil && _modelNode != nil) {
        [self removeNode:_modelNode];
    }
    _modelSrc = modelSrc;
    [self loadModel];
}

- (void)setTextureSrc:(NSString *)textureSrc {
    if (textureSrc == nil && _modelNode != nil) {
        [self removeNode:_modelNode];
    }
    _textureSrc = textureSrc;
    [self loadModel];
}

- (void)setScale:(float)scale {
    _scale = scale;
}

- (NSMutableArray*) getAnimatedNodes:(SCNNode*)parent result:(NSMutableArray *)result {
    if (parent.childNodes.count == 0) {
        return result;
    }
    for (SCNNode * child in parent.childNodes) {
        if(child.animationKeys.count > 0) {
            [result addObject:child];
        }
        [self getAnimatedNodes:child result:result];
    }
    return result;
}

- (void) startAnimation {
    NSMutableArray* animatedNodes = [self getAnimatedNodes:_modelNode result:[[NSMutableArray alloc] init]];
    for (SCNNode *node in animatedNodes) {
        for (NSString *key in node.animationKeys) {
            CAAnimation *animation = [node animationForKey:key];
            [animation setSpeed:1];
            [node addAnimation:animation forKey:key];
        }
    }
}

- (void) stopAnimation {
    NSMutableArray* animatedNodes = [self getAnimatedNodes:_modelNode result:[[NSMutableArray alloc] init]];
    for (SCNNode *node in animatedNodes) {
        for (NSString *key in node.animationKeys) {
            CAAnimation *animation = [node animationForKey:key];
            [animation setSpeed:0];
            [node addAnimation:animation forKey:key];
        }
    }
}

- (void) setProgress:(float)progress {
    NSMutableArray* animatedNodes = [self getAnimatedNodes:_modelNode result:[[NSMutableArray alloc] init]];
    for (SCNNode *node in animatedNodes) {
        for (NSString *key in node.animationKeys) {
            CAAnimation *animation = [node animationForKey:key];
            [animation setTimeOffset:progress * animation.duration];
            [node addAnimation:animation forKey:key];
        }
    }
}

@end
