/**
 *  Test3DAppDelegate.h
 *  Test3D
 *
 *  Created by gdlab on 12/12/3.
 *  Copyright __MyCompanyName__ 2012年. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "CCNodeController.h"
#import "CC3Scene.h"

@interface Test3DAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow* window;
	CCNodeController* viewController;
}

@property (nonatomic, retain) UIWindow* window;

@end
