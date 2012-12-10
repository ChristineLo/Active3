//
//  MainLayer.m
//  Test3D
//
//  Created by Mac06 on 12/12/7.
//
//

#import "MainLayer.h"

#define kNextBtnImageName 

@implementation MainLayer
/**
 * Creates a new scene and chooses one of the template nodes
 * and sets it as the main node of the scene.
 */
-(CC3Scene*) makeScene {
	Test3DScene* scene = [Test3DScene scene];		// A new scene
	[scene createGLBuffers];
	return scene;
}

-(id) init {
    if (self = [super init]) {
        tileLayer = [Test3DLayer layerWithColor: ccc4(255, 255, 255, 255)];
        tileLayer.cc3Scene = [self makeScene];
        //tileLayer.position = ccp(0, 200);
        //tileLayer.contentSize = CGSizeMake(768, 824);
        [self addChild: tileLayer];
        
        //self.isTouchEnabled = YES;
        [self initializeControls];
    }
    return self;
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"cclayer touch begin");
}

-(void) initializeControls {
    // Turn depth testing off for 2D content to improve performance and allow us to reduce
	// the clearing of the depth buffer when transitioning from the 3D scene to the 2D scene.
	// See the notes for the CC3Scene shouldClearDepthBufferBefore2D property for more info.
	[[CCDirector sharedDirector] setDepthTest: NO];
    
    [self addButtons];
    [self addLabel];
}

-(void) dealloc {
    [super dealloc];
}
/**
 * UI 物件
 */
-(void) addButtons {
    CCMenuItem *next = [CCMenuItemImage itemFromNormalImage:@"Icon-Small-50.png" selectedImage:@"Icon-Small-50.png" target:self selector:@selector(saveScreenShotSelected:)];
    next.position = ccp(100, 100);
    
    CCMenu *viewMenu = [CCMenu menuWithItems:next, nil];
    [self addChild:viewMenu];
}

-(void) addLabel {
	CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tiles per side: 88" fontName:@"Arial" fontSize: 22];
	label.anchorPoint = ccp(1.0, 0.0);		// Alight bottom-right
    label.color = ccc3(255, 0, 0);
    label.position = ccp(500, 970);
	[self addChild: label z: 10];			// Draw on top
}

/**
 * 按鈕動作
 */
-(void) saveScreenShotSelected: (CCMenuItemToggle*) menuItem {
    //[self takeScreenShot];
    NSLog(@"click");
}

#pragma mark Updating
-(void) update: (ccTime)dt {
    [tileLayer update: dt];
}

/**
 * 畫面截圖制作
 */
-(void) takeScreenShot
{
    NSLog(@"save screen");
    /* [self getScreenshot:^(UIImage *image){
     CCLOG(@"Saving Screenshot to Photo Album");
     //UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
     }];*/
    
    // cocos2d 1.0, change 'view' to 'openGLView'
    //UIView * eagleView = (UIView*)[[CCDirector sharedDirector] view];
    UIView * eagleView = (UIView*)[[CCDirector sharedDirector] openGLView];
    GLint backingWidth, backingHeight;
    
    // Bind the color renderbuffer used to render the OpenGL ES view
    // If your application only creates a single color renderbuffer which is already bound at this point,
    // this call is redundant, but it is needed if you're dealing with multiple renderbuffers.
    // Note, replace "_colorRenderbuffer" with the actual name of the renderbuffer object defined in your class.
    // In Cocos2D the render-buffer is already binded (and it's a private property...).
    //glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
    //glBindRenderbufferOES(GL_RENDERBUFFER_OES, glIsRenderbuffer);
    
    // Get the size of the backing CAEAGLLayer
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
    NSInteger dataLength = width * height * 4;
    GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
    
    // Read pixel data from the framebuffer
    glPixelStorei(GL_PACK_ALIGNMENT, 4);
    glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    // Create a CGImage with the pixel data
    // If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
    // otherwise, use kCGImageAlphaPremultipliedLast
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref = CGImageCreate (
                                     width,
                                     height,
                                     8,
                                     32,
                                     width * 4,
                                     colorspace,
                                     // Fix from Apple implementation
                                     // (was: kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast).
                                     kCGBitmapByteOrderDefault,
                                     ref,
                                     NULL,
                                     true,
                                     kCGRenderingIntentDefault
                                     );
    
    // OpenGL ES measures data in PIXELS
    // Create a graphics context with the target size measured in POINTS
    NSInteger widthInPoints, heightInPoints;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
    {
        // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
        // Set the scale parameter to your OpenGL ES view's contentScaleFactor
        // so that you get a high-resolution snapshot when its value is greater than 1.0
        CGFloat scale = eagleView.contentScaleFactor;
        widthInPoints = width / scale;
        heightInPoints = height / scale;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthInPoints, heightInPoints), NO, scale);
    }
    
    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
    
    // UIKit coordinate system is upside down to GL/Quartz coordinate system
    // Flip the CGImage by rendering it to the flipped bitmap context
    // The size of the destination area is measured in POINTS
    CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
    CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);
    
    // Retrieve the UIImage from the current context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //儲存圖片
    if (image) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:path atomically:YES];
        NSLog(@"%@",path);
    }
    UIGraphicsEndImageContext();
    
    // Clean up
    free(data);
    CFRelease(ref);
    CFRelease(colorspace);
    CGImageRelease(iref);
}
@end
