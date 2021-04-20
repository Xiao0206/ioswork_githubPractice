//
//  ChecklistsViewController.h
//  Checklists
//
//  Created by Matthijs on 30-09-13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"
#import "Checklist.h"//注意在这里要把head文件加进去
@interface ChecklistsViewController : UITableViewController <ItemDetailViewControllerDelegate>

@property (nonatomic,strong) Checklist *checklist;
//增加property checklist

@end
