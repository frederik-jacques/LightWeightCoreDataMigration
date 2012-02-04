//
//  MainViewController.h
//  DevineStudents
//
//  Created by Frederik Jacques on 04/02/12.
//  Copyright (c) 2012 dev-dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    
}

@property (nonatomic, weak) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchController;
@property (nonatomic, strong) UITableView *tableview;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context andFrame:(CGRect)frame;

@end
