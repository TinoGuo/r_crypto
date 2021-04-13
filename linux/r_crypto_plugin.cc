#include "include/r_crypto/r_crypto_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#define R_CRYPTO_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), r_crypto_plugin_get_type(), \
                              RCryptoPlugin))

struct _RCryptoPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(RCryptoPlugin, r_crypto_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void r_crypto_plugin_handle_method_call(
    RCryptoPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());

  fl_method_call_respond(method_call, response, nullptr);
}

static void r_crypto_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(r_crypto_plugin_parent_class)->dispose(object);
}

static void r_crypto_plugin_class_init(RCryptoPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = r_crypto_plugin_dispose;
}

static void r_crypto_plugin_init(RCryptoPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  RCryptoPlugin* plugin = R_CRYPTO_PLUGIN(user_data);
  r_crypto_plugin_handle_method_call(plugin, method_call);
}

void r_crypto_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  RCryptoPlugin* plugin = R_CRYPTO_PLUGIN(
      g_object_new(r_crypto_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "r_crypto",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
