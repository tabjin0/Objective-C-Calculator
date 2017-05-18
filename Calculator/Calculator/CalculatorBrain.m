//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Tabbits on 16/11/6.
//  Copyright © 2016年 Tabbits. All rights reserved.
//

#import "CalculatorBrain.h"

/*需要一个private接口，因为这个栈是model私有的*/
@interface CalculatorBrain()
//下面创建一个指针类型property，NSMutableArray *
/*将不在使用操作数栈operandStack，改为使用运算和操作数栈programStack*/
@property (nonatomic,strong) NSMutableArray *programStack;//一定要strong，因为只有我们在用这个指针，strong会告诉编译器怎么管理内存NSMutableArray，operandStack,obj-c中的NSArray不能删除数组，所以要用NSMutableArray
@end


@implementation CalculatorBrain

@synthesize programStack = _programStack;//合成之后这样才能有setter和getter
/*对nonatomic来说，这两个就是synthesize生成的*/
- (NSMutableArray *)operandStack {//operandStack的getter
    /*问题1解决方案,lazy instantiation(延迟实例化)*/
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];//如果operandStack为空，就分配一个数组，这样就不会得到一个nil的opearndStack，因为如果是空的话就分配一个.这里是一个延迟实例化
    /*问题1解决方案*/
    return _programStack;
}

- (void)setOperandStack:(NSMutableArray *)programStack
{//operandStack的setter
    _programStack = programStack;
}
/*对nonatomic来说，这两个就是synthesize生成的*/


- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];//用NSNumber将operand这个double包装成对象，所以NSNumber是用来把数字封装成对象
    [self.programStack addObject:operandObject];//入栈操作很简单，获取了operandStack，然后调用MutableArray的方法addObject，因为入栈事添加对象；补充说明：读取_operandStack只能在setter和getter里面进行，不需要在代码其他地方
    
//    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
    //问题1：property创建的时候值是0或者nil，但是发消息给nil时什么也不发生；上面的代码此时是nil，什么也不发生，什么也不做，所以需要一个构造函数来设置它，obj－c中有构造函数叫initiallizer，但这不是进行构造的最佳位置，确保operandStack非nil的最佳位置是在它的getter中
}
/*此时popOperand已经不需要了，因为有了programStack出栈，可以删除popOpearand*/
//- (double)popOperand
//{
//    NSNumber *operandObject = [self.operandStack lastObject];//获取栈顶的数字,lastObjet就是数组最后一个对象的指针而不是一个副本
//    if (operandObject != nil) [self.operandStack removeLastObject];//要小心对空数组做移除操作，不是nil是空，程序会崩溃，这里选择lastObject不会崩溃，但是移除酒会崩溃，所以要添加判断operandObject非nil
//    return [operandObject doubleValue];//现在有了最后一个对象，然后返回它的double值；反思：这是操作数出栈，但现在只是查找到了操作数，还需要用removeLastObject来移除操作数
//}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];//先可以直接添加运算符到栈上，如此栈上就有了操作数和运算符
//    return [CalculatorBrain runProgram:self.program];//program有个implement
    return [[self class] runProgram:self.program];//NSString的实例都有一个方法class，返回这份实例的类名，就是继承啊
}

/*不对program使用synthesize，只用getter，同时getter也印证了只读！只读就是没有setter的实现，可以考虑什么样的cookie可以用来返回计算程序的本质，基本上是要返回program，我们的内部数据结构*/
//问题！！！第一个，self.programStack是内部变量，绝对不能办一个内部变量交给一个公共方法，即使是id，因为用内省的方法可以来破坏它，要记住绝对不能把内部的数据结构放出来；另一个问题是property的语义，当我获取program时要的是那个时候的program，不是已经修改了的program，所以要一个快照。
- (id) program
{
    return [self.programStack copy];//简单复制就可以解决上面的问题，copy做了两件事情，第一件事就是生成了一个副本，而不是把原本内部数据交出去；第二件事就是可变数组的copy会返回不可变的数组，不能修改。现在即使得到了program，用内省也不能干什么。
}

/*计算程序program的描述*/
+ (NSString *)descriptionOfProgram:(id) program
{
    return @"Implement this in assignment 2";
}


