package com.home.helloNDK;

public class SwiftLib {

    static {
        System.loadLibrary("HelloMessages");
    }

    public native int sayHello();
}
