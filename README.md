# Valid-Ready-Handshake
2022.5.16更新
skid buffer添加了一级流水线

/***************************************************/

2022.5.12更新
更新了Backward_Registered写法
采用if else语句以及组合逻辑实现，个人认为比FSM实现要方便。

/********************************************************/

Forward_Registered和Backward_Registered模块中注释掉的代码为之前版本的写法

对Backward_Registered的理解
Ready信号打拍的实现方法为：当Master端发送请求但Slave端未就绪时将data暂存于寄存器中，并将valid_skid拉高，表示下一次Slave准备好接收数据时读取暂存于寄存器中的数据。
valid_skid信号的控制有另一种写法，已更新在Backward_Registered模块中

