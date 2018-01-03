#import "RCT3DModelView.h"

@implementation RCT3DModelView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.sceneView = [[SCNView alloc] init];
        self.sceneView.backgroundColor = [UIColor clearColor];
        SCNScene *scene = [SCNScene scene];

        SCNCone *boxGeometry = [SCNBox boxWithWidth:5 height:5 length:5 chamferRadius:0];
        SCNNode *boxNode = [SCNNode nodeWithGeometry:boxGeometry];
        [scene.rootNode addChildNode:boxNode];
        self.sceneView.autoenablesDefaultLighting = YES;
        self.sceneView.allowsCameraControl = YES;
        self.backgroundColor = [UIColor greenColor];
        self.sceneView.scene = scene;
        [self addSubview:self.sceneView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.sceneView.frame = self.bounds;
    NSLog(@"%@", NSStringFromCGRect(self.bounds));
}

@end
