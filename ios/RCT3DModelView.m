#import "RCT3DModelView.h"
#import <SceneKit/SceneKit.h>
#import <React/RCTConvert.h>

@implementation RCT3DModelView
{
    SCNView *_sceneView;
    bool _isLoaded;
    NSString *_source;
    NSString *_name;
    NSInteger *_type;
    UIColor *_color;
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
        
        _isLoaded = NO;
    }
    return self;
}

-(void) didMoveToWindow {
    [super didMoveToWindow];
    [self loadModel];
}

-(void) layoutSubviews {
    [super layoutSubviews];
    _sceneView.frame = self.bounds;
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
            [_sceneView.scene.rootNode addChildNode:node];
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

- (void)setSource:(NSString *)source
{
    _source = source;
}

- (void)setName:(NSString *)name
{
    _name = name;
}

- (void)setType:(NSInteger *)type
{
    _type = type;
}

- (void)setColor:(NSNumber*)color
{
    _color = [RCTConvert UIColor:color];
}

@end
