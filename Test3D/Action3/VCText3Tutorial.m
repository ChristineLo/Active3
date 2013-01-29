//
//  VCText3Tutorial.m
//  Test3D
//
//  Created by gdlab on 12/12/27.
//
//

#import "VCText3Tutorial.h"

@interface VCText3Tutorial ()

@end

@implementation VCText3Tutorial
@synthesize undoButton;
@synthesize redoButton;
@synthesize clearButton;
@synthesize eraserButton;
@synthesize whitePenButton;
@synthesize blackPenButton;
@synthesize defaultButton;
@synthesize rotateButton;
@synthesize depthButton;
@synthesize switchButton;
@synthesize curColor;

@synthesize ulCountDownTime;
@synthesize toolBar;
@synthesize smallView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self init3D];
    [self initDraw];
    
    [self initButton];
    
    editState = TWO_D;
    [self checkEditState];
    
    UIButton *skipButton = (UIButton*) [self.view viewWithTag: 2001];
    [skipButton addTarget:self action:@selector(switchNextAction) forControlEvents:UIControlEventTouchUpInside];
    if (skipButton == NULL) {
        NSLog(@"button is null");
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    //[threeDLayer release];
}

//進入活動三頁面
-(void)switchNextAction{
    [director popScene];
    
    UIStoryboard *secondStoryboard = self.storyboard;
    [self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"ACT3"] animated:YES completion:Nil];
}

- (void)init3D
{
    [CCDirector setDirectorType:kCCDirectorTypeDisplayLink];
    director = [CCDirector sharedDirector];
    [director setAnimationInterval:1.0/30];
    [director setDisplayFPS:NO];
    
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
    
    [self.smallView addSubview:glView];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    threeDLayer = [MainLayer node];
    CCScene *scene = [CCScene node];
    [scene addChild:threeDLayer];
    [[CCDirector sharedDirector] runWithScene:scene];
    //一開始的編輯模式
    [threeDLayer setEditMode:EMode3DTransfer];
}

- (void)initDraw
{
    slv = [[[SmoothLineView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + kMENU_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - kMENU_HEIGHT)] autorelease];
    slv.delegate = self;
    
    [smallView addSubview:slv];
    
    self.curColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [threeDButtons dealloc];
    [twoDButtons dealloc];
    [director dealloc];
    [slv dealloc];
    [tCountDownTimer dealloc];
    [ulCountDownTime dealloc];
    [threeDLayer dealloc];
}

-(void)setButtonAttrib:(UIGlossyButton*)_button
{
    [_button useWhiteLabel: YES];
    _button.buttonCornerRadius = 2.0; _button.buttonBorderWidth = 1.0f;
	[_button setStrokeType: kUIGlossyButtonStrokeTypeBevelUp];
    _button.tintColor = _button.borderColor = [UIColor colorWithRed:70.0f/255.0f green:105.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
}

- (void) initButton
{
    undoButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1001];
    [self setButtonAttrib:undoButton];
    
    redoButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1002];
    [self setButtonAttrib:redoButton];
    
    clearButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1003];
    [self setButtonAttrib:clearButton];
    
    eraserButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1004];
    [self setButtonAttrib:eraserButton];
        
    blackPenButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1005];
    [self setButtonAttrib:blackPenButton];
    
    whitePenButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1006];
    [self setButtonAttrib:whitePenButton];
    
    [blackPenButton setEnabled: YES];
    [whitePenButton setEnabled: YES];
    
    if (twoDButtons == NULL) {
        twoDButtons = [[NSArray arrayWithObjects:undoButton, redoButton, clearButton, eraserButton, blackPenButton, whitePenButton, nil] retain];
    }
    
    defaultButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1008];
    [self setButtonAttrib:defaultButton];
    
    rotateButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1009];
    [self setButtonAttrib:rotateButton];
    
    depthButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1010];
    [self setButtonAttrib:depthButton];
    
    if (threeDButtons == NULL) {
        threeDButtons = [[NSArray arrayWithObjects:defaultButton, rotateButton, depthButton, nil] retain];
    }
    
    switchButton = (UIGlossyButton*) [self.toolBar viewWithTag: 1007];
    [self setButtonAttrib:switchButton];
    [switchButton setEnabled:YES];
}

