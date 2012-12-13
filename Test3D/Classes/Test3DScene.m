/**
 *  Test3DScene.m
 *  Test3D
 *
 *  Created by gdlab on 12/12/3.
 *  Copyright __MyCompanyName__ 2012年. All rights reserved.
 */

#import "Test3DScene.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3Camera.h"
#import "CC3Light.h"
#import "CCRenderTexture.h"
#import "CCTouchDispatcher.h"
#import "CGPointExtension.h"

@implementation Test3DScene
@synthesize iEditMode;

-(void) dealloc {
	[super dealloc];
}

/**
 * Constructs the 3D scene.
 *
 * Adds 3D objects to the scene, loading a 3D 'hello, world' message
 * from a POD file, and creating the camera and light programatically.
 *
 * When adapting this template to your application, remove all of the content
 * of this method, and add your own to construct your 3D model scene.
 *
 * NOTE: The POD file used for the 'hello, world' message model is fairly large,
 * because converting a font to a mesh results in a LOT of triangles. When adapting
 * this template project for your own application, REMOVE the POD file 'hello-world.pod'
 * from the Resources folder of your project!!
 */
-(void) initializeScene {

	// Create the camera, place it back a bit, and add it to the scene
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
	//cam.location = cc3v( 0.0, 5.0, 5.0 );
    //cam.rotation = cc3v(-45.0, 0.0, 0.0);
    cam.location = cc3v(0.0, 0.0, 10.0);
	[self addChild: cam];

	// Create a light, place it back and to the left at a specific
	// position (not just directional lighting), and add it to the scene
	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
	lamp.location = cc3v( -6.0, 0.0, 0.0 );
	lamp.isDirectionalOnly = NO;
	[cam addChild: lamp];

    
	// This is the simplest way to load a POD resource file and add the
	// nodes to the CC3Scene, if no customized resource subclass is needed.
	//[self addContentFromPODFile: @"hello-world.pod"];
    [self addContentFromPODFile:@"boxc.pod" withName:@"Arch"];
    [self addContentFromPODFile:@"archc.pod" withName:@"Arch2"];
    [self addContentFromPODFile:@"cylinderc.pod" withName:@"Arch3"];

	
	// Create OpenGL ES buffers for the vertex arrays to keep things fast and efficient,
	// and to save memory, release the vertex data in main memory because it is now redundant.
	[self createGLBuffers];
	[self releaseRedundantData];
	
	CC3MeshNode* helloTxt = (CC3MeshNode*)[self getNodeNamed: @"Arch"];
    helloTxt.isTouchEnabled = YES;
    helloTxt = (CC3MeshNode*)[self getNodeNamed: @"Arch2"];
    helloTxt.scale = cc3v(2, 2, 2);
    helloTxt.isTouchEnabled = YES;
    helloTxt = (CC3MeshNode*)[self getNodeNamed: @"Arch3"];
    helloTxt.location = cc3v(0, 0, 0);
    helloTxt.isTouchEnabled = YES;
    
    mainNode = helloTxt;
    
	//CC3MeshNode* mdBox = (CC3MeshNode*)[self getNodeNamed: @"Box"];
    //mdBox.isTouchEnabled = YES;
    //mainNode = mdBox;
}


#pragma mark Updating custom activity

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities before
 * any changes are applied to the transformMatrix of the 3D nodes in the scene.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {}

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities after
 * the transformMatrix of the 3D nodes in the scen have been recalculated.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {}


#pragma mark Scene opening and closing

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene is first displayed.
 *
 * This method is a good place to invoke one of CC3Camera moveToShowAllOf:... family
 * of methods, used to cause the camera to automatically focus on and frame a particular
 * node, or the entire scene.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onOpen {

	// Uncomment this line to have the camera move to show the entire scene.
	// This must be done after the CC3Layer has been attached to the view,
	// because this makes use of the camera frustum and projection.
	//[self.activeCamera moveWithDuration: 3.0 toShowAllOf: self];

	// Uncomment this line to draw the bounding box of the scene.
	self.shouldDrawWireframeBox = NO;
}

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene has been removed from display.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onClose {}


