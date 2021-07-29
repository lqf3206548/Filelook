package com.example.documentencryptionplus

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.database.Cursor
import android.icu.text.IDNA
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.PersistableBundle
import android.provider.MediaStore
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.lang.Exception
import kotlin.math.log

class MainActivity : FlutterActivity() {
    companion object{
        init {
            System.loadLibrary("native-lib")        }
    }
    external fun Encryption(inputpath:String,outputpath:String,index : Int):Int;
    external fun Decrypt(inputpath:String,outputpath:String,index : Int):Int;
    var methodChannel: MethodChannel? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "com.example.documentencryptionplus")
        methodChannel!!.setMethodCallHandler { call, res ->
try {


            // 根据方法名，分发不同的处理
            when (call.method) {
                "filepower" -> {
                    Log.i("调用", "task1")
                    getFileRWRoot()
                }
                "start"->{
                    var path: String = call.argument<String>("filepath") as String
                    var index: Int = call.argument<Int>("index") as Int
                    var algorithmIndex: Int = call.argument<Int>("algorithmIndex") as Int
                    Log.i("lqf","文件路径:${path},算法下标:${index},加密标识符:${algorithmIndex},")
                    if (path.equals("") || path.length==0){
                        Toast.makeText(this, "请选择文件", Toast.LENGTH_SHORT).show();
                        return@setMethodCallHandler
                    }
                    if (index==-1){
                        Toast.makeText(this, "请选择算法", Toast.LENGTH_SHORT).show();
                        return@setMethodCallHandler
                    }
                    path = Environment.getExternalStorageDirectory().getAbsolutePath() +path
                    when(algorithmIndex){
                        1->{
                            var pathp = path.split(".")
                            var outputPath =pathp[0]+"-Encryption."+pathp[1]
                            Log.i("lqf","加密输出路径:${outputPath}")
                            when(Encryption(path,outputPath,index)){
                                -1->{
                                    Toast.makeText(this,"出现异常",Toast.LENGTH_SHORT).show();
                                }
                                1->{
                                    Toast.makeText(this,"加密成功",Toast.LENGTH_SHORT).show();
                                }
                                3->{
                                    Toast.makeText(this,"抱歉此算法暂未实现",Toast.LENGTH_SHORT).show();

                                }
                            }
                        }
                        2->{
                            var pathp = path.split(".")
                            var outputPath = pathp[0]+"-Decryption."+pathp[1]
                            Log.i("lqf","outputPath:${outputPath}")
                            when(Decrypt(path,outputPath,index)){
                                -1->{
                                    Toast.makeText(this,"出现异常",Toast.LENGTH_SHORT).show();
                                }
                                1->{
                                    Toast.makeText(this,"解密成功",Toast.LENGTH_SHORT).show();
                                }
                                3->{
                                    Toast.makeText(this,"抱歉此算法暂未实现",Toast.LENGTH_SHORT).show();
                                }
                            }
                        }
                    }

                }
                else -> {
                    // 如果有未识别的方法名，通知执行失败
                    res.error("error_code", "error_message", null)
                }
            }
}catch (e:Exception){
    e.printStackTrace()
    Toast.makeText(this,"程序出现异常，请反馈qq2817923638并备注问题反馈",Toast.LENGTH_SHORT).show();

}
        }
    }

    fun getFileRWRoot() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {
            //用户已经拒绝过一次，再次弹出权限申请对话框需要给用户一个解释
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission
                            .WRITE_EXTERNAL_STORAGE)) {
                Toast.makeText(this, "请开通相关权限，否则无法正常使用本应用！", Toast.LENGTH_SHORT).show();
            }
            var drp = arrayOf("android.permission.READ_EXTERNAL_STORAGE",
                    "android.permission.WRITE_EXTERNAL_STORAGE")
            //申请权限
            ActivityCompat.requestPermissions(this, drp, 1);

        }else {
            Log.e("lqf", "checkPermission: 已经授权！");
            var intent = Intent(Intent.ACTION_GET_CONTENT);
            intent.setType("*/*")
            intent.addCategory(Intent.CATEGORY_OPENABLE)
            startActivityForResult(intent, 1)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        var path = ""
        if (resultCode == Activity.RESULT_OK) {//是否选择，没选择就不会继续
            var uri = data!!.data
            path = uri?.path!!
            path = File.separator + path.split(":")[1]
            Log.i("lqf", "最初获取文件所在路径:${path}");
            Toast.makeText(this,"文件已选择",Toast.LENGTH_SHORT).show()
            var map = hashMapOf<String,String>("selectPath" to path)
           methodChannel!!.invokeMethod("showPath",map,
                   object : MethodChannel.Result{
                       override fun success(result: Any?) {
                          Log.i("lqf","${result}")
                       }

                       override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                           Log.i("lqf","errorcode:${errorCode},errorMsg:${errorMessage},errorDetail:${errorDetails}")
                       }
                       override fun notImplemented() {
                           Log.i("lqf","notImplemented")
                       }

                   })
            return;


        }
    }
}
