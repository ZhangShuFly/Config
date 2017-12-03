## Proguard方式混淆

### Tip

混淆只能是增加代码被反编译的难度，并不能完全保证APP的安全。甚至通过加壳的方式，也只是增加了反编译的难度，依然有可能被反编译。但是不能因此就不进行混淆，这是对待安全的态度问题。

我们更应该从代码设计的角度去增加APP的安全性，比如重要的业务放在服务器完成，客户端验证的数据后台也要进行验证，重要数据客户端加密，特别是不要把重要数据如密码不加密放在sd卡中，发布版本中关闭日志打印等等。程序设计的安全性不好，使用再多的混淆、加密也没有用

### 作用

混淆之后的APP即使被反编译，代码也会变得难以阅读，提升安全性。

Proguard除了混淆之后，还有压缩、优化、预检的作用。

压缩：默认开启，减少应用体积，移除未被使用的方法和类。

优化：默认开启，在字节码级别进行优化。

混淆：默认开始，类和方法名字会被随机命名。

预检： Android不需要预检，去掉这一步可以加快混淆速度。

### 实现

**app/build.gradle**

     buildTypes {
            debug{
                minifyEnabled false
                signingConfig signingConfigs.debug
            }
            release {
                minifyEnabled true
                signingConfig signingConfigs.release
                proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            }
        }
        
**app/proguard-rules.pro** 

    命令	|   作用
    ------------- | -------------  
    -keep	|   防止类和成员被移除或者被重命名
    -keepnames  | 	防止类和成员被重命名
    -keepclassmembers   |	防止成员被移除或者被重命名
    -keepnames	|   防止成员被重命名
    -keepclasseswithmembers	    |   防止拥有该成员的类和成员被移除或者被重命名
    -keepclasseswithmembernames	    |   防止拥有该成员的类和成员被重命名
    

文件中由完整的注释
    
        #-------------------------------------------定制化区域----------------------------------------------
        #---------------------------------1.实体类---------------------------------
        
        #实体类由于涉及到与服务端的交互，各种gson的交互如此等等
        #-keep class 你的实体类所在的包.** { *; }
        
        
        #-------------------------------------------------------------------------
        
        #---------------------------------2.第三方包-------------------------------
        
        #根据使用的第三方包，从github上复制下来
        #-keep public class * implements com.bumptech.glide.module.GlideModule
        #-keep public class * extends com.bumptech.glide.module.AppGlideModule
        #-keep public enum com.bumptech.glide.load.resource.bitmap.ImageHeaderParser$** {
        #  **[] $VALUES;
        #  public *;
        #
        
        #本地包
        #-libraryjars log4j-1.2.17.jar
        #-dontwarn org.apache.log4j.**
        #-keep class  org.apache.log4j.** { *;}
        
        
        #-------------------------------------------------------------------------
        
        #---------------------------------3.与js互相调用的类------------------------
        
        #第三部分与js互调的类，工程中没有直接跳过。一般你可以这样写
        #-keep class 你的类所在的包.** { *; }
        
        #如果是内部类的话，你可以这样
        
        #-keepclasseswithmembers class 你的类所在的包.父类$子类 { <methods>; }
        
        #例如
        #-keepclasseswithmembers class com.demo.login.bean.ui.MainActivity$JSInterface {
        #      <methods>;
        #}
        
        
        #-------------------------------------------------------------------------
        
        #---------------------------------4.反射相关的类和方法-----------------------
        #第四部分与反射有关的类
        #-keep class 你的类所在的包.** { *; }
        
        #----------------------------------------------------------------------------
        #---------------------------------------------------------------------------------------------------
        
        #-------------------------------------------基本不用动区域--------------------------------------------
        #---------------------------------基本指令区----------------------------------
        -optimizationpasses 5   #代码压缩级别
        -dontusemixedcaseclassnames  #不使用大小写混合类名
        -dontskipnonpubliclibraryclasses    #不跳过library中的非public的类
        -dontskipnonpubliclibraryclassmembers   #不跳过library中的非public的类的方法
        -dontpreverify  #不预检
        -verbose    #保存混淆信息文件
        -printmapping proguardMapping.txt   #混淆信息文件名称
        -optimizations !code/simplification/cast,!field/*,!class/merging/*  #混淆算法
        -keepattributes *Annotation*,InnerClasses   #不混淆注解、内部类
        -keepattributes Signature   #不混淆泛型
        -keepattributes SourceFile,LineNumberTable  #保留行号
        #----------------------------------------------------------------------------
        
        #---------------------------------默认保留区---------------------------------
        -keep public class * extends android.app.Activity
        -keep public class * extends android.app.Application
        -keep public class * extends android.app.Service
        -keep public class * extends android.content.BroadcastReceiver
        -keep public class * extends android.content.ContentProvider
        -keep public class * extends android.app.backup.BackupAgentHelper
        -keep public class * extends android.preference.Preference
        -keep public class * extends android.view.View
        -keep public class com.android.vending.licensing.ILicensingService
        -keep class android.support.** {*;}
        
        #不混淆native方法以及类。
        -keepclasseswithmembernames class * {
            native <methods>;
        }
        
        #不混淆activity中参数为view的方法（xml中onclick指定的方法）
        -keepclassmembers class * extends android.app.Activity{
            public void *(android.view.View);
        }
        #不混淆枚举类中的values()和valueOf()方法
        -keepclassmembers enum * {
            public static **[] values();
            public static ** valueOf(java.lang.String);
        }
        
        #不混淆自定义view
        -keep public class * extends android.view.View{
            *** get*();
            void set*(***);
            public <init>(android.content.Context);
            public <init>(android.content.Context, android.util.AttributeSet);
            public <init>(android.content.Context, android.util.AttributeSet, int);
        }
        
        #保持自定义控件类不被混淆
        -keepclasseswithmembers class * {
            public <init>(android.content.Context, android.util.AttributeSet);
            public <init>(android.content.Context, android.util.AttributeSet, int);
        }
        #不混淆实现Parcelable接口的类
        -keep class * implements android.os.Parcelable {
          public static final android.os.Parcelable$Creator *;
        }
        #不混淆实现Serializable接口内的方法
        -keepclassmembers class * implements java.io.Serializable {
            static final long serialVersionUID;
            private static final java.io.ObjectStreamField[] serialPersistentFields;
            private void writeObject(java.io.ObjectOutputStream);
            private void readObject(java.io.ObjectInputStream);
            java.lang.Object writeReplace();
            java.lang.Object readResolve();
        }
        #不混淆R文件
        -keep class **.R$* {
         *;
        }
        #对于带有回调函数的onXXEvent的，不能被混淆
        -keepclassmembers class * {
            void *(**On*Event);
        }
        #----------------------------------------------------------------------------
        
        #---------------------------------webview------------------------------------
        -keepclassmembers class fqcn.of.javascript.interface.for.Webview {
           public *;
        }
        -keepclassmembers class * extends android.webkit.WebViewClient {
            public void *(android.webkit.WebView, java.lang.String, android.graphics.Bitmap);
            public boolean *(android.webkit.WebView, java.lang.String);
        }
        -keepclassmembers class * extends android.webkit.WebViewClient {
            public void *(android.webkit.WebView, jav.lang.String);
        }
        #----------------------------------------------------------------------------
        #---------------------------------------------------------------------------------------------------
