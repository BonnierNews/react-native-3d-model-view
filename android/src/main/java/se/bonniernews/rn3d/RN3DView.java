/**
 * Created by johankasperi 2018-02-05.
 */

package se.bonniernews.rn3d;

import android.content.Context;
import android.location.Location;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;
import android.graphics.Paint;
import android.graphics.Canvas;
import android.os.Handler;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableNativeMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableNativeArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.PixelUtil;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.views.view.ReactViewGroup;

import android.widget.RelativeLayout;
import android.support.annotation.NonNull;
import android.view.ViewGroup;
import android.util.DisplayMetrics;

import org.andresoviedo.app.model3D.view.ModelSurfaceView;
import org.andresoviedo.app.model3D.services.SceneLoader;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class RN3DView extends RelativeLayout {
    private ModelSurfaceView gLView;

    private SceneLoader scene;

    private Handler handler;

    public RN3DView(Context context) {
        super(context);
    }
}