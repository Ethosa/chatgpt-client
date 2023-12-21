import
  happyx,
  ../[native, colors, common],
  ../openai/base,
  ../components/[
    button, chat, checkbox, settings, input
  ]


var openAiClient* = newOpenAIClient("")


proc loadAll*(token, clr, pcib: cstring) {.exportc.} =
  openAiClient.token = token
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
          class = "duration-150 flex flex-col absolute md:static -translate-x-full md:translate-x-0 w-full h-full md:flex md:w-96 lg:w-2/6 xl:w-1/6 bg-{bgClr100} dark:bg-{bgClr950}"
        ):
          tDiv(class = "absolute md:hidden right-2 top-2 pt-1 pb-2 px-3 rounded-md cursor-pointer select-none bg-white/10 hover:bg-white/20 active:bg-white/30 duration-150"):
            "x"
            @click:
              let sidebar = document.getElementById("sidebar")
              sidebar.classList.add("-translate-x-full")
              sidebar.classList.remove("translate-x-0")
          tP(class = "w-full text-center text-3xl md:text-2xl font-bold xl:text-xl"):
            "chatgpt-client"
          tP(class = "w-full text-center text-base md:text-sm font-bold xl:text-xs"):
            {translate"made with HappyX Native ✌"}
          tDiv(class = "flex-1 flex-col w-full h-full"):
            ""
          tDiv(class = "flex flex-col w-full px-4 py-2 items-center"):
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
        tDiv(
          class = "px-4 py-2 w-full md:hidden bg-{bgClr100} dark:bg-{bgClr950}"
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
        tDiv(class = "flex flex-col w-full h-full"):
          if openAiClient.token == "":
            tDiv(class = "flex flex-col w-full h-full justify-center items-center gap-2"):
              nim:
                var token = ""
              tP(class = "text-xl lg:text-lg xl:text-base"):
                "To use ChatGPT Client you should add your OpenAI Token here:"
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
          else:
            Chat
