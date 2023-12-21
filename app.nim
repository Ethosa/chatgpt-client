# Main native file
import happyx_native


var
  token: string = ""
  primaryColor: string = "pink"
  usePCIB: bool = false


callback:
  proc load() =
    token = loadString("chatgpt-client-token.save")
    primaryColor = loadString("chatgpt-client-primaryColor.save")
    usePCIB = loadBool("chatgpt-client-usePCIB.save")
    if primaryColor == "":
      primaryColor = "pink"
    callJs("loadAll", token, primaryColor, $usePCIB)
  
  proc saveToken(token: string) =
    save("chatgpt-client-token.save", token)
  
  proc savePrimaryColor(primaryColor: string) =
    save("chatgpt-client-primaryColor.save", primaryColor)
  
  proc saveUsePCInBack(val: string) =
    save("chatgpt-client-usePCIB.save", val)


nativeApp("/assets", w = 800, h = 480, title = "ChatGPT Client", establish = false)
