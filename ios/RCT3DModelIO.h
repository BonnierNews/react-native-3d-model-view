#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@interface RCT3DModelIO : NSObject

+ (instancetype)sharedInstance;

- (void)loadModel:(NSString *)name zipPath:(NSString *)path completion:(void (^)(SCNNode * node))completion;

@end
