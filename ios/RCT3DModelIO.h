#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@interface RCT3DModelIO : NSObject

+ (instancetype)sharedInstance;

- (SCNNode *)loadModel:(NSString *)path nodeName:(NSString *)nodeName withAnimation:(BOOL)withAnimation;

@end
