import
  happyx,
  ../common,
  ../colors


component Input:
  placeholder: string = "Edit text ..."
  onInput: (proc(text: cstring): void) = (proc(text: cstring) = discard)
  isTextArea: bool = false

  `template`:
    tDiv(class = "text-lg xl:text-base flex items-center relative w-full min-w-fit h-fit"):
      if self.isTextArea:
        tTextArea(
          placeholder = " ",
          class = "px-4 overflow-hidden leading-6 w-full min-h-[2rem] h-8 max-h-[6rem] py-1 peer rounded-md outline outline-1 outline-{primaryColor}{PrimaryColor} dark:outline-{primaryColor}{PrimaryColorDark} bg-transparent focus:outline-2 focus:outline-{primaryColor}{PrimaryColorHover} focus:dark:outline-{primaryColor}{PrimaryColorHoverDark} duration-150"
        ):
          @input(event):
            self.onInput(event.target.InputElement.value)
            var linesCount = ($event.target.InputElement.value).split('\n').len
            event.target.style.height = event.target.style.minHeight
            event.target.style.height = $(linesCount.float * 1.75) & "rem"
            echo event.target.scrollHeight
            echo event.target.style.minHeight
      else:
        tInput(
          placeholder = " ",
          class = "px-4 w-full py-1 peer rounded-md outline outline-1 outline-{primaryColor}{PrimaryColor} dark:outline-{primaryColor}{PrimaryColorDark} bg-transparent focus:outline-2 focus:outline-{primaryColor}{PrimaryColorHover} focus:dark:outline-{primaryColor}{PrimaryColorHoverDark} duration-150"
        ):
          @input(event):
            self.onInput(event.target.InputElement.value)
      tLabel(
        class = "flex px-2 absolute pointer-events-none peer-focus:scale-75 peer-[:not(:placeholder-shown)]:scale-75 peer-[:not(:placeholder-shown)]:-top-4 peer-focus:-top-4 peer-[:not(:placeholder-shown)]:translate-x-2 peer-focus:translate-x-2 peer-[:not(:placeholder-shown)]:backdrop-blur-2xl peer-focus:backdrop-blur-2xl duration-150"
      ):
        {translate(self.placeholder)}
      slot
