import
  happyx,
  ../[native, colors, common],
  ../openai/base,
  ../components/[
    button, chat, checkbox, settings, input
  ],
  std/enumerate,
  asyncjs,
  jscore,
  json


proc loadAll*(token, clr, pcib, chats, modelName: cstring) {.exportc.} =
  openAiClient.token = token
  openAiClient.chats = parseJson($chats)
  openAiClient.modelName = $modelName
  primaryColor.set($clr)
  usePCIB.set(pcib == "true")

hpxNative.callNim("load")


component Main:
  `template`:
    tDiv:
      nim:
        let
          bgClr950 = if usePCIB: pickBg(primaryColor.val, 950) else: "neutral-950"
          bgClr900 = if usePCIB: pickBg(primaryColor.val, 900) else: "neutral-900"
          bgClr200 = if usePCIB: pickBg(primaryColor.val, 200) else: "neutral-200"
          bgClr100 = if usePCIB: pickBg(primaryColor.val, 100) else: "neutral-100"
      tDiv(class = "flex flex-col md:flex-row w-full h-screen overflow-hidden bg-{bgClr100} text-{bgClr900} dark:text-{bgClr100} dark:bg-{bgClr900}"):
        # Sidebar
        tDiv(
          id = $"sidebar",
          class = "duration-150 flex flex-col z-10 absolute md:static -translate-x-full md:translate-x-0 w-full h-full md:flex md:w-96 lg:w-2/6 xl:w-1/6 bg-{bgClr100} dark:bg-{bgClr950}"
        ):
          tDiv(class = "absolute md:hidden right-2 top-2 pt-1 pb-2 px-3 rounded-md cursor-pointer select-none bg-white/10 hover:bg-white/20 active:bg-white/30 duration-150"):
            "x"
            @click:
              let sidebar = document.getElementById("sidebar")
              sidebar.classList.add("-translate-x-full")
              sidebar.classList.remove("translate-x-0")
          # Sidebar title
          tP(class = "w-full text-center text-3xl md:text-2xl font-bold xl:text-xl"):
            "chatgpt-client"
          # Sidebar subtitle
          tP(class = "w-full text-center text-base md:text-sm font-bold xl:text-xs"):
            {translate"made with HappyX Native ✌"}
          tDiv(class = "flex flex-1 flex-col w-full h-full px-2 gap-1 overflow-y-auto"):
            # chat list
            nim:
              var current = ""
            for idx, chat in enumerate(openAiClient.chats.getElems):
              nim:
                let
                  lastAccessTime = chat["lastAccessTime"].getInt
                  difference = Date.now() - lastAccessTime
                  day = 1000 * 60 * 60 * 24
                  two_days = day * 2
                  week = day * 7
                  month = day * 30
              if difference < day and current != "today":
                tDiv(class = "flex w-full justify-center"):
                  {translate"today"}
                  nim:
                    current = "today"
              elif difference < two_days and current != "yesterday":
                tDiv(class = "flex w-full justify-center"):
                  {translate"yesterday"}
                  nim:
                    current = "yesterday"
              elif difference < week and current != "last week":
                tDiv(class = "flex w-full justify-center"):
                  {translate"last week"}
                  nim:
                    current = "last week"
              elif difference < month and current != "last month":
                tDiv(class = "flex w-full justify-center"):
                  {translate"last month"}
                  nim:
                    current = "last month"
              elif current != "some time ago":
                tDiv(class = "flex w-full justify-center"):
                  {translate"some time ago"}
                  nim:
                    current = "some time ago"
              tDiv(
                class =
                  if currentChat == idx:
                    "px-2 py-1 flex w-full truncate justify-center cursor-pointer rounded-md bg-white/[.1] hover:bg-white/[.15] active:bg-white/[.2] duration-150"
                  else:
                    "px-2 py-1 flex w-full truncate justify-center cursor-pointer rounded-md bg-white/[.05] hover:bg-white/[.1] active:bg-white/[.15] duration-150"
              ):
                {chat["name"].getStr}
                @click:
                  # open chat
                  currentChat.set(idx)
                  route"/"
                  application.router()
          # Sidebar bottom
          tDiv(class = "flex flex-col w-full px-4 py-2 items-center"):
            tDiv(class = "flex flex-col gap-2 w-max-1/2"):
              # Add new chat button
              Button(
                proc() =
                  currentChat.set(-1)
              ):
                {translate"New Chat"}
              # Settings button
              Button(
                proc() =
                  let settings = document.getElementById("settings")
                  settings.classList.add("scale-100")
                  settings.classList.add("opacity-100")
                  settings.classList.remove("scale-0")
                  settings.classList.remove("opacity-0")
              ):
                tDiv(class = "flex gap-2 items-center justify-center"):
                  tImg(src = "/svg_icons/settings.svg", class = "w-5 h-full")
                  tP(class = "h-full"): {translate"Settings"}
        # Mobile head menu
        tDiv(
          class = "px-4 py-2 w-full md:hidden bg-{bgClr100} dark:bg-{bgClr950} absolute top-0 left-0"
        ):
          tSvg(viewBox="0 0 24 24", class = "cursor-pointer select-none w-8 h-8 stroke-{primaryColor}{PrimaryColor} dark:stroke-{primaryColor}{PrimaryColorDark}"):
            tPath(
              d="M4 6H20M4 12H20M4 18H20",
              "stroke-width" = "2",
              "stroke-linecap" = "round",
              "stroke-linejoin" = "round"
            )
            @click:
              var sidebar = document.getElementById("sidebar")
              sidebar.classList.remove("-translate-x-full")
              sidebar.classList.add("translate-x-0")
        # Settings
        Settings
        # Main content
        tDiv(class = "relative flex flex-col w-full h-full overflow-hidden"):
          if openAiClient.token == "":
            tDiv(class = "flex flex-col w-full h-full justify-center items-center gap-2"):
              nim:
                var token = ""
              tP(class = "text-xl lg:text-lg xl:text-base text-center px-2"):
                {translate"To use ChatGPT Client you should add your OpenAI Token here:"}
              tDiv(class = "flex flex-col md:flex-row gap-2 w-4/5"):
                Input(
                  "OpenAI Token",
                  proc(text: cstring) =
                    token = $text
                )
                Button(
                  proc() =
                    hpxNative.callNim("saveToken", token)
                    openAiClient.token = cstring token
                    route"/"
                    application.router(),
                  true
                ):
                  tImg(src = "/svg_icons/check.svg", class = "min-w-fit w-5 h-5")
          elif currentChat < 0:
            tDiv(class = "flex flex-col items-center justify-end w-full h-full overflow-hidden"):
              tDiv(class = "absolute w-full h-full flex justify-center items-center"):
                {translate"Please choose any chat or send anything"}
              # input
              tDiv(class = "flex items-center w-full py-2 px-2 gap-2"):
                nim:
                  var message = ""
                Input(
                  translate"Edit text ...",
                  proc(text: cstring) =
                    message = $text,
                  true,
                  "msgText",
                  true,
                  proc() {.async.} =
                    document.getElementById("msgText").InputElement.value = ""
                    echo openAiClient.chats
                    var elems = openAiClient.chats.getElems
                    elems.insert(%*{
                      "name": "New Chat",
                      "lastAccessTime": Date.now(),
                      "messages": [
                        usrMsg(message)
                      ]
                    }, 0)
                    openAiClient.chats = newJArray()
                    for i in elems:
                      openAiClient.chats.add(i)
                    message = ""
                    let response = await openAiClient.createChatCompletion(openAiClient.chats[0]["messages"])
                    openAiClient.chats[0]["messages"].add(response["choices"][0]["message"])
                    let chatName = await openAiClient.chatName(openAiClient.chats[0]["messages"])
                    openAiClient.chats[0]["name"] = %chatName
                    currentChat.set(0)
                    hpxNative.callNim("saveChats", $openAiClient.chats)
                )
          else:
            Chat
