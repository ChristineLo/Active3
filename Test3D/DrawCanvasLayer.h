//
//  DrawCanvasLayer.h
//  Test3D
//
//  Created by Mac06 on 12/12/12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "cocos2d.h"

#define EModeDrawPen 4
#define EModeDrawEraser 5

@interface DrawCanvasLayer : CCLayerColor {
    NSMutableArray *panTouchArray;
    NSMutableArray *eraseTouchArray;
}
@property (nonatomic, readwrite) int iDrawMode;
@end
