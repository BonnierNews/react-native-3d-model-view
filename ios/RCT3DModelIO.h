#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

typedef enum
{
    ModelTypeSCN = 1,
    ModelTypeOBJ = 2
} ModelType;

@interface RCT3DModelIO : NSObject

+ (instancetype)sharedInstance;

- (void)loadModel:(NSString *)path name:(NSString *)name type:(ModelType)type color:(UIColor *)color completion:(void (^)(SCNNode * node))completion;
- (void)clearDownloadedFiles;
@end
