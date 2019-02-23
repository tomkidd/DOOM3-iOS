//
//  AppDelegate.h
//  DOOM3-iOS
//
//  Created by Tom Kidd on 1/26/19.
//

#import <UIKit/UIKit.h>
#import "../SDL/src/video/uikit/SDL_uikitappdelegate.h"

@interface AppDelegate : SDLUIKitDelegate {
    UINavigationController *rootNavigationController;     // required to dismiss the SettingsBaseViewController
    UIWindow *uiwindow;
}

@property (nonatomic, strong) UINavigationController *rootNavigationController;
@property (nonatomic, strong) UIWindow *uiwindow;

@end

