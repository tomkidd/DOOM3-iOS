/*   SDLMain.m - main entry point for our Cocoa-ized SDL app
       Initial Version: Darrell Walisser <dwaliss1@purdue.edu>
       Non-NIB-Code & other changes: Max Horn <max@quendi.de>

    Feel free to customize this file to suit your needs
*/

#ifndef _SDLMain_h_
#define _SDLMain_h_

#ifndef IOS
#import <Cocoa/Cocoa.h>
#else
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#endif

@interface SDLMain : NSObject
@end

#endif /* _SDLMain_h_ */