#pragma mark Handling touch events 

/**
 * This method is invoked from the CC3Layer whenever a touch event occurs, if that layer
 * has indicated that it is interested in receiving touch events, and is handling them.
 *
 * Override this method to handle touch events, or remove this method to make use of
 * the superclass behaviour of selecting 3D nodes on each touch-down event.
 *
 * This method is not invoked when gestures are used for user interaction. Your custom
 * CC3Layer processes gestures and invokes higher-level application-defined behaviour
 * on this customized CC3Scene subclass.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) touchEvent: (uint) touchType at: (CGPoint) touchPoint {
    switch (touchType) {
		case kCCTouchBegan:
            [self pickNodeFromTouchEvent: touchType at: touchPoint];
			break;
		case kCCTouchMoved:
            switch (iEditMode) {
                case EMode3DTransfer:
                    [self transferMainNodeFromSwipeAt: touchPoint];
                    break;
                case EMode3DRotate:
                    [self rotateMainNodeFromSwipeAt: touchPoint];
                    break;
                case EMode3DZDepth:
                    [self zdepthNodeFromSwipeAt:touchPoint];
                    break;
                case EMode3DScale:
                    [self scaleNodeFromSwipeAt:touchPoint];
                    break;
                default:
                    break;
            }
			break;
		case kCCTouchEnded:
			break;
		default:
			break;
	}
	
	// For all event types, remember where the touchpoint was, for subsequent events.
	lastTouchEventPoint = touchPoint;
}

/** Set this parameter to adjust the rate of rotation from the length of touch-move swipe. */
#define kSwipeScale 0.6

/**
 * 旋轉
 * Rotates the die cube, by determining the direction of each touch move event.
 *
 * The touch-move swipe is measured in 2D screen coordinates, which are mapped to
 * 3D coordinates by recognizing that the screen's X-coordinate maps to the camera's
 * rightDirection vector, and the screen's Y-coordinates maps to the camera's upDirection.
 *
 * The cube rotates around an axis perpendicular to the swipe. The rotation angle is
 * determined by the length of the touch-move swipe.
 *
 * To allow freewheeling after the finger is lifted, we set the spin speed and spin axis
 * in the die cube. We indicate for now that the cube is not freewheeling.
 */
-(void) rotateMainNodeFromSwipeAt: (CGPoint) touchPoint {
	
	CC3Camera* cam = self.activeCamera;
	
	// Get the direction and length of the movement since the last touch move event, in
	// 2D screen coordinates. The 2D rotation axis is perpendicular to this movement.
	CGPoint swipe2d = ccpSub(touchPoint, lastTouchEventPoint);
	CGPoint axis2d = ccpPerp(swipe2d);
	
	// Project the 2D axis into a 3D axis by mapping the 2D X & Y screen coords
	// to the camera's rightDirection and upDirection, respectively.
	CC3Vector axis = CC3VectorAdd(CC3VectorScaleUniform(cam.rightDirection, axis2d.x),
								  CC3VectorScaleUniform(cam.upDirection, axis2d.y));
	GLfloat angle = ccpLength(swipe2d) * kSwipeScale;
	
	// Rotate the cube under direct finger control, by directly rotating by the angle
	// and axis determined by the swipe. If the die cube is just to be directly controlled
	// by finger movement, and is not to freewheel, this is all we have to do.
	[mainNode rotateByAngle: angle aroundAxis: axis];
}
/** Set this parameter to adjust the rate of rotation from the length of touch-move swipe. */
#define kTransferScale 0.01
/**
 *移動
 */
