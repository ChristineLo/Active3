/**
 *  Test3DScene.h
 *  Test3D
 *
 *  Created by gdlab on 12/12/3.
 *  Copyright __MyCompanyName__ 2012年. All rights reserved.
 */


#import "CC3Scene.h"

#define EMode3DTransfer 0
#define EMode3DRotate 1
#define EMode3DZDepth 2
#define EMode3DScale 3
#define EModeDrawPen 4
#define EModeDrawEraser 5

/** A sample application-specific CC3Scene subclass.*/
@interface Test3DScene : CC3Scene {
    CGPoint lastTouchEventPoint;
    
    CC3Node* mainNode;
}
@property (readwrite, nonatomic) int iEditMode;
@end
