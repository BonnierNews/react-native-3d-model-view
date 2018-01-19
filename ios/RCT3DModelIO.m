#import "RCT3DModelIO.h"

@implementation RCT3DModelIO

+ (instancetype)sharedInstance {
    static RCT3DModelIO *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (instancetype)init {
    if ((self = [super init])) {
    }
    return self;
}


- (void)loadModel:(NSString *)path type:(ModelType)type color:(UIColor *)color completion:(void (^)(SCNNode * node))completion {
    NSURL *url = [self urlFromPath:path];
    NSLog(@"%@", [url path]);
    completion([self createModel:url type:type color:color]);
}

- (NSURL *)urlFromPath:(NSString *)path {
    NSURL *url;
    
    if ([path hasPrefix: @"/"]) {
        url = [NSURL fileURLWithPath: path];
    } else if ([path hasPrefix: @"http"]) {
        url = [NSURL URLWithString:path];
    } else {
        url = [[NSBundle mainBundle] URLForResource:path withExtension:nil];
    }
    
    return url;
}

-(SCNNode *)createModel:(NSURL*)url type:(ModelType)type color:(UIColor *)color  {
    NSLog(@"[RCT3dModel]: Loading model at %@", url);
    SCNNode* node;
    switch (type) {
        case ModelTypeSCN:
            node = [self createScnModel:url color:color];
            break;
        case ModelTypeOBJ:
            node = [self createObjModel:url color:color];
            break;
        default:
            break;
    }
    return node;
}

-(SCNNode *)createScnModel:(NSURL *)url color:(UIColor *)color {
    NSError* error;
    NSURL *modelUrl = url;
    if (![[modelUrl path] hasSuffix:@".scn"]) {
        NSString *objName = [NSString stringWithFormat:@"%@.scn", [modelUrl lastPathComponent]];
        modelUrl = [url URLByAppendingPathComponent:objName];
    }
    SCNScene *scene = [SCNScene sceneWithURL:modelUrl options:nil error:&error];
    if(error) {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }

    SCNNode *node = [[SCNNode alloc] init];
    NSArray *nodeArray = [scene.rootNode childNodes];
    SCNMaterial *material;
    if (color != nil) {
        material = [SCNMaterial material];
        material.diffuse.contents = color;
    }
    for (SCNNode *eachChild in nodeArray) {
        if (material != nil) {
            eachChild.geometry.materials = [NSArray arrayWithObject:material];
        }
        [node addChildNode:eachChild];
    }
    return node;
}

-(SCNNode *)createObjModel:(NSURL *)url color:(UIColor *)color {
    NSURL *textureUrl;
    NSURL *modelUrl = url;
    if (![[modelUrl path] hasSuffix:@".obj"]) {
        NSString *name = [modelUrl lastPathComponent];
        NSString *objName = [NSString stringWithFormat:@"%@.obj", name];
        modelUrl = [url URLByAppendingPathComponent:objName];
        NSString *textureName = [NSString stringWithFormat:@"%@.png", name];
        textureUrl = [url URLByAppendingPathComponent:textureName];
    }
    MDLAsset *asset = [[MDLAsset alloc] initWithURL:modelUrl];
    if (asset.count == 0) {
        return nil;
    }
    MDLMesh* object = (MDLMesh *)[asset objectAtIndex:0];
    MDLScatteringFunction *scatteringFunction = [MDLScatteringFunction new];
    MDLMaterial *material = [[MDLMaterial alloc] initWithName:@"baseMaterial" scatteringFunction:scatteringFunction];
    MDLMaterialProperty* baseColor = [MDLMaterialProperty new];
    [baseColor setSemantic:MDLMaterialSemanticBaseColor];
    if (color != nil) {
        [baseColor setType:MDLMaterialPropertyTypeColor];
        [baseColor setColor:color.CGColor];
    } else if (textureUrl) {
        [baseColor setType:MDLMaterialPropertyTypeTexture];
        [baseColor setURLValue:textureUrl];
    } else {
        [baseColor setType:MDLMaterialPropertyTypeColor];
        [baseColor setColor:[UIColor blueColor].CGColor];
    }
    [material setProperty:baseColor];
    for (MDLSubmesh* sub in object.submeshes) {
        sub.material = material;
    }
    
    SCNNode *node = [SCNNode node];
    [node addChildNode:[SCNNode nodeWithMDLObject:object]];
    node.castsShadow = YES;
    return node;
}

@end
