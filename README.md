#Protable
Portable，与具体业务无关的纯净、便捷的类库。

支持IOS6及以上系统。

###Portable诞生的目的
每次启动一个新项目时，总是得话费大把时间从旧工程中搜寻拷贝新项目可用的类，还要进行一些配置工作。为了减少这些工作量，Portable类库诞生了。

###Portable简介
Portable分两部分：Core和Extended
####Core 
项目中必须使用到的类和组件。如：崩溃捕获、网络状态监控、缓存等，还有个皮肤管理类，可支持换肤，此外还有一些Category。
####Extended
在Core之外的扩展，可选择使用里面的类和组件。


##使用
1. 将Protable目录拷贝到本地，引入工程中，如果多个工程使用它，建议不要选中Copy items if needed选项。
2. 在Build Settings -> Search Paths-> Header Search Paths 中加入：../Protable/Core路径和../Protable/extensions路径

##TODO
1. Demo里增加换肤例子
2. 增加第三方登录、分享、统计等普遍使用的功能模块。
3. 做成项目模板。