-(void) transferMainNodeFromSwipeAt: (CGPoint) touchPoint {
    CC3Camera* cam = self.activeCamera;
	
	// Get the direction and length of the movement since the last touch move event, in
	// 2D screen coordinates. The 2D rotation axis is perpendicular to this movement.
	CGPoint swipe2d = ccpSub(touchPoint, lastTouchEventPoint);
	swipe2d.x = kTransferScale * swipe2d.x;
    swipe2d.y = kTransferScale * swipe2d.y;
    

    CC3Vector axis = CC3VectorAdd(CC3VectorScaleUniform(cam.rightDirection, swipe2d.x),
								  CC3VectorScaleUniform(cam.upDirection, swipe2d.y));
	
	// Rotate the cube under direct finger control, by directly rotating by the angle
	// and axis determined by the swipe. If the die cube is just to be directly controlled
	// by finger movement, and is not to freewheel, this is all we have to do.
    //[mainNode rotateByAngle: angle aroundAxis: axis];
    [mainNode setLocation:CC3VectorAdd(mainNode.location, axis)];
}

/**
 *深度
 */
-(void) zdepthNodeFromSwipeAt: (CGPoint) touchPoint {
    CC3Camera* cam = self.activeCamera;
	
	// Get the direction and length of the movement since the last touch move event, in
	// 2D screen coordinates. The 2D rotation axis is perpendicular to this movement.
	CGPoint swipe2d = ccpSub(touchPoint, lastTouchEventPoint);
    swipe2d.y = kTransferScale * swipe2d.y;
    
    
    CC3Vector axis = CC3VectorAdd(CC3VectorMake(0, 0, 0),
								  CC3VectorScaleUniform(cam.forwardDirection, swipe2d.y));
	
	// Rotate the cube under direct finger control, by directly rotating by the angle
	// and axis determined by the swipe. If the die cube is just to be directly controlled
	// by finger movement, and is not to freewheel, this is all we have to do.
    //[mainNode rotateByAngle: angle aroundAxis: axis];
    [mainNode setLocation:CC3VectorAdd(mainNode.location, axis)];
}

/**
 *縮放
 */
-(void) scaleNodeFromSwipeAt: (CGPoint) touchPoint {
    CC3Camera* cam = self.activeCamera;
	
	// Get the direction and length of the movement since the last touch move event, in
	// 2D screen coordinates. The 2D rotation axis is perpendicular to this movement.
	CGPoint swipe2d = ccpSub(touchPoint, lastTouchEventPoint);
    swipe2d.y = kTransferScale * swipe2d.y;
    swipe2d.x = kTransferScale * swipe2d.x;
    
    
    CC3Vector axis = CC3VectorAdd(CC3VectorScaleUniform(cam.rightDirection, swipe2d.y), CC3VectorScaleUniform(cam.upDirection, swipe2d.y));
    axis = CC3VectorAdd(axis, CC3VectorScaleUniform(cam.forwardDirection, -swipe2d.y));
    
	if (mainNode.scale.x >= 0.5 && mainNode.scale.x >= 0.5 && mainNode.scale.x >= 0.5) {
        [mainNode setScale:CC3VectorAdd(mainNode.scale, axis)];
    }
    else
    {
        mainNode.scale = cc3v(0.5, 0.5, 0.5);
    }
}

/**
 * This callback template method is invoked automatically when a node has been picked
 * by the invocation of the pickNodeFromTapAt: or pickNodeFromTouchEvent:at: methods,
 * as a result of a touch event or tap gesture.
 *
 * Override this method to perform activities on 3D nodes that have been picked by the user.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
// Tint the node to cyan and back again to provide user feedback to touch
-(void) nodeSelected: (CC3Node*) aNode byTouchEvent: (uint) touchType at: (CGPoint) touchPoint {
	LogCleanInfo(@"You selected %@ at %@, or %@ in 2D.", aNode,
				 NSStringFromCC3Vector(aNode ? aNode.globalLocation : kCC3VectorZero),
				 NSStringFromCC3Vector(aNode ? [activeCamera projectNode: aNode] : kCC3VectorZero));
	CCActionInterval* tintUp = [CC3TintEmissionTo actionWithDuration: 0.2f colorTo: kCCC4FCyan];
	CCActionInterval* tintDown = [CC3TintEmissionTo actionWithDuration: 0.5f colorTo: kCCC4FBlack];
	[aNode runAction: [CCSequence actionOne: tintUp two: tintDown]];
    
    mainNode = aNode;
}

@end

