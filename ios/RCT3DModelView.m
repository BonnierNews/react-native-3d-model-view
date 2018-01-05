#import "RCT3DModelView.h"

@implementation RCT3DModelView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.sceneView = [[SCNView alloc] init];
        self.sceneView.backgroundColor = [UIColor clearColor];
        SCNScene *scene = [SCNScene scene];

        SCNNode *ambientLightNode = [SCNNode new];
        ambientLightNode.light = [SCNLight new];
        ambientLightNode.light.type = SCNLightTypeAmbient;
        ambientLightNode.light.color = [UIColor colorWithWhite:0.67 alpha:1.0];
        [self.sceneView.scene.rootNode addChildNode:ambientLightNode];
        self.sceneView.allowsCameraControl = YES;
        self.sceneView.scene = scene;
        [self addSubview:self.sceneView];
        
        self.isLoaded = NO;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.sceneView.frame = self.bounds;
}

-(void)loadModel {
    if (self.isLoaded || self.name == nil || self.source == nil || self.type == nil) {
        return;
    }
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"/art.scnassets/Jonas_1.scn" withExtension:nil];
//    NSError *error;
//    SCNScene *scene = [SCNScene sceneWithURL:url options:nil error:&error];
//    SCNNode *object = [SCNNode new];
//    for (SCNNode *child in scene.rootNode.childNodes) {
//        [object addChildNode:child];
//        NSLog(@"%@", child.geometry.materials.firstObject.diffuse.contents);
//    }
//    [self.sceneView.scene.rootNode addChildNode:object];
    [[RCT3DModelIO sharedInstance] loadModel:self.source name:self.name type:(ModelType)self.type completion:^(SCNNode *node) {
        self.isLoaded = YES;
        [self.sceneView.scene.rootNode addChildNode:node];
    }];
}

- (void)setSource:(NSString *)source
{
    _source = source;
    [self loadModel];
}

- (void)setName:(NSString *)name
{
    _name = name;
    [self loadModel];
}

- (void)setType:(NSInteger *)type
{
    _type = type;
    [self loadModel];
}

@end
