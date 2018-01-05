#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

typedef enum
{
    ModelTypeSCN = 1,
    ModelTypeDAE = 2,
    ModelTypeOBJ = 3
} ModelType;

@interface RCT3DModelIO : NSObject

+ (instancetype)sharedInstance;

- (void)loadModel:(NSString *)path name:(NSString *)name type:(ModelType *)type completion:(void (^)(SCNNode * node))completion;
-(ModelType *)integerToModelType:(NSInteger *)i;

@end
