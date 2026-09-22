import QtQuick
import qs.Ui

BarWidget {
  id: root
  // The bar host overwrites this with the id the widget was given in
  // shell.json; the value here is only what stands until it does.
  moduleName: "drh.menu"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "\ue900"
    fontFamily: "omarchy"
    horizontalMargin: 7.5
    onPressed: function(button) {
      if (!root.bar) return
      if (button === Qt.RightButton) root.bar.run("xdg-terminal-exec")
      // Toggle whichever id this plugin is installed under, not the
      // first-party menu: a copy installed beside it must open itself.
      else root.bar.run("omarchy-shell shell toggle " + (root.moduleName || "drh.menu")
        + " '{\"menu\":\"root\"}'")
    }
  }
}
