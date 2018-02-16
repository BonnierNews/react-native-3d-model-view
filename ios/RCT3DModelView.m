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
                if (self.onLoadModelSuccess) {
                    self.onLoadModelSuccess(@{});
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.onLoadModelError) {
                    self.onLoadModelError(@{});
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
}

- (void)removeNode:(SCNNode *)node {
    _modelNode = nil;
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

-(void) startAnimation {
}

-(void) stopAnimation {
}

-(void) setProgress:(float)progress {
}

@end
