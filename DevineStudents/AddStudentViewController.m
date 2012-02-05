//
//  AddStudentViewController.m
//  DevineStudents
//
//  Created by Frederik Jacques on 04/02/12.
//  Copyright (c) 2012 dev-dev. All rights reserved.
//

#import "AddStudentViewController.h"
#import "Student.h"
#import "Group.h"

@implementation AddStudentViewController

@synthesize context = _context;


- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"Add a student";
    root.grouped = YES;
    
    QSection *infoSection = [[QSection alloc] initWithTitle:@"Information"];
    
    QEntryElement *lblFirstname = [[QEntryElement alloc] initWithTitle:@"First name" Value:@""];
    lblFirstname.key = @"firstName";
    
    QEntryElement *lblLastname = [[QEntryElement alloc] initWithTitle:@"Last name" Value:@""];
    lblLastname.key = @"lastName";

    QEntryElement *lblEmail = [[QEntryElement alloc] initWithTitle:@"E-mail" Value:@""];
    lblEmail.key = @"email";
    
    QSection *groupSection = [[QSection alloc] initWithTitle:@"Group"];
    
    QRadioElement *lblGroup = [[QRadioElement alloc] initWithItems:[NSArray arrayWithObjects:@"1DEV1",@"1DEV2",@"1DEV3",@"1DEV4",@"1DEV5",@"1DEV6",nil] selected:0];
    lblGroup.key = @"group";

    [infoSection addElement:lblFirstname];
    [infoSection addElement:lblLastname];
    [infoSection addElement:lblEmail];
    [root addSection:infoSection];
    
    [groupSection addElement:lblGroup];
    [root addSection:groupSection];
        
    self = [super initWithRoot:root];
    if (self) {
        // Custom initialization
        self.context = context;
              
        // Set save button
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doneButtonClicked:)];
        self.navigationItem.rightBarButtonItem = doneButton;
        doneButton = nil;
        
        
    }
    return self;
}

- (void)doneButtonClicked:(id)sender {
    NSLog(@"[AddStudentVC] Save button clicked");
    NSError *error = nil;
    
    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
    student.firstname = [(QEntryElement*)[self.root elementWithKey:@"firstName"] textValue];
    student.lastname = [(QEntryElement*)[self.root elementWithKey:@"lastName"] textValue];
    student.email = [(QEntryElement*)[self.root elementWithKey:@"email"] textValue];

    NSUInteger selectedIndex = [(QRadioElement*)[self.root elementWithKey:@"group"] selected];
    NSString *selectedGroup = [NSString stringWithFormat:@"1DEV%i",(selectedIndex+1)];

    NSFetchRequest *fetchGroup = [NSFetchRequest fetchRequestWithEntityName:@"Group"];
    fetchGroup.predicate = [NSPredicate predicateWithFormat:@"name == %@", selectedGroup];
    
    NSArray *result = [self.context executeFetchRequest:fetchGroup error:&error];
    
    if ( [result count] > 0) {
        NSLog(@"[AddStudentVC] Found group");
        Group *group = [result lastObject];
        
        [group addStudentsObject:student];
        
        if( [self.context save:&error] ){
            NSLog(@"[AddStudentVC] Student added");
            [self dismissModalViewControllerAnimated:YES];
        }else{
            NSLog(@"[AddStudentVC] Error adding student to core data");
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
       
    
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
