#include <jni.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <errno.h>
#include <android/log.h>
#define LOGD(FORMAT,...) __android_log_print(ANDROID_LOG_DEBUG,"lqf",FORMAT,##__VA_ARGS__);
char password[] = "softlvquanfeng";

extern int errno;

int Encryption_algorithm1(JNIEnv *env, jstring normal_path_jstr, jstring crypt_path_jstr) {
    //jstring --> char*
    const char *normal_path = env->GetStringUTFChars(normal_path_jstr, 0);
    const char *crypt_path = env->GetStringUTFChars(crypt_path_jstr, 0);
    LOGD("%s", normal_path);
    LOGD("%s", "ndk-task1");

    //打开文件
    FILE *nomal_fp = fopen(normal_path, "rb");
    FILE *crypt_fp = fopen(crypt_path, "wb");

    if (nomal_fp == NULL) {
        LOGD("%s", "加密文件打开失败");
        fprintf(stderr, "Value of errno: %d\n", errno);
        fprintf(stderr, "Error opening file: %s\n", strerror(errno));
        return -1;
    }
    LOGD("%s", "加密文件打开成功");
    LOGD("%s", "开始文件加密");

    //一次读取一个字符
    int ch = 0;
    int i = 0;
    int pwd_length = strlen(password);
    while ((ch = fgetc(nomal_fp)) != EOF) { //End of File
    //写入(异或运算)
        fputc(ch ^ password[i % pwd_length], crypt_fp);
        i++;
    }
    LOGD("%s", "文件加密完成");

    //关流
    fclose(nomal_fp);
    fclose(crypt_fp);
    return 1;
}

int Decryption_algorithm1(JNIEnv *env,jstring crypt_path_jstr, jstring decrypt_path_jstr) {
    //jstring --> char*
    const char *crypt_path = env->GetStringUTFChars(crypt_path_jstr, 0);
    const char *decrypt_path = env->GetStringUTFChars(decrypt_path_jstr, 0);

    FILE* crypt_fp = fopen(crypt_path, "rb");
    FILE* decrypt_fp = fopen(decrypt_path, "wb");

    if (crypt_fp == NULL) {
        LOGD("%s", "解密文件打开失败");
        return -1;
    }
    LOGD("%s", "解密文件打开成功");
    LOGD("%s", "开始文件解密");

    int ch;
    int i = 0;
    int pwd_length = strlen(password);
    while ((ch = fgetc(crypt_fp)) != EOF)
    {
        fputc(ch ^ password[i % pwd_length], decrypt_fp);
        i++;
    }
    LOGD("%s", "文件解密完成");

    fclose(crypt_fp);
    fclose(decrypt_fp);
    return 1;
}

extern "C"
JNIEXPORT jint JNICALL
Java_com_example_documentencryptionplus_MainActivity_Decrypt(JNIEnv *env, jobject thiz,
                                                             jstring inputpath, jstring outputpath,jint index) {
    LOGD("%s", "解密调用");

    int code;
    switch (index) {
        case 0:
            code = Decryption_algorithm1(env,inputpath,outputpath);
            break;
         case 1:
             return 3;

            break;
         case 2:
             return 3;

            break;
         case 3:
             return 3;

            break;

    }
    return code;
}
extern "C"
JNIEXPORT jint JNICALL
Java_com_example_documentencryptionplus_MainActivity_Encryption(JNIEnv *env, jobject thiz,
                                                                jstring inputpath,
                                                                jstring outputpath, jint index) {
    LOGD("%s", "加密调用");
    int code;

    switch (index) {
        case 0:
            code = Encryption_algorithm1(env,inputpath,outputpath);

            break;
        case 1:
            return 3;
            break;
        case 2:
            return 3;

            break;
        case 3:
            return 3;

            break;

    }
    return code;
}