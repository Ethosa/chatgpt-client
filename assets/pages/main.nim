import
  happyx,
  ../[native, colors, common],
  ../openai/base,
  ../components/[
    button, chat, checkbox, settings, input
  ],
  std/enumerate,
  asyncjs,
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
            for idx, chat in enumerate(openAiClient.chats.getElems):
              tDiv(class = "px-2 py-1 flex w-full truncate cursor-pointer rounded-md bg-white/[.05] hover:bg-white/[.1] active:bg-white/[.15] duration-150"):
                {chat["name"].getStr}
                @click:
                  # open chat
                  currentChat.set(idx)
                  route"/"
                  application.router()
            # Add new chat button
            tDiv(class = "px-2 py-1 flex w-full truncate cursor-pointer rounded-md bg-white/[.05] hover:bg-white/[.1] active:bg-white/[.15] duration-150"):
              {translate"New chat"}
              @click:
                currentChat.set(-1)
          # Sidebar bottom
          tDiv(class = "flex flex-col w-full px-4 py-2 items-center"):
            # Settings button
            tDiv(class = "w-max-1/2"):
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
                    openAiClient.chats.add(%*{
                      "name": "New Chat",
                      "messages": [
                        usrMsg(message)
                      ]
                    })
                    message = ""
                    let response = await openAiClient.createChatCompletion(openAiClient.chats[^1]["messages"])
                    echo response
                    openAiClient.chats[^1]["messages"].add(response["choices"][0]["message"])
                    let chatName = await openAiClient.chatName(openAiClient.chats[^1]["messages"])
                    openAiClient.chats[^1]["name"] = %chatName
                    currentChat.set(openAiClient.chats.len - 1)
                    hpxNative.callNim("saveChats", $openAiClient.chats)
                )
          else:
            Chat
