#import "RCT3DModelView.h"
#import <SceneKit/SceneKit.h>
#import <React/RCTConvert.h>

@implementation RCT3DModelView
{
    bool _isLoaded;
    NSString *_source;
    NSString *_name;
    NSInteger *_type;
    UIColor *_color;
    SCNNode *_modelNode;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _isLoaded = NO;
    }
    return self;
}

-(void) didMoveToWindow {
    [super didMoveToWindow];
    [self loadModel];
}

-(void)loadModel {
    if (_isLoaded || _name == nil || _source == nil || _type == nil) {
        return;
    }
    if (self.onLoadModelStart) {
        self.onLoadModelStart(@{});
    }
    [[RCT3DModelIO sharedInstance] loadModel:_source name:_name type:(ModelType)_type color:_color completion:^(SCNNode *node) {
        if (node != nil) {
            _isLoaded = YES;
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
}

- (void)setSource:(NSString *)source {
    _source = source;
}

- (void)setName:(NSString *)name {
    _name = name;
}

- (void)setType:(NSInteger *)type {
    _type = type;
}

- (void)setColor:(NSNumber*)color {
    _color = [RCTConvert UIColor:color];
}

@end
