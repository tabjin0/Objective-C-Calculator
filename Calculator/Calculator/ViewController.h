//
//  ViewController.h
//  Calculator
//
//  Created by Tabbits on 16/11/4.
//  Copyright © 2016年 Tabbits. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;//生成一个property,weak不是strong，nonatomic非线程安全；IBOutlet没有具体类型，只是Xcode用来跟踪哪个property是outlet的，编译器直接将它忽略源于这个类型没有什么实际作用；UILabel＊是property的类型，这是property的名字display

                                                                                                                                                                                                                                                                                                                                                                              

@end


//
//@implementation ViewController
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"value1",@"key1",
//                         @"28", @"age",@"rongfzh",@"name" ,nil];
//    
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(20, 40, 250, 60);
//    label.text = [dic objectForKey:@"name"];
//    [self.view addSubview:label];
//}
//
//@end
//
