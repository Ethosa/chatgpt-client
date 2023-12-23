# Main native file
import happyx_native


var
  token: string = ""
  primaryColor: string = "pink"
  usePCIB: bool = false
  chats: string = "[]"
  modelName: string = "gpt-3.5-turbo"


proc saveData*() =
  {.gcsafe.}:
    var data = %*{
      "token": token,
      "primaryColor": primaryColor,
      "usePCIB": usePCIB,
      "chats": chats,
      "model": modelName
    }
    save("chatgpt-client.save", data)


proc loadData*() =
  {.gcsafe.}:
    var source = loadString("chatgpt-client.save")
    if source.len > 0:
      var data = parseJson(source)
      token = data["token"].getStr
      primaryColor = data["primaryColor"].getStr
      usePCIB = data["usePCIB"].getBool
      chats = data["chats"].getStr
      modelName = data["model"].getStr


callback:
  proc load() =
    loadData()
    if primaryColor == "":
      primaryColor = "pink"
    callJs("loadAll", token, primaryColor, $usePCIB, chats, modelName)
  
  proc saveToken(val: string) =
    token = val
    saveData()
  
  proc savePrimaryColor(val: string) =
    primaryColor = val
    saveData()
  
  proc saveUsePCInBack(val: string) =
    usePCIB = val == "true"
    saveData()
  
  proc saveChats(val: string) =
    chats = val
    saveData()
  
  proc saveModel(val: string) =
    modelName = val
    saveData()


nativeApp("/assets", w = 800, h = 480, title = "ChatGPT Client", establish = false)
