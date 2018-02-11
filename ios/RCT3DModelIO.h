#import <Foundation/Foundation.h>
#import <ModelIO/ModelIO.h>
#import <ModelIO/MDLAsset.h>
#import <SceneKit/ModelIO.h>
#import <UIKit/UIKit.h>

@interface RCT3DModelIO : NSObject

+ (instancetype)sharedInstance;

- (void)loadModel:(NSString *)modelSrc textureSrc:(NSString *)textureSrc completion:(void (^)(SCNNode * node))completion;
- (void)clearDownloadedFiles;
@end
