//
//  ViewController.m
//  Calculator
//
//  Created by Tabbits on 16/11/4.
//  Copyright © 2016年 Tabbits. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

/*private方法：@interface 类名 大括号 来创建private接口*/
@interface ViewController ()
/*新建一个private property,nonatomic,布尔型（no为0，yes为非0）*/
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;//用户是否在输入中，基本类型property
@property (nonatomic,strong) CalculatorBrain *brain;//几乎每个controller都会有这么一个private的property，strong的，还需要synthesize
@end

@implementation ViewController

@synthesize display = _display;//此时controller已经可以开始向label发话了；synthesize已经生成了setter和getter，setter用来设置指针，当storyboard被读取到画面出现在屏幕上，ios就会调用setter去创建连接到label，当我们想要和label对话的时候就去调用getter，得到他的指针，发送消息
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];//用到Lazy Instantiation（延迟实例化），alloc由NSObject完成
    return _brain;
}//现在无论什么时候调用getter，brain一定已经实例化，这也能在不是真正用到property的时候保护getter




/*controller和view的另一个连接，target action，所以controller要有一个target来接受键盘按钮发送的action（按下按钮）*/
- (IBAction)digitPressed:(UIButton *)sender {//将id改成UIButton ＊
    //IBAction事实上就是void，用IBActoin是要让Xcode知道这是一个action，仅此而已，哥们，我是action！
    //方法名是digitPressed，这是参数的类型
    //当按钮被按，就发消息给controller，消息包含了参数，这个参数就是发送者自己，此处就是按钮；
    //在obj－c中，id是很重要的类型，是个可以指向任何类型的指针，或者理解为指向未知类型的指针，所以在这里，任何对象都可以传递过来，这是件好事
    //如果把鼠标放在property上，看到所有的按钮发送同样的消息，都一样因为复制粘贴，所有输入键和运算键不要复制粘贴数字键，也就是像＋－＊／和enter这样的键，因为并不需要运算键发送数字消息和运算消息
    NSString *digit = sender.currentTitle;//[sender currentTitle]; 创建一个局部变量一个string指针，NSString＊表示一个指向NSString的指针，digit是变量名;[]在obj－c中用来发消息，sender是按键反馈发消息的目标；输入cu之后要指定id，上面将id修改为UIButton *,这样就会出现button的方法,这样就有button上网title，并复制到局部变量digit里面
    /*
    NSLog(@"digit pressed = %@",digit);//一个debug方法，有点像printf，不同之处在于它接受NSString而不是const char＊;%@表示对应的格式是一个对象;NSlog会发送一个description到那个对象，这个description方法会返回一个NSString来显示这个%@;NSString遇到description会返回自己，因为它需要一个NSString来描述自己，而它自己就是NSString，那么就返回自己;这里填入digit，会返回digit里面的string，也就是标题
}
//这里所有的数字按钮都会发送一样的target action，复制粘贴按钮，也复制了它的target action
     */

    /*过程一*/
    /*
    UILabel *myDisplay = self.display;//[self display];// 创建一个局部变量，名叫myDisplay的UILabel，获取值的方法是发getter到self的label
    NSString *currentText = myDisplay.text;//[myDisplay text];NSString局部变量currentText，发消息到myDisplay方法来获取
    NSString *newText = [currentText stringByAppendingString:digit];//需要一个新的string，表示合成之后的string，叫做newText;这里用到一个NSString方法，stringByAppendingString,就是发一个string到另一个string，返回两个连接在一起的string
    myDisplay.text = newText;//[myDisplay setText:newText];
     */
    /*过程二：简化代码*/
    /*
//    UILabel *myDisplay = self.display;//[self display];
//    NSString *currentText = self.display.text;//[myDisplay text]
//    NSString *newText = [currentText stringByAppendingString:digit];//需要一个新的string，表示合成之后的string，叫做newText;这里用到一个NSString方法，stringByAppendingString,就是发一个string到另一个string，返回两个连接在一起的string
    self.display.text = [self.display.text stringByAppendingString:digit];//[myDisplay setText:newText];意思是  我的display.text＝我的display.text+appending.text
    */
    /*过程三：除去0*/
    /*此时label中的0比较讨厌，现在需要一些private数据来跟踪是否处在输入过程中*/
    
    if (self.userIsInTheMiddleOfEnteringANumber) {//如果用户在输入中就显示把数字附上去，如果不是就开始一个新的
        self.display.text = [self.display.text stringByAppendingString:digit];//[myDisplay setText:newText];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;//  如果开始了新的数字，就肯定是在输入中，所以就设为YES
    }
}

/*将操作数入栈到model，需要一个指向model的指针brain*/
- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];//将这个字符串当作NSNumber发到doubleValue
    self.userIsInTheMiddleOfEnteringANumber = NO;//按了enter，意味着输入结束
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];//如果用户在输入中就帮用户按enter，“6 enter 3 enter ＋”  VS  “6 enter 3 ＋”
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g",result];//上面的是一个double，需要将它转化成字符串来表示，新建一个字符串用类方法stringWithFormat初始化，％g表示float。后面的这个NSString不是实例，而是一个类方法
    self.display.text = resultString;

}
@end
