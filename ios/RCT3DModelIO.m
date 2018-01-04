#import "RCT3DModelIO.h"
#import <ModelIO/ModelIO.h>
#import <ModelIO/MDLAsset.h>
#import <SceneKit/ModelIO.h>
#import "AFNetworking/AFNetworking.h"
#import "SSZipArchive/SSZipArchive.h"

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

- (void)downloadZip:(NSString *)url completion:(void (^)(NSURL* url))completion {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *tempDirectory = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
        return [tempDirectory URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        // Unzip the archive
        NSURL *tempDirectory = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
        NSString *inputPath = [filePath path];
        NSString *outputPath = [tempDirectory path];
        NSError *zipError = nil;
        
        [SSZipArchive unzipFileAtPath:inputPath toDestination:outputPath overwrite:YES password:nil error:&zipError];
        
        if (zipError) {
            completion(nil);
        } else {
            NSString *folderName = [[url lastPathComponent] stringByReplacingOccurrencesOfString:@".zip" withString:@""];
            NSURL *resultPath = [tempDirectory URLByAppendingPathComponent:folderName isDirectory:YES];
            completion(resultPath);
        }
    }];
    [downloadTask resume];
    
}

- (void)loadModel:(NSString *)name zipPath:(NSString *)path completion:(void (^)(SCNNode * node))completion {
    [self downloadZip:path completion:^(NSURL *url) {
        if (url) {
            SCNNode *model = [self createModel:name url:url];
            completion(model);
        } else {
            completion(nil);
        }
    }];
}

-(SCNNode *)createModel:(NSString *)name url:(NSURL *)url {
    NSString *objName = [NSString stringWithFormat:@"%@.obj", name];
    NSString *textureName = [NSString stringWithFormat:@"%@.bmp", name];
    NSURL *modelUrl = [url URLByAppendingPathComponent:objName];
    NSURL *textureUrl = [url URLByAppendingPathComponent:textureName];
    MDLAsset *asset = [[MDLAsset alloc] initWithURL:modelUrl];
    MDLMesh* object = (MDLMesh *)[asset objectAtIndex:0];

    MDLScatteringFunction *scatteringFunction = [MDLScatteringFunction new];
    MDLMaterial *material = [[MDLMaterial alloc] initWithName:@"baseMaterial" scatteringFunction:scatteringFunction];
    MDLMaterialProperty * baseColor = [MDLMaterialProperty new];
    [baseColor setType:MDLMaterialPropertyTypeTexture];
    [baseColor setSemantic:MDLMaterialSemanticBaseColor];
    [baseColor setURLValue:textureUrl];
    [material setProperty:baseColor];
    
    for (MDLSubmesh * sub in object.submeshes){
        sub.material = material;
    }
    SCNNode *node = [SCNNode nodeWithMDLObject:object];
    return node;
}

@end
