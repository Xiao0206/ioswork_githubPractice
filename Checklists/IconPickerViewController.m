//
//  IconPickerViewController.m
//  Checklists
//
//  Created by mac on 2021/4/19.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

#import "IconPickerViewController.h"

@interface IconPickerViewController ()

@end

@implementation IconPickerViewController
{
    NSArray *_icons;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _icons=@
    [
     @"No Icon",
     @"Appointments",
     @"Birthdays",
     @"Chores",
     @"Drinks",
     @"Folder",
     @"Groceries",
     @"Inbox",
     @"Photos",
     @"Trips"
     ];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return [_icons count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[
                           tableView
                           dequeueReusableCellWithIdentifier:@"IconCell"];//这里的cell名字叫做IconCell，首先从这里抽取出原形cell
    NSString *icon=_icons[indexPath.row];//然后根据对应的row拿到icon
    cell.textLabel.text=icon;//拿到icno的名字
    cell.imageView.image=[UIImage imageNamed:icon];//拿到icon的图标
    //实际上cell里面的这些东西都是一个个的property，在uitableviewcell这个类里面定义的，但是一般来说都是nil，你这里只是定义了而已
    return cell;//return，这就是一个列表cell必备的东西
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //一个tap动作触发了1.cellforrowatindexpath 2.didselectrowatindexpath
    NSString *iconName=_icons[indexPath.row];
    [self.delegate iconPicker:self didPickIcon:iconName];
}
@end
