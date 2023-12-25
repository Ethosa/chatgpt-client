import
  happyx,
  ./[button, input, checkbox],
  ../[common, colors, native],
  ../openai/base


component Settings:

  opened: bool = false

  `template`:
    tDiv(
        id = $"settings",
        class =
          if self.opened:
            "overflow-hidden opacity-100 flex justify-center items-center w-screen h-screen absolute z-10 duration-300 bg-black/[.1] backdrop-blur-sm"
          else:
            "overflow-hidden pointer-events-none opacity-0 flex justify-center items-center w-screen h-screen absolute z-10 duration-300 bg-black/[.1] backdrop-blur-sm"
    ):
      nim:
        let
          bgClr950 = if usePCIB: pickBg(primaryColor.val, 950) else: "neutral-950"
          bgClr900 = if usePCIB: pickBg(primaryColor.val, 900) else: "neutral-900"
          bgClr800 = if usePCIB: pickBg(primaryColor.val, 800) else: "neutral-800"
          bgClr700 = if usePCIB: pickBg(primaryColor.val, 700) else: "neutral-700"
          bgClr200 = if usePCIB: pickBg(primaryColor.val, 200) else: "neutral-200"
          bgClr100 = if usePCIB: pickBg(primaryColor.val, 100) else: "neutral-100"
      tDiv(class = "px-8 py-4 flex flex-col gap-4 items-center rounded-md drop-shadow-xl bg-{bgClr200} dark:bg-{bgClr900}"):
        tP(class = "text-xl"):
          {translate"Settings"}
        tDiv(class = "absolute right-2 top-2 pt-1 pb-2 px-3 rounded-md cursor-pointer select-none bg-white/10 hover:bg-white/20 active:bg-white/30 duration-150"):
          "x"
          @click:
            enableRouting = false
            self.opened = false
            let settings = document.getElementById("settings")
            settings.classList.add("pointer-events-none")
            settings.classList.add("opacity-0")
            settings.classList.remove("opacity-100")
            enableRouting = true
        tDiv(class = "flex flex-col items-center justify-between"):
          tP:
            {translate"primary color:"}
          tDiv(class = "inline-flex bg-{bgClr800} rounded-md"):
            nim:
              let opc = 40
            tButton(type = "button", class = "px-4 py-2 rounded-l-md hover:bg-{bgClr700} font-medium focus:bg-red{PrimaryColor}/{opc} focus:dark:bg-red{PrimaryColorDark}/{opc}"):
              {translate"red"}
              @click:
                enableRouting = false
                self.opened = true
                enableRouting = true
                primaryColor.set("red")
                hpxNative.callNim("savePrimaryColor", primaryColor.val)
                application.router()
            tButton(type = "button", class = "px-4 py-2 hover:bg-{bgClr700} font-medium focus:bg-green{PrimaryColor}/{opc} focus:dark:bg-green{PrimaryColorDark}/{opc}"):
              {translate"green"}
              @click:
                enableRouting = false
                self.opened = true
                enableRouting = true
                primaryColor.set("green")
                hpxNative.callNim("savePrimaryColor", primaryColor.val)
                application.router()
            tButton(type = "button", class = "px-4 py-2 hover:bg-{bgClr700} font-medium focus:bg-blue{PrimaryColor}/{opc} focus:dark:bg-blue{PrimaryColorDark}/{opc}"):
              {translate"blue"}
              @click:
                enableRouting = false
                self.opened = true
                enableRouting = true
                primaryColor.set("blue")
                hpxNative.callNim("savePrimaryColor", primaryColor.val)
                application.router()
            tButton(type = "button", class = "px-4 py-2 hover:bg-{bgClr700} font-medium focus:bg-pink{PrimaryColor}/{opc} focus:dark:bg-pink{PrimaryColorDark}/{opc}"):
              {translate"pink"}
              @click:
                enableRouting = false
                self.opened = true
                enableRouting = true
                primaryColor.set("pink")
                hpxNative.callNim("savePrimaryColor", primaryColor.val)
                application.router()
            tButton(type = "button", class = "px-4 py-2 rounded-r-md hover:bg-{bgClr700} font-medium focus:bg-purple{PrimaryColor}/{opc} focus:dark:bg-purple{PrimaryColorDark}/{opc}"):
              {translate"purple"}
              @click:
                enableRouting = false
                self.opened = true
                enableRouting = true
                primaryColor.set("purple")
                hpxNative.callNim("savePrimaryColor", primaryColor.val)
                application.router()
        tDiv(class = "flex w-full justify-center gap-2 px-8"):
          tDiv(
            class = "relative group flex rounded-md select-none cursor-pointer justify-center items-center px-8 py-2 bg-{bgClr100} dark:bg-{bgClr800}"
          ):
            tP:
              {translate"GPT Model:"}
              " - "
              {openAiClient.modelName}
            tDiv(class = "absolute z-10 duration-150 w-screen h-screen scale-125 backdrop-blur-sm bg-black/[.25] group-hover:opacity-100 opacity-0 pointer-events-none")
            tDiv(
              id = $"gpt-models-menu",
              class = "absolute z-10 duration-150 scale-0 group-hover:scale-100 group-hover:-translate-y-[25%] w-max overflow-hidden rounded-md bg-{bgClr200} dark:bg-{bgClr900}"
            ):
              for modelName in gptModels:
                tDiv(class = "w-full px-2 py-1 cursor-pointer select-none bg-white/[.05] hover:bg-white/[.1] active:bg-white/[.15]"):
                  {modelName}
                  @click:
                    enableRouting = false
                    self.opened = true
                    enableRouting = true
                    openAiClient.modelName = modelName
                    hpxNative.callNim("saveModel", modelName)
                    route"/"
                    application.router()
        tDiv(class = "flex flex-col items-center w-full gap-1"):
          tP:
            {translate"GPT API URL Base:"}
          tDiv(class = "text-lg xl:text-base flex items-center relative w-full min-w-fit h-fit"):
            tInput(
              placeholder = " ",
              value = openAiClient.base,
              class = "px-4 w-full py-1 peer rounded-md outline outline-1 outline-{primaryColor}{PrimaryColor} dark:outline-{primaryColor}{PrimaryColorDark} bg-transparent focus:outline-2 focus:outline-{primaryColor}{PrimaryColorHover} focus:dark:outline-{primaryColor}{PrimaryColorHoverDark} duration-150"
            ):
              @input(event):
                enableRouting = false
                self.opened = true
                enableRouting = true
                openAiClient.base = $event.target.InputElement.value
                hpxNative.callNim("saveApiBase", openAiClient.base)
                route"/"
                application.router()
            tLabel(
              class = "flex px-2 absolute pointer-events-none peer-focus:scale-75 peer-[:not(:placeholder-shown)]:scale-75 peer-[:not(:placeholder-shown)]:-top-4 peer-focus:-top-4 peer-[:not(:placeholder-shown)]:translate-x-2 peer-focus:translate-x-2 peer-[:not(:placeholder-shown)]:backdrop-blur-2xl peer-focus:backdrop-blur-2xl duration-150"
            ):
              "URL"
        tDiv(class = "flex flex-col items-center w-full gap-1"):
          tP:
            {translate"OpenAI Token"}
          tDiv(class = "text-lg xl:text-base flex items-center relative w-full min-w-fit h-fit"):
            tInput(
              id = $"newToken",
              placeholder = " ",
              value = $openAiClient.token,
              type = "password",
              class = "px-4 w-full py-1 peer rounded-md outline outline-1 outline-{primaryColor}{PrimaryColor} dark:outline-{primaryColor}{PrimaryColorDark} bg-transparent focus:outline-2 focus:outline-{primaryColor}{PrimaryColorHover} focus:dark:outline-{primaryColor}{PrimaryColorHoverDark} duration-150"
            ):
              @input(event):
                enableRouting = false
                self.opened = true
                enableRouting = true
                openAiClient.token = event.target.InputElement.value
                hpxNative.callNim("saveToken", $openAiClient.token)
                route"/"
                application.router()
              @mouseover(event):
                var elem = document.getElementById("newToken").InputElement
                {.emit:"`elem`.type = 'text'".}
              @mouseout(event):
                var elem = document.getElementById("newToken")
                {.emit:"`elem`.type = 'password'".}
            tLabel(
              class = "flex px-2 absolute pointer-events-none peer-focus:scale-75 peer-[:not(:placeholder-shown)]:scale-75 peer-[:not(:placeholder-shown)]:-top-4 peer-focus:-top-4 peer-[:not(:placeholder-shown)]:translate-x-2 peer-focus:translate-x-2 peer-[:not(:placeholder-shown)]:backdrop-blur-2xl peer-focus:backdrop-blur-2xl duration-150"
            ):
              "OpenAI Token"
        Checkbox(
          usePCIB,
          proc(checked: bool) =
            enableRouting = false
            self.opened = true
            enableRouting = true
            usePCIB.set(checked)
            hpxNative.callNim("saveUsePCInBack", $usePCIB)
            application.router()
        ):
          {translate"use primary color for background"}
