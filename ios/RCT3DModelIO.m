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

- (void)loadModel:(NSString *)modelSrc textureSrc:(NSString *)textureSrc completion:(void (^)(SCNNode * node))completion {
    NSURL *modelUrl = [self urlFromPath:modelSrc];
    NSURL *textureUrl = [self urlFromPath:textureSrc];
    completion([self createModel:modelUrl textureUrl:textureUrl]);
}

- (NSURL *)urlFromPath:(NSString *)path {
    NSURL *url;
    
    if ([path hasPrefix: @"/"]) {
        url = [NSURL fileURLWithPath: path];
    } else if ([path hasPrefix: @"http"]) {
        url = [NSURL URLWithString:path];
    }
    
    return url;
}

-(SCNNode *)createModel:(NSURL*)modelUrl textureUrl:(NSURL*)textureUrl  {
    NSLog(@"[RCT3dModel]: Loading model at %@", modelUrl.path);
    SCNNode* node;
    NSString *type = [modelUrl pathExtension];
    if([type  isEqual: @"scn"]) {
        node = [self createScnModel:modelUrl textureUrl:textureUrl];
    } else if ([type  isEqual: @"dae"]) {
        node = [self createDaeModel:modelUrl textureUrl:textureUrl];
    } else if ([type  isEqual: @"obj"]) {
        node = [self createObjModel:modelUrl textureUrl:textureUrl];
    }
    return node;
}

-(SCNNode *)createScnModel:(NSURL *)modelUrl textureUrl:(NSURL *)textureUrl {
    NSError* error;
    SCNScene *scene = [SCNScene sceneWithURL:modelUrl options:nil error:&error];
    if(error) {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }

    SCNNode *node = [[SCNNode alloc] init];
    NSArray *nodeArray = [scene.rootNode childNodes];

    SCNMaterial *material;
    for (SCNNode *eachChild in nodeArray) {
        if (material != nil) {
            eachChild.geometry.materials = [NSArray arrayWithObject:material];
        }
        [node addChildNode:eachChild];
    }
    return node;
}

-(SCNNode *)createDaeModel:(NSURL *)modelUrl textureUrl:(NSURL *)textureUrl {
    NSError* error;
    SCNScene *scene = [SCNScene sceneWithURL:modelUrl options:nil error:&error];
    if(error) {
        NSLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    SCNNode *node = [[SCNNode alloc] init];
    NSArray *nodeArray = [scene.rootNode childNodes];
    SCNMaterial *material;
    for (SCNNode *eachChild in nodeArray) {
        if (material != nil) {
            eachChild.geometry.materials = [NSArray arrayWithObject:material];
        }
        [node addChildNode:eachChild];
    }
    return node;
}

-(SCNNode *)createObjModel:(NSURL *)modelUrl textureUrl:(NSURL *)textureUrl {
    MDLAsset *asset = [[MDLAsset alloc] initWithURL:modelUrl];
    if (asset.count == 0) {
        return nil;
    }
    MDLMesh* object = (MDLMesh *)[asset objectAtIndex:0];
    MDLScatteringFunction *scatteringFunction = [MDLScatteringFunction new];
    MDLMaterial *material = [[MDLMaterial alloc] initWithName:@"baseMaterial" scatteringFunction:scatteringFunction];
    MDLMaterialProperty* baseColor = [MDLMaterialProperty new];
    [baseColor setSemantic:MDLMaterialSemanticBaseColor];
    if (textureUrl) {
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
