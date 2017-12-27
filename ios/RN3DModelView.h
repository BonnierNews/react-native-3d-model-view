#import <SceneKit/SceneKit.h>

@interface RN3DModelView : SCNView

@property (nonatomic, assign) BOOL animated;

@property (nonatomic, assign) CGFloat rotateX;
@property (nonatomic, assign) CGFloat rotateY;
@property (nonatomic, assign) CGFloat rotateZ;

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, assign) CGFloat scaleX;
@property (nonatomic, assign) CGFloat scaleY;
@property (nonatomic, assign) CGFloat scaleZ;

@property (nonatomic, assign) CGFloat translateX;
@property (nonatomic, assign) CGFloat translateY;
@property (nonatomic, assign) CGFloat translateZ;

@end
