//
//  AddItemViewController.m
//  Checklists
//
//  Created by Matthijs on 30-09-13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ChecklistItem.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController
{
    NSDate *_dueDate;
    BOOL _datePickerVisible;//控制是否可见datepicker
}

-(void)dateChanged:(UIDatePicker *)datePicker
{
    _dueDate=datePicker.date;
    [self updateDueDateLabel];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //重写cellforrowatindexpath，就是返回一个cell的方法
    if (indexPath.section==1&&indexPath.row==2)//第一步，检查这个indexpath是不是
        //给date picker准备的，如果不是，那么就跳转到5
    {
        //是为picker准备的，那么就询问是否已经有了对应的datepickercell
        UITableViewCell *cell=
        [tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
        //如果没有
        if (cell==nil)
        {
            //首先做一个cell出来，使用default style，并且将identifier命名为datepickercell
            cell=[[UITableViewCell alloc]
                  initWithStyle:UITableViewCellStyleDefault
                  reuseIdentifier:@"DatePickerCell"];
            //设定对应的selectionstyle
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //设置一个datepicker的component（这就是一个定义好的datepicker）
        UIDatePicker *datePicker=[[UIDatePicker alloc]
                                  initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 216.0f)];
        datePicker.tag=100;
            if (@available(iOS 13.4, *)) {
                datePicker.preferredDatePickerStyle=UIDatePickerStyleWheels;
            } else {
                // Fallback on earlier versions
            }
        [cell.contentView addSubview:datePicker];
        
            //让datapicker 执行datachanged这个方法，对于每次时间的修改（下面要重写datachanged）
        [datePicker addTarget:self action:@selector(dateChanged:)
             forControlEvents:UIControlEventValueChanged];
        }
        return cell;
    }else
    {
        //对于不是data picker的index-paths，super，就是普通的方法，这样就是即可以针对data picker自定义，也可以不用定义了
        //super就是原始方法
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    if (section==1 &&_datePickerVisible)
    {
       //如果data picker可见，seciton1从此有三个row，不然就是原来的方法，这就是判定需要多少copy cell
        return 3;
    }
    else
    {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这里就是返回在一个特定位置出现的row究竟需要多高
    if (indexPath.section==1&&indexPath.row==2)
    {
        //datapicker
        return 217.0f;//datapicker稍微高一点
    }
    else
    {
        return [super tableView:tableView
        heightForRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这里就是重写选中每一行之后的动作，
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];//首先取消选中 选中其他row就是直接deselect了
    
    
    [self.textField resignFirstResponder];//textfieldresponder
    if (indexPath.section==1&&indexPath.row==1)//如果indexpath是1行1列
    {
        if (!_datePickerVisible)
        {
            //不可见，变得可见
            [self showDatePciker];//变得可见
        }else
        {
            [self hideDatePicker];//可见 变得不可见
        }
        
    }
    //如果是第三
}
-(void) hideDatePicker
{
    if (_datePickerVisible)
    {
        //处于可见的状态
        _datePickerVisible=NO;//设置为不可见的状态
        NSIndexPath *indexPathDateRow=[NSIndexPath
                                       indexPathForRow:1 inSection:1];
        NSIndexPath *indexPathDatePicker=[NSIndexPath
                                          indexPathForRow:2 inSection:1];
        
        UITableViewCell *cell=[self.tableView
                               cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor=[UIColor
                                        colorWithWhite:0.0f alpha:0.5f];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView
         deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}
- (void) showDatePciker
{
    _datePickerVisible=YES;//展示了datepicker，那么就将datepicker的visible视为可见
    
    //首先dateRow是在布局里面第二个section里面的第二行（第一行是一个choose按钮）
    
    NSIndexPath *indexPathDateRow=[NSIndexPath
                                   indexPathForRow:1 inSection:1];
    
    //section1里面的第三行作为datepicker
    NSIndexPath *indexPathDatePicker=
    [NSIndexPath indexPathForRow:2 inSection:1];//设置第二个seciton里面的第二行
    
    
    //根据对应的indexpath叫出cell
    UITableViewCell *cell=[self.tableView
                           cellForRowAtIndexPath:indexPathDateRow];
    cell.detailTextLabel.textColor=
    cell.detailTextLabel.tintColor;//修改cell的detailedtextlabel
    
    [self.tableView beginUpdates];
    //beginupdate方法，用于给uitableview进行批量操作，
    //从beginupdate到endupdate下面是一系列的方法，这样做的好处就是，即使每一个独立的方法
    //会对view进行各种变更，但是，这两个方法之间的所有的方法会在对数据源更新完毕后，一口气执行
    //一整套的view变更，从而看不出究竟是执行顺序
    
    
    [self.tableView
     insertRowsAtIndexPaths:@[indexPathDatePicker]
     withRowAnimation:UITableViewRowAnimationFade];
    
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    UITableViewCell *datePickerCell=[
                                     self.tableView
                                     cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker=(UIDatePicker *)
    [datePickerCell viewWithTag:100];//根据tag：100找到picker
    
    [datePicker setDate:_dueDate animated:NO];//根据_dueDate去设置时间
    
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

    if (self.itemToEdit!=nil)
    {
        self.title=@"edit Item";
        self.textField.text=self.itemToEdit.text;//self.textfield就是设定在property里作为这个vc一个属性的textfield，itemtoedit是一个property，也就是这个东西里面的内容，内容肯定是不变的
        self.doneBarButton.enabled=YES;//A调用B，在B里面就直接将这个button enable就可以了，因为A调B就是使用了这个viewDidLoad的方法
        self.switchControl.on=self.itemToEdit.shouldRemind;
        _dueDate=self.itemToEdit.dueDate;
    }else
    {
        self.switchControl.on=NO;
        _dueDate=[NSDate date];
    }
    [self updateDueDateLabel];
}
- (void)updateDueDateLabel
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    self.dueDateLabel.text=[formatter stringFromDate:_dueDate];
}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel
{
  [self.delegate itemDetailViewControllerDidCancel:self];
}

- (IBAction)done
{
  if (self.itemToEdit == nil) {
      //说明是add模式，add模式下，done按钮直接造一个item出来
    ChecklistItem *item = [[ChecklistItem alloc] init];
    item.text = self.textField.text;
    item.checked = NO;
    item.shouldRemind=self.switchControl.on;
    item.dueDate=_dueDate;
    //item.itemId=
      //该设置的设置好
      
      [item  scheduleNotification];
    [self.delegate itemDetailViewController:self didFinishAddingItem:item];//通过delegate（这个是在prepareforsegue里设置好的），把这个东西交给它处理）


  } else {
    self.itemToEdit.text = self.textField.text;
      self.itemToEdit.shouldRemind=self.switchControl.on;
      self.itemToEdit.dueDate=_dueDate;
      
      [self.itemToEdit scheduleNotification];
    [self.delegate itemDetailViewController:self didFinishEditingItem:self.itemToEdit];
  }
    //
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //willselectrowatindexpath指名了点击的那一瞬间发生的事情，这个时候，如果点击的是datepicker，那么就要返回对应的
    //indexpath，这样才能方便did里面根据indexpath找到是不是选中了
    if (indexPath.section==1&&indexPath.row==1)
    {
        return indexPath;
    }
    else
    {
        return nil;
    }
}
- (NSInteger)tableView:(UITableView*)tableView
indentationLevelForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //这个就是设置cell里显示的数据向后缩进的东西
    //让一个tableview去返回一个indentation的level，给一个indexpath
    //这是一个indentation，就是给一个indexpath，返回对应的缩进
    if (indexPath.section==1 &&indexPath.row==2)
    {
        //这是picker的位置，就是返回newIndexPath的一个缩进
        NSIndexPath *newIndexPath=
        [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        //根据indexpath的section和row去设置一个新的indexpath
        
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
        
        //为什么会崩溃？因为这个时候complier不知道有关section=1，row=2的任何信息，它不是写在stroyboard上面的，
        //所以即使将这个picker cell塞入了data source，也需要通过这个函数告诉complier它有关的信息
    }else
    {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];//否则就是原来的
    }
    
}

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];

  self.doneBarButton.enabled = ([newText length] > 0);
	
  return YES;
}

@end
