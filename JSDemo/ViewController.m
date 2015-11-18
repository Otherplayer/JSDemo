//
//  ViewController.m
//  JSDemo
//
//  Created by __无邪_ on 15/11/17.
//  Copyright © 2015年 __无邪_. All rights reserved.
//

#import "ViewController.h"
#import "TestJSObject.h"

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    //网址 js调用OC
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"CallOC" ofType:@"html"];
    //网址 OC调用js
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Basic" ofType:@"html"];
    
    NSURL* httpUrl = [NSURL fileURLWithPath:path];
    NSURLRequest *request=[NSURLRequest requestWithURL:httpUrl];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://blog.csdn.net/lwjok2007/article/details/47058795"]];
    [self.webView loadRequest:request];
    
    
    
    UIButton *callJSButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, 100, 45)];
    [callJSButton setTitle:@"Call JS" forState:UIControlStateNormal];
    [self.view addSubview:callJSButton];
    [callJSButton setBackgroundColor:[UIColor redColor]];
    [callJSButton addTarget:self action:@selector(callJS:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //网页加载之前会调用此方法
    
    //retrun YES 表示正常加载网页 返回NO 将停止网页加载
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    //开始加载网页调用此方法
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //网页加载失败 调用此方法
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    //网页加载完成调用此方法
//    
//    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
//    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    
//    //js调用iOS
//    //第一种情况
//    //其中callOC就是js的方法名称，赋给是一个block 里面是iOS代码
//    //此方法最终将打印出所有接收到的参数，js参数是不固定的 我们测试一下就知道
//    context[@"callOC"] = ^() {
//        NSArray *args = [JSContext currentArguments];
//        
//        __block NSString *paramStr = @"";
//        [args enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"%@",obj);
//            paramStr = [paramStr stringByAppendingFormat:@"参数%ld：%@\n",(long)idx,obj];
//        }];
//        
//        TestJSObject *testJS = [[TestJSObject alloc] init];
//        [testJS TestOneParameter:@" js call oc !"];
////        
////#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
////        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"js call oc successfully !" message:paramStr delegate:nil cancelButtonTitle:@"太帅了！" otherButtonTitles:nil, nil];
////        [alert show];
////#else
////        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"js call oc successfully !" message:paramStr preferredStyle:UIAlertControllerStyleAlert];
////        
////        UIAlertAction *action = [UIAlertAction actionWithTitle:@"太帅了" style:UIAlertActionStyleCancel handler:nil];
////        [alert addAction:action];
////        [self presentViewController:alert animated:YES completion:nil];
////#endif
////
//    };
//    
//}


- (void)callJS:(id)sender{
    
    //OC调用js
    //第二种情况
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *alertJS=@"callJS()"; //准备执行的js代码
    
    [context evaluateScript:alertJS];//通过oc方法调用js的alert
    

}


//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    //网页加载完成调用此方法
//    
//    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
//    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *alertJS=@"alert('test js OC')"; //准备执行的js代码
//    [context evaluateScript:alertJS];//通过oc方法调用js的alert
//    
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //网页加载完成调用此方法
    
    
    
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //第二种情况，js是通过对象调用的，我们假设js里面有一个对象 testobject 在调用方法
    //首先创建我们新建类的对象，将他赋值给js的对象
    
    
    
    context[@"testobject"] = ^() {
        NSArray *args = [JSContext currentArguments];
        NSLog(@"Parameters");
        __block NSString *paramStr = @"";
        [args enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@",obj);
            paramStr = [paramStr stringByAppendingFormat:@"参数%ld：%@\n",(long)idx,obj];
        }];
    };
    
    
    TestJSObject *testJO=[TestJSObject new];
    context[@"testobject"]=testJO;
    //同样我们也用刚才的方式模拟一下js调用方法
//    NSString *jsStr1=@"testobject.TestNOParameter()";
//    [context evaluateScript:jsStr1];
//    NSString *jsStr2=@"testobject.TestOneParameter()";
//    [context evaluateScript:jsStr2];
//    NSString *jsStr3=@"testobject.TestTowParameterSecondParameter('参数A','参数B')";
//    [context evaluateScript:jsStr3];
    
    
}

@end
