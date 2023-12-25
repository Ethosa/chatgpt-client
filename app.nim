# Main native file
import happyx_native


const AppVersion = "v0.1.0"


var
  token: string = ""
  primaryColor: string = "pink"
  usePCIB: bool = false
  chats: string = "[]"
  modelName: string = "gpt-3.5-turbo"
  apiBase: string = "https://api.openai.com/v1"


proc saveData*() =
  {.gcsafe.}:
    var data = %*{
      "token": token,
      "primaryColor": primaryColor,
      "usePCIB": usePCIB,
      "chats": chats,
      "model": modelName,
      "apiBase": apiBase
    }
    save(fmt"chatgpt-client-{AppVersion}.save", data)


proc loadData*() =
  {.gcsafe.}:
    var source = loadString(fmt"chatgpt-client-{AppVersion}.save")
    if source.len > 0:
      var data = parseJson(source)
      token = data["token"].getStr
      primaryColor = data["primaryColor"].getStr
      usePCIB = data["usePCIB"].getBool
      chats = data["chats"].getStr
      modelName = data["model"].getStr
      apiBase = data["apiBase"].getStr


callback:
  proc load() =
    loadData()
    if primaryColor == "":
      primaryColor = "pink"
    callJs("loadAll", token, primaryColor, $usePCIB, chats, modelName, apiBase)
  
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
  
  proc saveApiBase(val: string) =
    apiBase = val
    saveData()


nativeApp("/assets", w = 900, h = 540, title = "ChatGPT Client", establish = false)
