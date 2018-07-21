# DDPuzzle
## 前言
偶然的一次机会在Steam上发现这样一个游戏软件[链接](https://store.steampowered.com/app/857440/Hentai_Puzzle)，点击进入链接之后我想你会眼前一亮，荷尔蒙会上升，心里默念“WoCao”，没错，这款软件有点偏色情（阴险状），这款软件简直跟宅男们带来了福音，虽然只是非常常见的拼图游戏，但是下载量炒鸡的火爆，这也情有可原，毕竟露肉，哈哈，评论区的评论也是一片好声，该软件也从刚开始3块升级到了6块，不过现在又降到了3块🤣。（咳咳，我没下载这个软件，只是大致看了看预览图还有游戏简介之类的），就在一瞬间，脑袋里又冒出一个想法，如果写个苹果版本的，是不是也会这么火呢，其实当时自己心里也犯嘀咕，苹果会不会因为稍微有点露肉而被拒，但是后来想了想既然是二次元图片，会不会侥幸过审，再说也不是特别的露肉，于是自己说干就干，开始设计开发这款软件。

## 过程
首先是大致设计了整体的思路，这是初稿的内容：

```
1.游戏除了成就列表，所有文字都是英文，字体要选一种特殊的细体

2.首页：只有一个标题，两个按钮（开始，成就）

3.成就：即成就列表，展示现在完成的成就

4.开始：开始游戏，开始之后是关卡选择

5.关卡选择：只有前一关通关，才展示下一关，通关的关卡图标是该关卡的图片，没通关的是一把锁
		   每一关都有一个标题，例如SUMMER、HONEY

6.进入游戏界面：点击拼图会有音效，最好每个关卡的敏感部位音效和其他部分音效是不一样的，害羞的那种
			  点击拼图最好有浮动动画
			  
7.成就设计：未定
```
然后大致设计了一下整体的界面，前期看起来还是比较low的，但是一步步的改进，最终达到了自己满意。
接下来从各大网站还有APP上找各种稍微有点露肉的高清动漫图片，讲真，找的时候看的我也是欲罢不能🤣，紧接着是用ps把图片切割成正方形，手动切割的主要目的是可以把露肉的部分切割出来🤣，这样才能更加吸引用户嘛，哈哈。后来就开始写代码啦，因为还有公司的项目要写嘛，所以也只能下班时候才写，就这样持续了两周吧，终于把APP写好了。最后就是上架啦，果不其然，上架的第二天就被打回来了---存在令人厌恶的内容🤣，后来自己又是重新找图片，把那些露肉的图片给替换掉，其实前一二次替换的时候那些图片也只是露腿，但是依旧被拒，依旧是相同的原因，后来自己索性把图片换成那种什么都不露的，但是还是被拒了，WTF。忍无可忍了简直，然后我给他们发邮件:

```
These pictures are all downloaded from an iPhone APP. Why is it okay in their app? Ours is considered to be an objectionable content. In addition, we have changed the rating to more than 12 years old, and it is permissible to have occasional/slight erotic nudity at that level. And we did not find any objectionable content in this rejected attachment. I hope you will review the app again seriously. Thank you.

```
然后第二天他们给回复邮件：

```
We noticed that your app icons, screenshots, or other metadata items include content that is not appropriate for all age groups. Specifically, your app description and screenshots contained objectionable content inappropriate for all ages.

Next Steps

To resolve this issue, please revise your metadata to ensure that all items are appropriate for a 4+ age rating. Since this content is visible on the App Store by all users, even when purchasing is restricted by the app's rating, this content must meet the requirements for a 4+ rating.

For resources on metadata best practices, you may want to review the App Store Product Page information available on the Apple developer portal.

While your App Store Connect Application State shows as Metadata Rejected, we still require a new binary to correct this issue.
```
大致意思是我得把APP做成在适用于4岁+的，也就是说虽然我把那个等级设置成了12岁+，但是没有用，这个APP必须得试用于4岁+。哎，，，我已经把所有的图片给换掉了，换的图片上的人都捂的严实的很，APP logo我也没发现异常，APP预览图也没有问题，为何还是被拒，心累呀，现在先把项目放放吧，到时候再看着改改重新提交吧。其实还有一种解决方案的，就是写后台代码，通过后台进行控制图片显示，但是现在苦于不会也是没法子呀。

## APP介绍
视频连接：[链接](http://www.iqiyi.com/w_19rymcs54d.html)）（这个是初始的）
APP游戏部分分为三个场景，分别是Dear、Honey、Summer，每个模块下包括5个关卡。进入游戏之后，根据可以点击Auto让其自动完成，当然，让其自动完成是要收费的🤣，最后根据完成的时候会给你相应的分数，最高是4分。另外，APP中还加入了Game Center可以查看玩家的排行榜。

## 2018-07-03更新
经过对界面的大改，终于过审了，哈哈哈。[下载链接](https://itunes.apple.com/cn/app/yi-xiao-tong-meng-yu-ban/id1397291723?mt=8)
简书地址：[地址](https://www.jianshu.com/p/42eb78ef2070)

## 2018-07-21更新
APP大改版，去掉了GameCenter，去掉了场景，用户自己选择壁纸进行拼图，高清壁纸时常更新，玩游戏下载壁纸，并且可以对壁纸进行涂鸦，添加文字，添加滤镜，添加贴纸。并且添加了VIP功能（收费的哦），解锁VIP之后可以下载任意的壁纸。


## 截图

![1.png](https://upload-images.jianshu.io/upload_images/6635229-e5bae88959caadf3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![2.png](https://upload-images.jianshu.io/upload_images/6635229-4716c572852ace97.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![3.png](https://upload-images.jianshu.io/upload_images/6635229-9d2e813360381004.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![4.png](https://upload-images.jianshu.io/upload_images/6635229-78824c77d018af42.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![5.png](https://upload-images.jianshu.io/upload_images/6635229-08f1670d9852807f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![6.png](https://upload-images.jianshu.io/upload_images/6635229-750b08896fa6e298.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![7.png](https://upload-images.jianshu.io/upload_images/6635229-9f6d48aa7b3db51b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![8.png](https://upload-images.jianshu.io/upload_images/6635229-ee3c40fe9cb95dcf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 后记
其实写这个也算是一篇开发中的随笔吧。

## About Me
邮箱：herodys@163.com 
欢迎发邮件提建议，阿里嘎多！
