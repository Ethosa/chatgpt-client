import
  happyx,
  ./[button, input, checkbox],
  ../[common, colors, native]


component Settings:

  opened: bool = false

  `template`:
    tDiv(
        id = $"settings",
        class =
          if self.opened:
            "scale-100 opacity-100 flex justify-center items-center w-screen h-screen absolute z-10 duration-300 bg-white/10"
          else:
            "scale-0 opacity-0 flex justify-center items-center w-screen h-screen absolute z-10 duration-300 bg-white/10"
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
            let settings = document.getElementById("settings")
            settings.classList.add("scale-0")
            settings.classList.add("opacity-0")
            settings.classList.remove("scale-100")
            settings.classList.remove("opacity-100")
            self.opened = false
            enableRouting = true
        tHr(class = "w-full h-1 border-t-1 border-{primaryColor}{PrimaryColor} dark:border-{primaryColor}{PrimaryColorDark}")
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
        tHr(class = "w-full h-1 border-t-1 border-{primaryColor}{PrimaryColor} dark:border-{primaryColor}{PrimaryColorDark}")
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
          "use primary key for background"
