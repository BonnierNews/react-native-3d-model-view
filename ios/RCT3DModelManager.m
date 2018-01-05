#import <React/RCTBridge.h>

#import "RCT3DModelManager.h"

@implementation RCT3DModelManager
{
  RCT3DModelView *modelView;
}

RCT_EXPORT_MODULE()

- (UIView *)view
{
  modelView = [[RCT3DModelView alloc] init];
  return modelView;
}

RCT_EXPORT_VIEW_PROPERTY(source, NSString)
RCT_EXPORT_VIEW_PROPERTY(name, NSString)
RCT_EXPORT_VIEW_PROPERTY(type, NSInteger)
@end
