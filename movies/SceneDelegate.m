#import "SceneDelegate.h"
#import "MainCoordinator.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UINavigationController *controller = [[UINavigationController alloc] init];
    self.coordinator = [MainCoordinator coordinatorWithNavigationController:controller];
    [self.coordinator start];

    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
}

@end
