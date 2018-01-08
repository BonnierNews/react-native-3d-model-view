#import "RCT3DModelIO.h"
#import <React/RCTView.h>

@interface RCT3DModelView : UIView

@property (nonatomic, copy) RCTBubblingEventBlock onLoadModelStart;
@property (nonatomic, copy) RCTBubblingEventBlock onLoadModelSuccess;
@property (nonatomic, copy) RCTBubblingEventBlock onLoadModelError;

@end
