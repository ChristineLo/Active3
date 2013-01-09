//
//  Action5ViewController.m
//  Test3D
//
//  Created by Mac06 on 13/1/9.
//
//

#import "Action5ViewController.h"

@interface Action5ViewController ()

@end

@implementation Action5ViewController
@synthesize dic = _dic;
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
    saveFile = [[FileOPs alloc]init];
    _dic = [[NSMutableDictionary alloc] initWithCapacity:15];
    AnswerDic = [[NSMutableDictionary alloc]init];
    disX = 32;
    disY = 30;
    startX =505;
    int startY =568;
	// Do any additional setup after loading the view.
    [self setRadioBtn:@"Ac5Q1" :355];
    [self setRadioBtn:@"Ac5Q2" :415];
    [self setRadioBtn:@"Ac5Q3" :415+disY];
    [self setRadioBtn:@"Ac5Q4" :415+2*disY];
    [self setRadioBtn:@"Ac5Q5" :415+3*disY];
    [self setRadioBtn:@"Ac5Q6" :startY];
    [self setRadioBtn:@"Ac5Q7" :startY+disY];
    [self setRadioBtn:@"Ac5Q8" :startY+2*disY];
    [self setRadioBtn:@"Ac5Q9" :startY+3*disY];
    [self setRadioBtn:@"Ac5Q10" :startY+4*disY];
    [self setRadioBtn:@"Ac5Q11" :startY+5*disY];
    [self setRadioBtn:@"Ac5Q12" :startY+6*disY];
    [self setRadioBtn:@"Ac5Q13" :startY+7*disY];
    [self setRadioBtn:@"Ac5Q14" :startY+8*disY];
    [self setRadioBtn:@"Ac5Q15" :startY+9*disY];
    
}
-(void)setRadioBtn:(NSString *)groupId :(int)startY{
    
    for (int i=0; i<6;i++) {
        RadioButton *rb = [[RadioButton alloc]initWithGroupId:groupId index:i];
        rb.frame = CGRectMake(startX+i*disX, startY, 22, 22);
        [self.view addSubview:rb];
    }
    
    [RadioButton addObserverForGroupId:groupId observer:self];
    
}

-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    //NSLog(@"changed to %d in %@",index,groupId);
    
    [_dic setObject:[NSString stringWithFormat:@"%d",index+1] forKey:groupId];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveToDic{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
    tempDic = [saveFile readFromJsonFile];
    [AnswerDic setDictionary:tempDic];
    for (int i=0; i<[_dic count]; i++) {
        [AnswerDic setObject:[[_dic allValues] objectAtIndex:i] forKey:[[_dic allKeys] objectAtIndex:i]];
    }
    
    [saveFile saveToJsonFile:AnswerDic];
    for (int i = 0; i<[AnswerDic count]; i++) {
        NSLog(@"%@ = %@", [[AnswerDic allKeys] objectAtIndex:i], [[AnswerDic allValues] objectAtIndex:i]);
    }
    
    tempDic=nil;
}

- (IBAction)OK:(id)sender {
    if ([_dic count]==15) {
        //[self saveToDic];
        
        
        UIStoryboard *secondStoryboard = self.storyboard;
        [self presentViewController:[secondStoryboard instantiateViewControllerWithIdentifier:@"ACTend"] animated:YES completion:Nil];
        /*
         UIAlertView *Writedown = [[UIAlertView alloc] initWithTitle:@"活動五" message:@"測驗結束，謝謝您的填答!!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
         Writedown.tag = 0;
         [Writedown show];*/
    }
    else{
        UIAlertView *notWritedown = [[UIAlertView alloc] initWithTitle:@"活動五" message:@"未填寫完成喔!!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [notWritedown show];
    }
    
}
@end
