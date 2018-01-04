#import "RCT3DModelView.h"

@implementation RCT3DModelView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.sceneView = [[SCNView alloc] init];
        self.sceneView.backgroundColor = [UIColor clearColor];
        SCNScene *scene = [SCNScene scene];

        self.sceneView.autoenablesDefaultLighting = YES;
        self.sceneView.allowsCameraControl = YES;
        self.sceneView.scene = scene;
        [self addSubview:self.sceneView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.sceneView.frame = self.bounds;
}

- (void)setSource:(NSString *)source
{
    if (_source == nil) {
        _source = source;
        [[RCT3DModelIO sharedInstance] loadModel:@"BMW X5 4" zipPath:source completion:^(SCNNode *node) {
            [self.sceneView.scene.rootNode addChildNode:node];
        }];
    }
}

@end
