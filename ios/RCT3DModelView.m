#import "RCT3DModelView.h"

@implementation RCT3DModelView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.isLoading = NO;
    }
    return self;
}

- (void) didMoveToWindow {
    [super didMoveToWindow];
    [self loadModel];
}

- (void)loadModel {
    if (self.isLoading || self.source == nil || self.type == nil) {
        return;
    }
    if (self.onLoadModelStart) {
        self.onLoadModelStart(@{});
    }
    self.isLoading = YES;
    NSLog(@"%@", self.source);
    [[RCT3DModelIO sharedInstance] loadModel:self.source type:(ModelType)self.type color:self.color completion:^(SCNNode *node) {
        if (node != nil) {
            self.isLoading = NO;
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

- (void)addModelNode:(SCNNode *)node {
    if (_modelNode != nil) {
        [self removeNode:_modelNode];
    }
    _modelNode = node;
}

- (void)removeNode:(SCNNode *)node {
    _modelNode = nil;
}

- (void)reload {
    [self removeNode:_modelNode];
    [self loadModel];
}

- (void)setSource:(NSString *)source {
    if (source == nil && _modelNode != nil) {
        [self removeNode:_modelNode];
    }
    _source = source;
    [self loadModel];
}

- (void)setType:(int *)type {
    _type = type;
    [self loadModel];
}

- (void)setScale:(float)scale {
    _scale = scale;
    [self loadModel];
}

- (void)setColor:(UIColor*)color {
    _color = color;
    [self loadModel];
}

@end
