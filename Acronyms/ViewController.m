//
//  ViewController.m
//  Acronyms
//
//  Created by Sairam on 9/25/15.
//  Copyright (c) 2015 Sai Ram. All rights reserved.
//

#import "ViewController.h"
#import "ACNetworkLayer.h"
#import "LongForm.h"
#import "LongFormCell.h"
#import "MBProgressHUD.h"

#define BASE_URL @"http://www.nactem.ac.uk/software/acromine/dictionary.py"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *searchTextFiled;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITableView *longFormsTableView;
@property (strong, nonatomic) NSMutableArray *results;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.longFormsTableView.delegate = self;
    self.longFormsTableView.dataSource = self;
    self.longFormsTableView.hidden = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _results.count;
}


- (LongFormCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LongFormCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lf" forIndexPath:indexPath];
    if (cell == nil) {
        cell = (LongFormCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lf"];
    }
    cell.textLabel.text = ((LongForm *)[_results objectAtIndex:indexPath.row]).lf;
    return cell;
}
- (IBAction)searchButtonAction:(id)sender {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    ViewController __weak *weakSelf = self;
    [dict setObject:self.searchTextFiled.text forKey:@"sf"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [ACNetworkLayer fetchMeaningwithGetRequestOnURL:BASE_URL withParams:dict withResultBlock:^(id responseObject, NSError *error) {
            //
            [weakSelf constructLongFormObjectsWithResponse:responseObject withError:(NSError *)error];
            
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
    });
}

-(void)constructLongFormObjectsWithResponse:(NSDictionary *)response withError:(NSError *)error{
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    if ([_results count] == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Info" message:@"No Longforms" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    if ([_results count]>0) {
        self.longFormsTableView.hidden = NO;
    }
    
    NSArray *lfs = [response objectForKey:@"lfs"];
    _results = [[NSMutableArray alloc] init];
    for (id obj in lfs) {
        LongForm *lf = [[LongForm alloc] init];
        lf.freqs = [obj objectForKey:@"freq"];
        lf.vars = [obj objectForKey:@"vars"];
        lf.lf = [obj objectForKey:@"lf"];
        [_results addObject:lf];
    }
    [_longFormsTableView reloadData];
}
@end
