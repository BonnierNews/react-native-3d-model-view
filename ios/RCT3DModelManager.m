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

RCT_CUSTOM_VIEW_PROPERTY(source, NSString, RCT3DModelView)
{
//  view.model = [GLModel modelWithContentsOfFile:[RCTConvert NSString:json]];
}

@end
