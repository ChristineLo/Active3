//
//  VCTest3.m
//  Test3D
//
//  Created by gdlab on 12/12/3.
//
//

#import "VCTest3.h"

@interface VCTest3 ()

@end

@implementation VCTest3
@synthesize vEditView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CCDirector setDirectorType:kCCDirectorTypeDisplayLink];
    CCDirector *director = [CCDirector sharedDirector];
    [director setAnimationInterval:1.0/30];
    [director setDisplayFPS:YES];
    
    EAGLView *glView = [CC3EAGLView viewWithFrame:self.view.frame
                                      pixelFormat:kEAGLColorFormatRGBA8
                                      depthFormat:GL_DEPTH24_STENCIL8_OES
                               preserveBackbuffer:NO
                                       sharegroup:Nil
                                    multiSampling:NO
                                  numberOfSamples:4];
    
    [glView setMultipleTouchEnabled:YES];
    
    [director setOpenGLView:glView];
    
    if (![director enableRetinaDisplay:YES]) {
        CCLOG(@"Retina Display Not supported");
    }
    
    self.view = glView;
    
    //myGlkView = glView;
    //[self.view addSubview:glView];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    /*
    CC3Layer* cc3Layer = [Test3DLayer node];
	[cc3Layer scheduleUpdate];
	
	// Create the customized 3D scene, attach it to the layer, and start it playing.
	cc3Layer.cc3Scene = [Test3DScene scene];
    
	ControllableCCLayer* mainLayer = cc3Layer;
    */
    CCScene *scene = [CCScene node];
    [scene addChild:[MainLayer node]];
    [[CCDirector sharedDirector] runWithScene:scene];
    
#pragma mark - controll buttons
    /*
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 100)];
    myView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myView];
    */
    
}

- (void)dealloc
{
    [vEditView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
