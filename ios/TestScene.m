#import "TestScene.h"

#import <UIKit/UIKit.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

@implementation TestScene
{
  NSDictionary *_props;
}

- (id)init:(NSString *)key withNavigationProps:(NSDictionary *)navigationProps view:(UIView *)view
{
  if (self = [super init]) {
    self.key = key;
    self.view = view;
    self.navigationProps = navigationProps;
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.delegate visibilityDidChange:self visible:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self.delegate visibilityDidChange:self visible:NO animated:animated];
}

- (void)setNavigationProps:(NSDictionary *)props
{
  self.title = [props valueForKey:@"title"] ?: @"";
  _props = props;
}

- (NSDictionary *)navigationProps
{
  return _props;
}

@end
