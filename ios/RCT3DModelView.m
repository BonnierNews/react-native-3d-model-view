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
    if (self.isLoading || self.src == nil || self.type == nil) {
        return;
    }
    self.isLoading = YES;
    NSLog(@"%@", self.src);
    [[RCT3DModelIO sharedInstance] loadModel:self.src type:(ModelType)self.type color:self.color completion:^(SCNNode *node) {
        if (node != nil) {
            self.isLoading = NO;
            [self addModelNode:node];
            if (self.loadModelSuccess) {
                self.loadModelSuccess(@{});
            }
        } else {
            if (self.loadModelError) {
                self.loadModelError(@{});
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

- (void)setSrc:(NSString *)src {
    if (src == nil && _modelNode != nil) {
        [self removeNode:_modelNode];
    }
    _src = src;
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