-(void) setThreeDButtonVisible:(BOOL) isEnable
{
    for (UIGlossyButton *aButton in threeDButtons) {
        [aButton setHidden:!isEnable];
        [aButton setEnabled:isEnable];
    }
}

-(void) setTwoDButtonVisible:(BOOL) isEnable
{
    for (UIGlossyButton *aButton in twoDButtons) {
        [aButton setHidden:!isEnable];
    }
}

-(void) checkEditState {
    switch (editState) {
        case THREE_D:
            [slv setUserInteractionEnabled:NO];
            [slv setIsAccessibilityElement:NO];

            [smallView setMultipleTouchEnabled:YES];
            UIGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGuestureHandler:)];
            [smallView addGestureRecognizer:pinch];
            
            [self setThreeDButtonVisible:YES];
            [self setTwoDButtonVisible:NO];
            break;
        case TWO_D:
            [slv setUserInteractionEnabled:YES];
            [slv setIsAccessibilityElement:YES];
            [smallView removeGestureRecognizer:[smallView.gestureRecognizers lastObject]];
            
            [self setThreeDButtonVisible:NO];
            [self setTwoDButtonVisible:YES];
            break;
        default:
            break;
    }
}

#pragma mark Guesture Movement
-(void) pinchGuestureHandler:(UIPinchGestureRecognizer*) guesture
{
    [threeDLayer scaleModel:guesture.scale];
}

#pragma mark Button Click Event

-(IBAction)undoButtonClicked:(id)sender
{
    [slv undoButtonClicked];
    
}

-(IBAction)redoButtonClicked:(id)sender
{
    [slv redoButtonClicked];
    
}

-(IBAction)clearButtonClicked:(id)sender
{
    [slv clearButtonClicked];
}

-(IBAction)eraserButtonClicked:(id)sender
{
    [slv eraserButtonClicked];
}

-(IBAction)blackPenButtonClicked:(id)sender
{
    [slv drawButtonClicked];
    slv.lineColor = [UIColor blackColor];
}

-(IBAction)whitePenButtonClicked:(id)sender
{
    [slv drawButtonClicked];
    slv.lineColor = [UIColor whiteColor];
}

-(IBAction)save2FileButtonClicked:(id)sender
{
    //[slv save2FileButtonClicked];
    [slv save2File:kFILE_ANS];
}

-(IBAction)defaultButtonClicked:(id)sender
{
    [threeDLayer setEditMode:EMode3DTransfer];
}
-(IBAction)rotateButtonClicked:(id)sender
{
    [threeDLayer setEditMode:EMode3DRotate];
}
-(IBAction)depthButtonClicked:(id)sender
{
    [threeDLayer setEditMode:EMode3DZDepth];
}

-(IBAction)switchEditStateButtonClicked:(id)sender
{
    (editState == THREE_D)? (editState = TWO_D): (editState = THREE_D);
    [self checkEditState];
}

#pragma mark toolbarDelegate
-(void) setUndoButtonEnable:(NSNumber*)isEnable
{
    [undoButton setEnabled:[isEnable boolValue]];
}
-(void) setRedoButtonEnable:(NSNumber*)isEnable
{
    [redoButton setEnabled:[isEnable boolValue]];
}
-(void) setClearButtonEnable:(NSNumber*)isEnable
{
    [clearButton setEnabled:[isEnable boolValue]];
}
-(void) setEraserButtonEnable:(NSNumber*)isEnable
{
    [eraserButton setEnabled:[isEnable boolValue]];
}
-(void) setBlackPenButtonEnable:(NSNumber*)isEnable
{
    [blackPenButton setEnabled:[isEnable boolValue]];
}
-(void) setWhitePenButtonEnable:(NSNumber*)isEnable
{
    [whitePenButton setEnabled:[isEnable boolValue]];
}

@end
