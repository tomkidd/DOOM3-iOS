//
//  AppDelegate.m
//  DOOM3-iOS
//
//  Created by Tom Kidd on 1/26/19.
//

#import "AppDelegate.h"

@implementation SDLUIKitDelegate (customDelegate)

// hijack the the SDL_UIKitAppDelegate to use the UIApplicationDelegate we implement here
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+ (NSString *)getAppDelegateClassName {
    return @"AppDelegate";
}
#pragma clang diagnostic pop

@end

@implementation AppDelegate
@synthesize rootNavigationController, uiwindow;

#pragma mark -
#pragma mark AppDelegate methods
- (id)init {
    if ((self = [super init])) {
        rootNavigationController = nil;
        uiwindow = nil;
    }
    return self;
}


// override the direct execution of SDL_main to allow us to implement our own frontend
- (void)postFinishLaunch
{
    [self performSelector:@selector(hideLaunchScreen) withObject:nil afterDelay:0.0];

    self.uiwindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.uiwindow.backgroundColor = [UIColor blackColor];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];

    rootNavigationController = (UINavigationController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"RootNC"];

    self.uiwindow.rootViewController = self.rootNavigationController;
    
    [self.uiwindow makeKeyAndVisible];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [super applicationDidReceiveMemoryWarning:application];
}

// true multitasking with SDL works only on 4.2 and above; we close the game to avoid a black screen at return
- (void)applicationWillResignActive:(UIApplication *)application {
    [super applicationWillResignActive:application];
}

@end
