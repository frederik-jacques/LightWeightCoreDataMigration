//
//  MainViewController.m
//  DevineStudents
//
//  Created by Frederik Jacques on 04/02/12.
//  Copyright (c) 2012 dev-dev. All rights reserved.
//

#import "MainViewController.h"
#import "AddStudentViewController.h"
#import "Student.h"

@implementation MainViewController

@synthesize context = _context;
@synthesize tableview = _tableview;
@synthesize fetchController = _fetchController;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context andFrame:(CGRect)frame {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.view.frame = frame;
        self.title = @"Student overview";
        
        self.context = context;
        
        // Add 'add' button to navigation controller
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked:)];
        self.navigationItem.rightBarButtonItem = addButton;
        addButton = nil;
        
        // Add tableview to view
        self.tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        [self.view addSubview:self.tableview];
        
        // Setup Fetch Result Controller
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        self.fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
        self.fetchController.delegate = self;
        
        NSError *error = nil;
        if( [self.fetchController performFetch:&error] ){
            NSLog(@"[MainVC] Fetch succeeded");
        }else{
            NSLog(@"[MainVC] Fetch failed");
        }
        
    }
    return self;
}

- (void)addButtonClicked:(id)sender {
    NSLog(@"[MainVC] Add button clicked");   
    AddStudentViewController *studentVC = [[AddStudentViewController alloc] initWithManagedObjectContext:self.context];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:studentVC];
    [self presentModalViewController:navCon animated:YES];
}

#pragma mark - UITableViewDelegate methods

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"StudentCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    
    }
    
    Student *student = [self.fetchController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstname, student.lastname];
    return cell;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - NSFetchedResultsControllerDelegate methods
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"[MainVC] Model changed");
    [self.tableview reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
