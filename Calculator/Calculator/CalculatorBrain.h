//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Tabbits on 16/11/6.
//  Copyright © 2016年 Tabbits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
/*添加public方法，这是RPM计算机的大脑，它只需要做两个public的事，把操作数入栈和完成栈上的操作*/
- (void)pushOperand:(double)operand;//运算对象（操作数）
- (double)performOperation:(NSString *)operation;
/*上面的栈是model私有的*/

/*添加新的APIs*/
@property (readonly) id program;//这边用id的API可以返回任意类型；设置为只读的原因只是让demo更快，所以只能获取这个property但不能设置它。其实完全可读可写。这里没有设置指向strong还是weak，他是一个指向堆的指针，但是没有设置一个指向堆的指针，它只是返回这个指针，它是只读的。若调用的人可能需要把它保存在某变量（如本地变量或者实例变量里面，这个变量才需要是strong或者weak）。本地变量都是strong的，但是只存在于方法内，而用来存放property则需要指出是strong还是weak。
+ (double)runProgram:(id)program;//事实上runProgram就是对栈顶操作数出栈，如果栈顶的不是操作数，即返回一个栈顶的数字。比如3 enter 3 enter 6 enter，得到的是6。如果栈顶是一个运算符，那就返回运算符的double值
+ (NSString *)descriptionOfProgram:(id)program;//despritionOfProgram返回一个可读的用来放在Ui上的描述
@end
