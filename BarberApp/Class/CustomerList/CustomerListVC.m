//
//  CustomerListVC.m
//  BarberApp
//
//  Created by Manan on 8/23/17.
//  Copyright © 2017 Deepesh. All rights reserved.
//

#import "CustomerListVC.h"
#import "CustomerListCell.h"
#import "Customer.h"
@interface CustomerListVC ()
{
    __weak IBOutlet UITableView *tableViewCustomerList;
    HTTPService  *httpServiceObject;
    NSMutableArray * arrayModel;
    NSString       *appId;
    NSString       *userId;
    NSInteger modelRow;
   
    __weak IBOutlet UILabel *barberNameLbl;
}
@property (weak, nonatomic) IBOutlet UIView *confrimCustmView;
@property (weak, nonatomic) IBOutlet UIView *confirmationView;
- (IBAction)confirmButtonAction:(id)sender;

- (IBAction)backButtonAction:(id)sender;

@end

@implementation CustomerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    APPDELEGATE.currentVC = @"Reservations";
    
    self.title = @"CLAIM RESERVATIONS";
    [self setupView];
    // Do any additional setup after loading the view.
    [APPDELEGATE.reservationTimer invalidate];
    APPDELEGATE.reservationTimer = nil;
    APPDELEGATE.reservationTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(timeOutActionReservation) userInfo:nil repeats:NO];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeOutActionReservation) name:@"timeOutActionReservation" object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    APPDELEGATE.currentVC = @"";
    [APPDELEGATE.reservationTimer invalidate];
    APPDELEGATE.reservationTimer = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)timeOutActionReservation {
    
     APPDELEGATE.currentVC = @"";
   
    [APPDELEGATE.reservationTimer invalidate];
     APPDELEGATE.reservationTimer = nil;
    [self backButtonAction:nil];
}

