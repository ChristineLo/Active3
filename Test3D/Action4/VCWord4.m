//
//  VCWord4.m
//  Test3D
//
//  Created by Mac06 on 12/12/14.
//
//

#import "VCWord4.h"

@interface VCWord4 ()

@end

@implementation VCWord4

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnStart:(UIButton *)sender {
    [self addLeafAlert];
}

//離開提示
- (void) addLeafAlert
{
    UIAlertView *leafAlert = [[UIAlertView alloc] initWithTitle:sLEAF_WORD message:Nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
    [leafAlert show];
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIStoryboard *secondStoryboard = self.storyboard;
        [self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"ACT4"] animated:YES completion:Nil];
    }
}
@end
