tool
extends EditorPlugin

class TextureInspectorPlugin extends EditorInspectorPlugin:

    var dialog : EditorFileDialog
    var filesystem: EditorFileSystem

    var texture : Texture

    func _init(plugin : EditorPlugin):
        filesystem = plugin.get_editor_interface().get_resource_filesystem()

        dialog = EditorFileDialog.new()
        dialog.window_title = "Save as PNG..."
        dialog.mode = FileDialog.MODE_SAVE_FILE
        dialog.access = FileDialog.ACCESS_RESOURCES
        dialog.add_filter("*.png ; PNG Images")
        dialog.connect("file_selected", self, "_dialog_confirmed")

        plugin.get_editor_interface().get_base_control().add_child(dialog)


    func can_handle(object):
        return object is Texture


    func parse_begin(object):
        texture = object as Texture
        var btn = Button.new()
        btn.text = "Save as PNG"
        btn.connect("pressed", self, "_btn_pressed")
        add_custom_control(btn)


    func _btn_pressed():
        if texture.resource_path != "":
            dialog.current_dir = texture.resource_path.get_base_dir()
        dialog.popup_centered_ratio()


    func _dialog_confirmed(path):
        texture.get_data().save_png(path)
        print("save to " + path)
        filesystem.scan()

    func _notification(what):
        if what == NOTIFICATION_PREDELETE:
            dialog.queue_free()



var plugin : TextureInspectorPlugin

func _enter_tree():
    plugin = TextureInspectorPlugin.new(self)
    add_inspector_plugin(plugin)


func _exit_tree():
    if plugin:
        remove_inspector_plugin(plugin)
        plugin = null
