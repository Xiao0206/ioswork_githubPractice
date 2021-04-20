#import "ListDetailViewController.h"
#import "Checklist.h"
@interface ListDetailViewController ()

@end

@implementation ListDetailViewController
{
    NSString *_iconName;//需要用这个instance variable去追踪究竟是哪个icon
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.checklistToEdit !=nil)
    {
        self.title=@"Edit Checklist";
        self.textField.text=self.checklistToEdit.name;
        self.doneBarButton.enabled=YES;
        _iconName=self.checklistToEdit.iconName;
    }
    self.iconImageView.image=[UIImage imageNamed:_iconName];

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //按住icon触发segue的时候会调用这个函数，以前这个函数什么都没有，这里就记录一下destination的controller，然后把delegate设置为自己
    //宣一下能实现这个delegate的是自己
 
    
    if ([segue.identifier isEqualToString:@"PickIcon"])//这个vc能有segue的只有icon一条路可以走，所以根据pickIcon拿出segue后就可以在调用segue前使用prepare
    {
        IconPickerViewController *controller=
        segue.destinationViewController;//拿到对面的controller
        controller.delegate=self;
    }
}
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self=[super initWithCoder:aDecoder]))
    {
        _iconName=@"Birthdays";//用initWithCoder生成的时候，默认是Birthday
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    //这也是一个抽象方法在这里重新写 在该view即将出现的时候需要做一些什么
    [super viewWillAppear:animated];//上层类的实现，之前的先做好
    [self.textField becomeFirstResponder];//让textfield编程第一个responder，也就是进去时候textfield在一闪闪
}

-(IBAction)cancel
{
    //左部cancel对应的事件
    [self.delegate listDetailViewControllerDidCancel:self];//调用这个方法
    
}
-(IBAction)done
{
    //右部按钮done对应的事件
    if (self.checklistToEdit==nil)
    {
        //上面是一个checklist对象，checklist包含的就是一个name
        Checklist *checklist=[[Checklist alloc]init];//造一个checklist
        
        checklist.name=self.textField.text;
        
        checklist.iconName=_iconName;
        
        [self.delegate
                 listDetailViewController:self
          didFinishAddingChecklist:checklist];
        
        
    }
    else
    {
        self.checklistToEdit.name=self.textField.text;
        
        self.checklistToEdit.iconName=_iconName;
        
        [self.delegate listDetailViewController:self didFinishEditingChecklist:
         self.checklistToEdit];
    }
}

-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //给一个tableview给一个willslectrowatindexpath，意味着即将select对应row的时候执行的操作
   if (indexPath.section==1)
   {
       //第二个section
       return indexPath;
   }else
   {
       return nil;//第0个，就是普通的就是nil
   }
}
-(BOOL)textField:(UITextField*) theTextField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString *newText=[theTextField.text //textfield里面的text
                       stringByReplacingCharactersInRange:range
                       withString:string];
    self.doneBarButton.enabled=([newText length]>0);
    return YES;
    
}
-(void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)theIconName
{
    _iconName=theIconName;
    self.iconImageView.image=[UIImage imageNamed:_iconName];
    [self.navigationController popViewControllerAnimated:YES];//动作
}
@end
