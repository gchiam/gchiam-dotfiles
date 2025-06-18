import { Clipboard, closeMainWindow, showHUD } from "@raycast/api";

export default async function main() {
  try {
    const clipboardText = await Clipboard.readText();

    if (clipboardText) {
      // If the clipboard text does not end with a newline, add one.
      const contentToWrap = clipboardText.endsWith('\n') ? clipboardText : clipboardText + '\n';

      const formattedText = "```\n" + contentToWrap + "```";
      await Clipboard.copy(formattedText);
      await showHUD("Copied to clipboard with Markdown blockquotes");
    } else {
      await showHUD("Clipboard is empty");
    }
  } catch (error) {
    await showHUD("Could not get clipboard content");
  } finally {
    await closeMainWindow();
  }
}