/*实现popOperandOfStack类方法*/
+ (double)popOperandOfStack:(NSMutableArray *)stack
{
    double result = 0;
    /*中间放递归操作*/
    
    id topOfStack = [stack lastObject];//设topOfStack为stack的最后一个元素，这边设置为id是因为topOfStack可能是数字，也可能是字符串，如果topOfStack为nil也不会有什么，下面所有的if都不会被执行，也会最后返回0

    if (topOfStack)[stack removeLastObject];//如果topOfStack非nil，就移除最后一个元素。如果stack这边倒是值得考虑，因为不能空数组不能移除元素
    /*通过内省判断topOfStack是数字还是字符串*/
    if ([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    }else if([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;//将topOfStack赋值给本地变量operation，这是一个id类型转换为静态类型的；这边也可以直接一个个将operation改成topOfStack，太麻烦了；这边是一个简单有效的方法。
        
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOfStack:stack]+[self popOperandOfStack:stack];//结果等于栈顶两个数相加，此时会遇到一个error，因为我们还没有popOperand的实现
        } else if ([@"*" isEqualToString:operation]) {//这里在给一个字符串常量发消息是可以的，因为常量字符串和其他字符串没有区别，operation是字符串，(NSString *)operation也是字符串，@"*"也是字符串
            result = [self popOperandOfStack:stack] * [self popOperandOfStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            result = -[self popOperandOfStack:stack] + [self popOperandOfStack:stack];
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOfStack:stack];
            if (divisor) {
                result = [self popOperandOfStack:stack] / divisor;
            } else {
                result = 0;
            }
        }
    }
    /*中间放递归操作*/
    return result;//如果传进来的是什么非数字非字符串，也就是排除上面两个if的情况，两个if都不满足，就会返回result，也就有个初始result为0，也就返回0
}
/*runprogram改进为能够使用变量*/
+ (double)runProgram:(id)program
{
    //获取一个我们能执行的计算程序，传过来的不可变数组需要转变会可变的数组才能继续操作；要小心如果传过来的是随便一个对象，不能崩溃，每次使用参数是id的公共接口都要使用内省来保护错误的参数
    NSMutableArray *stack;//先建一个本地变量，可变数组stack，也可以写成等于nil，ios5以上默认是nil，这里可以不用写nil
    
    /*使用内省判断program是不是数组，然后再赋值给stack*/
    if([program isKindOfClass:[NSArray class]]){//判断program是不是一个NSArray数组类型
        stack=[program mutableCopy];//现在就有了本地变量stack，此处也做了一个可变复制，因为runProgram使用递归的方法吧栈上的东西都消化掉，需要让它可变。有一点，program是一个NSArray，这边的stack是静态类型，mutableCopy返回id，id和静态类型相互赋值是可以的，compiler不会警告
    }
        //还需要一个方法，且必须是类方法，因为runprogram是类方法，该方法主要对结果进行出栈,如果栈顶十个数字，就返回数字，如果栈顶是个运算符就求值
    return [self popOperandOfStack:stack];//新建一个方法popOperandOfStack，然后返回它
}

    //放入一个局部变量，返回它，中间放注释
    double result = 0;
    
    //执行运算，根据运算符出栈
//    if ([operation isEqualToString:@"+"]) {
//        result = [self popOperand]+[self popOperand];//结果等于栈顶两个数相加，此时会遇到一个error，因为我们还没有popOperand的实现
//    } else if ([@"*" isEqualToString:operation]) {//这里在给一个字符串常量发消息是可以的，因为常量字符串和其他字符串没有区别，operation是字符串，(NSString *)operation也是字符串，@"*"也是字符串
//        result = [self popOperand] * [self popOperand];
//    } else if ([operation isEqualToString:@"-"]) {
//        result = -[self popOperand] + [self popOperand];
//    } else if ([operation isEqualToString:@"/"]) {
//        double divisor = [self popOperand];
//        if (divisor) {
//            result = [self popOperand] / divisor;
//        } else {
//            result = 0;
//        }
//    }
//    [self pushOperand:result];//把结果压回到栈中，因为要继续操作(版本2将这个不用，是因为在栈里面消耗的东西就不需要在放进去了)
//    return result;
//}
//以上是两个public方法，要实现这歌brain，需要一个栈来保存操作数、入栈运算出栈运算，用数组来实现
//现在需要private接口，因为这个栈不是公共的，入栈出栈需要在model中来进行

/*调试：用Calculator Brain来尝试给Calculator Brain来实现描述方法*/
- (NSString *)description {//描述方法返回一个NSString，描述方法的名称直接叫description,，返回任何我们返回的字符串来描述我们的Calculator Brain，随时都与calculatorbrain相关的东西就是它的栈Stack
    return [NSString stringWithFormat:@"stack = %@",self.operandStack];
}
/*result断点，lldb：po self，输出栈，这样可以更容易的NSlog自己的对象，并且更容易的像这样在调试器中输出它们，通常实现description很容易，因为大多数自己的属性其实都是某种类，它们自己又description，然后就可以像这样输出，或者直接获取它们的description*/

@end


//model，接受操作数，返回操作结果；平方和开方只需要一个操作数；pi不需要操作数，返回pi不用任何操作数，所以根据需求从栈中提取不同的操作数
