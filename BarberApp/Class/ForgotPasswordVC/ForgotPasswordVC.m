//
//  ForgotPasswordVC.m
//  BarberApp
//
//  Created by Pankaj Asudani on 09/03/16.
//  Copyright © 2016 Deepesh. All rights reserved.
//

#import "ForgotPasswordVC.h"

@interface ForgotPasswordVC ()

//Middle transparent view
@property (nonatomic, weak) IBOutlet UIView *midVw;

//EMAIL Field
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setUpView];
}

-(void) setUpView{
    
    _midVw.layer.cornerRadius = 10.0f;
    
    //SetUp HTTP initially
    _httpServiceObject = [[HTTPService alloc] init];
    NSString *baseURLString = BASE_URL;
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURLSessionConfiguration *urlSession = [NSURLSessionConfiguration defaultSessionConfiguration];
    _httpServiceObject = [[HTTPService alloc] initWithBaseURL:baseURL andSessionConfig:urlSession];
    
    //Add a tap Gesture
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}

#pragma mark- SingleTapGesture Selector

-(void) singleTap{
    
    [self.view endEditing:YES];
}

#pragma mark- IBAction Methods

-(IBAction)submitBtnPressed:(id)sender{
    
    [self.view endEditing:YES];
    
    if ([CommonFunctions connectedToNetwork]) {
        
        if ([self validate]) {
            
            //Call Webservice
            [CommonFunctions showActivityIndicatorWithText:@"Submitting.." detailedText:@"Please Wait"];
            [self loadApi];
        }
    }
    else
    {
        [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
    }
    
}

-(IBAction)backBtnPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Webservice Method

-(void) loadApi{
    
    /**
     *{"email":"nimtej@yopmail.com"}
     */
    
    //API Parameter dictionary
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_emailTextField.text,@"email", nil];
    
    [_httpServiceObject startRequestWithHttpMethod:kHttpMethodTypePost withHttpHeaders:nil withServiceName:@"forgot_password" withParameters:paramDictionary withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"response - %@",responseObject);
        
        NSDictionary *responseDictionary = (NSDictionary*)responseObject;
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = [response statusCode];
        
        if (statusCode == 200) {
            
            //Show success alert
            [self successAlert];
        }
        else
        {
            [CommonFunctions alertTitle:@"Tonic" withMessage:[NSString stringWithFormat:@"%@",[[responseDictionary objectForKey:@"data"] objectForKey:@"msg"]]];
        }
        
        [CommonFunctions removeActivityIndicator];
        
    } withFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error - %@",[error localizedDescription]);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

#pragma mark- Other Method

-(void) successAlert{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tonic" message:[NSString stringWithFormat:@"A new Password has been sent to your email address.\nThank You!"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
        [self.navigationController popViewControllerAnimated:TRUE];
    }];
    
    [alertController addAction:okAlert];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark- Validation

-(BOOL) validate{
    
    BOOL isValid = TRUE;
    
    if (_emailTextField.text.length <= 0) {
        
        isValid = FALSE;
        [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"EMAIL_BLANK", nil)];
    }
    else if (![Validate isValidEmailId:_emailTextField.text]){
        
        isValid = FALSE;
        [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"EMAIL_INVALID", nil)];
    }
    
    return isValid;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
