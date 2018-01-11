#import "RCT3DModelView.h"

@implementation RCT3DModelView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.isLoaded = NO;
    }
    return self;
}

-(void) didMoveToWindow {
    [super didMoveToWindow];
    [self loadModel];
}

-(void)loadModel {
    if (self.isLoaded || self.source == nil || self.type == nil) {
        return;
    }
    if (self.onLoadModelStart) {
        self.onLoadModelStart(@{});
    }
    [[RCT3DModelIO sharedInstance] loadModel:self.source type:(ModelType)self.type color:self.color completion:^(SCNNode *node) {
        if (node != nil) {
            self.isLoaded = YES;
            [self addModelNode:node];
            if (self.onLoadModelSuccess) {
                self.onLoadModelSuccess(@{});
            }
        } else {
            if (self.onLoadModelError) {
                self.onLoadModelError(@{});
            }
        }
    }];
}

-(void)addModelNode:(SCNNode *)node {
    if (_modelNode != nil) {
        [self removeNode:_modelNode];
    }
    _modelNode = node;
}

-(void)removeNode:(SCNNode *)node {
    _isLoaded = NO;
    _modelNode = nil;
}

- (void)setSource:(NSString *)source {
    if (source == nil && _modelNode != nil) {
        [self removeNode:_modelNode];
    }
    _source = source;
}

- (void)setType:(int *)type {
    _type = type;
}

- (void)setScale:(float)scale {
    _scale = scale;
}

- (void)setColor:(UIColor*)color {
    _color = color;
}

@end