-(void)setupView {
    
//    tableViewCustomerList.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBg.png"]];
//    tableViewCustomerList.backgroundView.alpha = 0.5f;
    
    [_confrimCustmView setHidden:YES];
    [_confirmationView setHidden:YES];
    
    httpServiceObject = [[HTTPService alloc] init];
    NSString *baseURLString = BASE_URL;
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURLSessionConfiguration *urlSession = [NSURLSessionConfiguration defaultSessionConfiguration];
    httpServiceObject = [[HTTPService alloc] initWithBaseURL:baseURL andSessionConfig:urlSession];
    
    if ([CommonFunctions connectedToNetwork]) {
        [MBProgressHUD showHUDAddedTo:APPDELEGATE.window animated:YES];
        [self callApi:@"customers" withParams:nil isFirstTime:YES];
    }
    else
        [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrayModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"HomeTableViewCell";
    
    CustomerListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomerListCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Customer *model =  [arrayModel objectAtIndex:indexPath.row];
    
    cell.labelCustomerName.text = model.customer_name;
    cell.labelCount.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    [cell.barberImage1 setImageWithURL:[NSURL URLWithString:model.image_url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    cell.barberImage1.clipsToBounds = YES;
    cell.labelCustomerName.textColor = [UIColor whiteColor];
    cell.labelTime.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
   // [cell setBackgroundColor:[UIColor colorWithRed:72.0f/255.0f green:72.0f/255.0f blue:72.0f/255.0f alpha:0.8f]];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    Customer *model = [arrayModel objectAtIndex:indexPath.row];
    appId = model.appointment_id;
    userId = model.user_id;
    barberNameLbl.text = model.customer_name;
    modelRow = indexPath.row;
    [_confirmationView setHidden:NO];
    [_confirmationView setFrame:CGRectMake(0, 0-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [UIView animateWithDuration:0.2
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // bottomConstraintPopUpVw.constant = 0;
                         _confirmationView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    


}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90.0f;
}

- (IBAction)confirmButtonAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        [_confirmationView setHidden:YES];
    } else {
        
        if ([CommonFunctions connectedToNetwork]) {
            
            [CommonFunctions showActivityIndicatorWithText:@"Claiming.." detailedText:@"Please wait!"];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:appId,@"appointment_id", userId, @"user_id" ,nil];
            [self callApi:@"claim_reservation" withParams:dict isFirstTime: NO];
        }
        else
            [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
    }


}

- (IBAction)backButtonAction:(id)sender {
    
     APPDELEGATE.currentVC = @"";
    [APPDELEGATE.reservationTimer invalidate];
    APPDELEGATE.reservationTimer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Web service methods

#pragma mark - Webservice Method

-(void) callApi:(NSString *) _apiName withParams:(NSMutableDictionary*)params isFirstTime: (BOOL)isFirstTime {
    
    /**
     *Pass token in Header
     *{"token":"7647fb1c906e09434ba7a09476d49f52"}
     */
    
    NSDictionary *userInfoDictionary = (NSDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO];
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    
    [headers setObject:[[userInfoDictionary objectForKey:@"data"] objectForKey:@"token"] forKey:@"token"];
    
    NSLog(@"Walkin Request:%@",params);
    
    [httpServiceObject startRequestWithHttpMethod:kHttpMethodTypePost withHttpHeaders:headers withServiceName:_apiName withParameters:params withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"response - %@",responseObject);
        
        NSError* error;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                           options:kNilOptions
                                                                             error:&error];
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = [response statusCode];
        
        NSLog(@"Home response - %@",responseDictionary);
        
        NSDictionary *dataDict = [responseDictionary valueForKey:@"data"];
        
       
         [MBProgressHUD hideHUDForView:APPDELEGATE.window animated:YES];
        
        if (statusCode == 200) {
            
            if (isFirstTime == YES) {
                _dataArray = [NSMutableArray arrayWithArray:[[responseDictionary objectForKey:@"data"] objectForKey:@"customers"]];
                if (_dataArray.count > 0 ) {
                    [self createCustomerModel:_dataArray];
                return ;
            }
            }
            if ([[dataDict valueForKey:@"msg"] isEqualToString:@"Claim reservation successfully."]) {
                
                [arrayModel removeObjectAtIndex:modelRow];
                [tableViewCustomerList reloadData];
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
                singleTap.numberOfTapsRequired = 1;
                
                [_confrimCustmView addGestureRecognizer:singleTap];
                
                
                [_confirmationView setHidden:YES];
                [_confrimCustmView setHidden:NO];
                
                [self performSelector:@selector(singleTap) withObject:nil afterDelay:2.0];
                
                
                
                [_confrimCustmView setFrame:CGRectMake(0, 0-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
                [_confrimCustmView setBackgroundColor:[UIColor colorWithRed:72.0f/255.0f green:72.0f/255.0f blue:72.0f/255.0f alpha:0.80]];
                [UIView animateWithDuration:0.2
                                      delay:0.2
                                    options: UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     _confrimCustmView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                                 }
                                 completion:^(BOOL finished){
                                     
                                     [self.navigationController popViewControllerAnimated:YES];
                                     [[NSNotificationCenter defaultCenter]
                                      postNotificationName:@"FromCustomerList"
                                      object:self];
                                 }];
                

            }
                
        }else
        {
            int tag = 8;
            if([_apiName isEqualToString:@"customers"])
                tag = 11;
            
            [CommonFunctions alertTitle:@"Tonic" withMessage:[NSString stringWithFormat:@"%@",[[responseDictionary objectForKey:@"data"] objectForKey:@"msg"]] withDelegate:self withTag:tag];
        }
        
    } withFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error - %@",[error localizedDescription]);
        [MBProgressHUD hideHUDForView:APPDELEGATE.window animated:YES];
    }];
}
-(void) singleTap{
    
    [_confrimCustmView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_confrimCustmView setBackgroundColor:[UIColor colorWithRed:72.0f/255.0f green:72.0f/255.0f blue:72.0f/255.0f alpha:0.80]];
    [UIView animateWithDuration:0.2
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _confrimCustmView.frame = CGRectMake(0, 0-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)createCustomerModel: (NSMutableArray*)listArray {
    
    arrayModel = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < listArray.count; i++) {
        
        Customer *model = [[Customer alloc]init];
        model.appointment_id = [[[listArray objectAtIndex:i] valueForKey:@"User"] valueForKey:@"appointment_id"];
        model.user_id = [[[listArray objectAtIndex:i] valueForKey:@"User"] valueForKey:@"id"];
        model.customer_name = [[[listArray objectAtIndex:i] valueForKey:@"User"] valueForKey:@"name"];
        model.image_url = [[[listArray objectAtIndex:i] valueForKey:@"User"] valueForKey:@"image"];
        [arrayModel addObject:model];

    }
     [tableViewCustomerList reloadData];
}
@end
