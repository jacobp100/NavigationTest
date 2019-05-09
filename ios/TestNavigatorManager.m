#import "TestNavigatorManager.h"
#import "TestNavigatorView.h"

#import <React/RCTBridge.h>
#import <React/RCTDefines.h>
#import <React/RCTUIManager.h>

@implementation TestNavigatorManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [[TestNavigatorView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(onRoutesUpdated, RCTDirectEventBlock)

RCT_EXPORT_METHOD(updateWorld:(nonnull NSNumber *)reactTag world:(NSArray<NSDictionary *> *)world)
{
  [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, TestNavigatorView *> *viewRegistry) {
    TestNavigatorView *view = viewRegistry[reactTag];
    if (![view isKindOfClass:[TestNavigatorView class]]) {
      RCTLogError(@"Invalid view returned from registry, expecting TestNavigatorView, got: %@", view);
    } else {
      [view updateWorld:world];
    }
  }];
}

@end
