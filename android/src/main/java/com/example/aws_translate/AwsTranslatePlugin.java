package com.example.aws_translate;

import android.util.Log;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.auth.CognitoCredentialsProvider;
import com.amazonaws.handlers.AsyncHandler;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.translate.AmazonTranslateAsyncClient;
import com.amazonaws.services.translate.model.TranslateTextRequest;
import com.amazonaws.services.translate.model.TranslateTextResult;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static com.amazonaws.mobile.auth.core.internal.util.ThreadUtils.runOnUiThread;

/** AwsTranslatePlugin */
public class AwsTranslatePlugin implements FlutterPlugin, MethodCallHandler {

    private static final String TAG = "AwsTranslatePlugin";
    private static String channelName = "com.blasanka.translateFlutter/aws_translate";
    AmazonTranslateAsyncClient translateAsyncClient;
    private static MethodChannel methodChannel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
      methodChannel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), channelName);
      methodChannel.setMethodCallHandler(new AwsTranslatePlugin());
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
      methodChannel = new MethodChannel(registrar.messenger(), channelName);
      methodChannel.setMethodCallHandler(new AwsTranslatePlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("translateText")) {
      String transPoolId = call.argument("poolId");
      String reg = call.argument("region");
      assert reg != null;
      try {
        String regionName = reg.replaceFirst("Regions.", "");
        Regions region = Regions.valueOf(regionName);

        ClientConfiguration clientConfiguration = new ClientConfiguration();
        clientConfiguration.setConnectionTimeout(250000);
        clientConfiguration.setSocketTimeout(250000);

        CognitoCredentialsProvider credentialsProvider = new CognitoCredentialsProvider(transPoolId, region, clientConfiguration);
        translateAsyncClient = new AmazonTranslateAsyncClient(credentialsProvider);
        translateText(result, call.argument("text").toString(), call.argument("from").toString(), call.argument("to").toString());
      } catch (Exception e) {
        Log.e(TAG, "onMethodCall: exception: " + e.getMessage());
        result.error(e.getMessage(), "", null);
      }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
      methodChannel.setMethodCallHandler(null);
      methodChannel = null;
  }

  void translateText(final MethodChannel.Result result, String text, String from, String to) {
        TranslateTextRequest translateTextRequest = new TranslateTextRequest()
                .withText(text)
                .withSourceLanguageCode(from)
                .withTargetLanguageCode(to);
        translateAsyncClient.translateTextAsync(translateTextRequest, new AsyncHandler<TranslateTextRequest, TranslateTextResult>() {

            @Override
            public void onError(Exception e) {
                Log.e("TRANS", "Error occurred in translating the text: " + e.getLocalizedMessage());
                result.error(e.getMessage(), "", null);
            }

            @Override
            public void onSuccess(TranslateTextRequest request, TranslateTextResult translateTextResult) {
                Log.d("TRANS", "Original Text: " + request.getText());
                String translatedText = translateTextResult.getTranslatedText();
                Log.d("TRANS", "Translated Text: " + translatedText);
                getTranslatedText(translatedText, result);
            }
        });
  }

    private void getTranslatedText(final String value, final MethodChannel.Result result) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                result.success(value);
            }
        });
    }
}