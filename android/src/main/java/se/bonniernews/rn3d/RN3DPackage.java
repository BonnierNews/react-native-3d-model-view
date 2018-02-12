package se.bonniernews.rn3d;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;


/**
 * Created by johankasperi 2018-02-05
 */

public class RN3DPackage implements ReactPackage {
    private RN3DViewManager viewManager;

    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        List<ViewManager> managers = new ArrayList<>();
        managers.add(new RN3DViewManager());
        return managers;
    }

    public RN3DViewManager getViewManager() {
        return this.viewManager;
    }
}