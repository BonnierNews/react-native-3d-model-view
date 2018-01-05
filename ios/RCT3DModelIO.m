#import "RCT3DModelIO.h"
#import <ModelIO/ModelIO.h>
#import <ModelIO/MDLAsset.h>
#import <SceneKit/ModelIO.h>
#import "AFNetworking.h"
#import "SSZipArchive.h"

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


- (void)loadModel:(NSString *)path name:(NSString *)name type:(ModelType *)type completion:(void (^)(SCNNode * node))completion {
    NSURL *url = [self urlFromPath:path];
    NSLog(@"%@", [url path]);
    bool isHttp = [path hasPrefix:@"http"];
    bool isZip = [path hasSuffix:@".zip"];
    if (isHttp) {
        [self download:url completion:^(NSURL *localUrl) {
            if (isZip) {
                [self unzip:localUrl completion:^(NSURL *unzippedUrl) {
                    completion([self createModel:unzippedUrl name:name type:type]);
                }];
            } else {
                completion([self createModel:localUrl name:nil type:type]);
            }
        }];
    } else {
        if (isZip) {
            [self unzip:url completion:^(NSURL *unzippedUrl) {
                completion([self createModel:unzippedUrl name:name type:type]);
            }];
        } else {
            completion([self createModel:url name:nil type:type]);
        }
    }
}

- (void)download:(NSURL *)url completion:(void (^)(NSURL* url))completion {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *tempDirectory = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
        return [tempDirectory URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (filePath != nil) {
            completion(filePath);
        } else {
            completion(nil);
        }
    }];
    [downloadTask resume];
    
}

-(void)unzip:(NSURL *)url completion:(void (^)(NSURL* url))completion {
    // Unzip the archive
    NSURL *tempDirectory = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSString *inputPath = [url path];
    NSString *outputPath = [tempDirectory path];
    NSString *folderName = [[url lastPathComponent] stringByReplacingOccurrencesOfString:@".zip" withString:@""];
    NSError *zipError = nil;
    
    [SSZipArchive unzipFileAtPath:inputPath toDestination:outputPath overwrite:YES password:nil error:&zipError];
    
    if (zipError) {
        completion(nil);
    } else {
        NSURL *resultPath = [tempDirectory URLByAppendingPathComponent:folderName isDirectory:YES];
        completion(resultPath);
    }
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

-(SCNNode *)createModel:(NSURL*)url name:(NSString *)name type:(ModelType)type {
    SCNNode* node;
    switch (type) {
        case ModelTypeSCN:
            node = [self createScnModel:url name:name];
            break;
        case ModelTypeDAE:
            node = [self createDaeModel:url name:name];
            break;
        case ModelTypeOBJ:
            node = [self createObjModel:url name:name];
            break;
        default:
            break;
    }
    return node;
}

-(SCNNode *)createScnModel:(NSURL *)url name:(NSString *)name {
    NSError* error;
    NSURL *modelUrl = url;
    if (name) {
        NSString *objName = [NSString stringWithFormat:@"%@.scn", name];
        modelUrl = [url URLByAppendingPathComponent:objName];
    }
    SCNScene *scene = [SCNScene sceneWithURL:modelUrl options:nil error:&error];
    if(error) {
        NSLog(@"%@",[error localizedDescription]);
    }

    SCNNode *node = [[SCNNode alloc] init];
    NSArray *nodeArray = [scene.rootNode childNodes];
    for (SCNNode *eachChild in nodeArray) {
        [node addChildNode:eachChild];
    }
    return node;
}

-(SCNNode *)createDaeModel:(NSURL *)url name:(NSString *)name {
    NSError* error;
    NSURL *modelUrl = url;
    if (name) {
        NSString *objName = [NSString stringWithFormat:@"%@.dae", name];
        modelUrl = [url URLByAppendingPathComponent:objName];
    }
    SCNScene *scene = [SCNScene sceneWithURL:modelUrl options:nil error:&error];
    if(error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    SCNNode *node = [[SCNNode alloc] init];
    NSArray *nodeArray = [scene.rootNode childNodes];
    for (SCNNode *eachChild in nodeArray) {
        [node addChildNode:eachChild];
    }
    
    return node;
}

-(SCNNode *)createObjModel:(NSURL *)url name:(NSString *)name {
    NSURL *textureUrl;
    NSURL *modelUrl = url;
    if (name) {
        NSString *objName = [NSString stringWithFormat:@"%@.obj", name];
        modelUrl = [url URLByAppendingPathComponent:objName];
        NSString *textureName = [NSString stringWithFormat:@"%@.bmp", name];
        textureUrl = [url URLByAppendingPathComponent:textureName];
    } else {
        NSString *textureName = [NSString stringWithFormat:@"%@.bmp", name];
        textureUrl = [[url URLByDeletingLastPathComponent] URLByAppendingPathComponent:textureName];
    }
    MDLAsset *asset = [[MDLAsset alloc] initWithURL:modelUrl];
    MDLMesh* object = (MDLMesh *)[asset objectAtIndex:0];
    MDLScatteringFunction *scatteringFunction = [MDLScatteringFunction new];
    MDLMaterial *material = [[MDLMaterial alloc] initWithName:@"baseMaterial" scatteringFunction:scatteringFunction];
    MDLMaterialProperty* baseColor = [MDLMaterialProperty new];
    [baseColor setType:MDLMaterialPropertyTypeTexture];
    [baseColor setSemantic:MDLMaterialSemanticBaseColor];
    [baseColor setURLValue:textureUrl];
    [material setProperty:baseColor];
    for (MDLSubmesh* sub in object.submeshes) {
        sub.material = material;
    }
    
    return [SCNNode nodeWithMDLObject:object];
}

@end
