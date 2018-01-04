#import <SceneKit/SceneKit.h>
#import "RCT3DModelIO.h"

@interface RCT3DModelView : UIView
@property (nonatomic, strong) SCNView *sceneView;
@property (nonatomic, copy) NSString *source;
@end
