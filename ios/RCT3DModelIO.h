#import <Foundation/Foundation.h>
#import <ModelIO/ModelIO.h>
#import <ModelIO/MDLAsset.h>
#import <SceneKit/ModelIO.h>
#import "AFNetworking.h"
#import "SSZipArchive.h"

typedef enum
{
    ModelTypeSCN = 1,
    ModelTypeOBJ = 2
} ModelType;

@interface RCT3DModelIO : NSObject

+ (instancetype)sharedInstance;

- (void)loadModel:(NSString *)path type:(ModelType)type color:(UIColor *)color completion:(void (^)(SCNNode * node))completion;
- (void)clearDownloadedFiles;
@end
