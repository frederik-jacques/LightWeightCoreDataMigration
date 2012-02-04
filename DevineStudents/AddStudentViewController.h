//
//  AddStudentViewController.h
//  DevineStudents
//
//  Created by Frederik Jacques on 04/02/12.
//  Copyright (c) 2012 dev-dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddStudentViewController : QuickDialogController {

}

@property (nonatomic, weak) NSManagedObjectContext *context;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
