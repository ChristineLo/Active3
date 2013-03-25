//
//  Action5ViewController.m
//  CreatTest
//
//  Created by Mac04 on 13/1/3.
//  Copyright (c) 2013年 Mac04. All rights reserved.
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
    disX = 40;
    disY = 38;
    startX =523;
    int startY3=500;
    int startY2=295;
    int startY1=85;
    [self setQusetionImage];
	// Do any additional setup after loading the view.
    [self setRadioBtn:@"Ac5Q1" :0];
    [self setRadioBtn:@"Ac5Q2" :startY1];
    [self setRadioBtn:@"Ac5Q3" :startY1+disY];
    [self setRadioBtn:@"Ac5Q4" :startY1+2*disY];
    [self setRadioBtn:@"Ac5Q5" :startY1+3*disY];
    [self setRadioBtn:@"Ac5Q6" :startY2];
    [self setRadioBtn:@"Ac5Q7" :startY2+disY];
    [self setRadioBtn:@"Ac5Q8" :startY2+2*disY];
    [self setRadioBtn:@"Ac5Q9" :startY2+3*disY];
    [self setRadioBtn:@"Ac5Q10" :startY2+4*disY];
    
    [self setRadioBtn:@"Ac5Q11" :startY3];
    [self setRadioBtn:@"Ac5Q12" :startY3+disY];
    [self setRadioBtn:@"Ac5Q13" :startY3+2*disY];
    [self setRadioBtn:@"Ac5Q14" :startY3+3*disY];
    [self setRadioBtn:@"Ac5Q15" :startY3+4*disY];
        
}
-(void)setQusetionImage{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 430, 764, 400)];
    scrollView.contentSize = CGSizeMake(764, 800);
    //scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    image = [UIImage imageNamed:@"ActionQuestion5_2.png"];
    imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 764, 697);
    [scrollView addSubview:imageView];
    
}
-(void)setRadioBtn:(NSString *)groupId :(int)startY{
    
    for (int i=0; i<6;i++) {
        RadioButton *rb = [[RadioButton alloc]initWithGroupId:groupId index:i];
        rb.frame = CGRectMake(startX+i*disX, startY, 33, 33);
        [scrollView addSubview:rb];
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
    
    [tempDic release];
    
    Storyboard = self.storyboard;
    [self presentViewController:[Storyboard instantiateViewControllerWithIdentifier:@"ACTend"] animated:YES completion:Nil];
    
}

- (IBAction)OK:(id)sender {
    if ([_dic count]==15) {
        [self saveToDic];
    }
    else{
        notWritedown = [[UIAlertView alloc] initWithTitle:@"活動五" message:@"未填寫完成喔!!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [notWritedown show];
    }
    
}
-(void)dealloc{
    [image release];
    [imageView release];
    [AnswerDic release];
    [scrollView release];
    [saveFile release];
    [notWritedown release];
    [super dealloc];
}
-(void)viewDidUnload{
    [super viewDidUnload];
}
@end
