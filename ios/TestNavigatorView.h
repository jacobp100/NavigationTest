#import "TestScene.h"

#import <UIKit/UIKit.h>

#import <React/RCTBridgeModule.h>

@interface TestNavigatorView : UIView <UINavigationControllerDelegate, UIViewControllerVisibilityDelegate>

- (void)updateWorld:(NSArray<NSDictionary *> *)world;

@end
