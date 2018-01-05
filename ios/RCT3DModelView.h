#import <SceneKit/SceneKit.h>
#import "RCT3DModelIO.h"

@interface RCT3DModelView : UIView
@property (nonatomic, strong) SCNView *sceneView;
@property (nonatomic) bool isLoaded;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSInteger *type;
@end
