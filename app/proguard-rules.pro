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
