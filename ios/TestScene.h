#import <UIKit/UIKit.h>

@protocol UIViewControllerVisibilityDelegate

- (void)visibilityDidChange:(UIViewController *)viewController visible:(BOOL)visible animated:(BOOL)animated;

@end

@interface TestScene : UIViewController

@property (weak) id<UIViewControllerVisibilityDelegate> delegate;
@property (nonnull) NSString *key;
@property (nonnull) NSDictionary *navigationProps;

- (id)init:(NSString *)key withNavigationProps:(NSDictionary *)props view:(UIView *)view;

@end
