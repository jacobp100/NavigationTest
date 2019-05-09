#import "TestNavigatorView.h"
#import "TestScene.h"

#import <React/UIView+React.h>
#import <React/RCTConvert.h>
#import <React/RCTEventDispatcher.h>

@interface TestNavigatorView ()

@property (nonatomic, copy) RCTDirectEventBlock onRoutesUpdated;

@end

@implementation TestNavigatorView
{
  UINavigationController *_navigationController;
  NSMutableArray *_pendingViews;
  NSArray *_worldKeys;
}

- (id)init
{
  if (self = [super init]) {
    _navigationController = [[UINavigationController alloc] init];
    _navigationController.delegate = self;
    _pendingViews = [[NSMutableArray alloc] init];
    [self addSubview:_navigationController.view];
  }
  return self;
}

- (void)dealloc
{
  _navigationController.delegate = nil;
  [_navigationController removeFromParentViewController];
}

#pragma mark - React interop

- (void)insertReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex
{
  [super insertReactSubview:subview atIndex:atIndex];
  [_pendingViews insertObject:subview atIndex:atIndex];
}

- (void)removeReactSubview:(UIView *)subview
{
  [super removeReactSubview:subview];
  [_pendingViews removeObjectIdenticalTo:subview];
}

- (void)didUpdateReactSubviews
{
  // Do nothing, the subviews are all lies
}

- (UIViewController *)reactViewController
{
  return _navigationController;
}

#pragma mark - Custom logic

- (void)layoutSubviews
{
  [super layoutSubviews];
  [self reactAddControllerToClosestParent:_navigationController];
  _navigationController.view.frame = self.bounds;
}

- (void)applyNavigationProps:(NSDictionary *)props animated:(BOOL)animated
{
  [_navigationController.navigationBar setBarStyle:[RCTConvert UIBarStyle:[props valueForKey:@"barStyle"]]];
  [_navigationController.navigationBar setBarTintColor:[RCTConvert UIColor:[props valueForKey:@"barTintColor"]]];
  [_navigationController setNavigationBarHidden:[RCTConvert BOOL:[props valueForKey:@"navigationBarHidden"]] animated:animated];
}

#pragma mark - React exports

- (void)updateWorld:(NSArray<NSDictionary *> *)world
{
  NSMutableArray *nextControllers = [[NSMutableArray alloc] init];
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  
  NSArray<UIViewController *> *viewControllers = [_navigationController viewControllers];
  BOOL didChangeControllers = [world count] != [viewControllers count];
  for (NSInteger i = 0; i < [world count]; i += 1) {
    NSDictionary *scene = [world objectAtIndex:i];
    NSString *key = [scene valueForKey:@"key"];
    [keys addObject:key];
    UIViewController *nextController = nil;
    
    for (NSInteger j = 0; j < [viewControllers count]; j += 1) {
      TestScene *existingController = [[_navigationController viewControllers] objectAtIndex:j];
      
      if (
        [existingController isKindOfClass:[TestScene class]] &&
        [[existingController key] isEqualToString:key]
      ) {
        didChangeControllers = didChangeControllers || (i != j);
        nextController = [viewControllers objectAtIndex:j];
        [(TestScene *)existingController setNavigationProps:scene];
        break;
      }
    }
    
    if (nextController == nil) {
      didChangeControllers = YES;
      
      id view = [_pendingViews objectAtIndex:i];
      if ([view isKindOfClass:[UIView class]]) {
        nextController = [[TestScene alloc] init:key withNavigationProps:scene view:(UIView *)view];
        ((TestScene *)nextController).delegate = self;
        [_pendingViews replaceObjectAtIndex:i withObject:[NSNull null]];
      } else {
        NSLog(@"Failed to create view");
      }
    }
    
    if (nextController != nil) {
      [nextControllers addObject:nextController];
    }
  }
  
  _worldKeys = keys;
  
  if (didChangeControllers) {
    // Will update navigaion props as part of UINavigationControllerDelegate willShowViewController
    [_navigationController setViewControllers:nextControllers animated:YES];
  } else {
    [self applyNavigationProps:[world lastObject] animated:YES];
  }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  NSMutableArray *routeKeys = [[NSMutableArray alloc] init];

  NSArray<UIViewController *> *viewControllers = [_navigationController viewControllers];
  BOOL didChangeKeys = [_worldKeys count] != [viewControllers count];

  for (NSInteger i = 0; i < [viewControllers count]; i += 1) {
    TestScene *controller = [[_navigationController viewControllers] objectAtIndex:i];
    if ([controller isKindOfClass:[TestScene class]]) {
      NSString *key = [controller key];
      [routeKeys addObject:key];
      BOOL keyEqual = i < [_worldKeys count] ? [[_worldKeys objectAtIndex:i] isEqualToString:key] : NO;
      didChangeKeys = didChangeKeys || !keyEqual;
    } else {
      // This happens on mounting
      // It could also happen with iOS modals (SFSafariViewController etc.)
      // Maybe we could handle this better though
      return;
    }
  }

  if (didChangeKeys) {
    _onRoutesUpdated(@{
                       @"routeKeys": routeKeys,
                       });
  }
}

#pragma mark - UIViewControllerVisibilityDelegate

- (void)visibilityDidChange:(UIViewController *)viewController visible:(BOOL)visible animated:(BOOL)animated
{
  TestScene *topController = [[_navigationController viewControllers] lastObject];
  NSDictionary *navigationProps = [topController isKindOfClass:[TestScene class]] ? [topController navigationProps] : @{};
  [self applyNavigationProps:navigationProps animated:animated];
}

@end
