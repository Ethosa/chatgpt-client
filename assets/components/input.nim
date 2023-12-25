import
  happyx,
  asyncjs,
  ../common,
  ../colors


component Input:
  placeholder: string = "Edit text ..."
  onInput: (proc(text: cstring): void) = (proc(text: cstring) = discard)
  isTextArea: bool = false
  inputId: string = ""
  sendIcon: bool = false
  onSend: (proc: Future[void] {.async.}) = (proc(): Future[void] {.async.} = discard)

  `template`:
    tDiv(class = "text-lg xl:text-base flex items-center relative w-full min-w-fit h-fit"):
      if self.isTextArea:
        tTextArea(
          id = $(self.inputId),
          placeholder = " ",
          class = fmt"""px-4 overflow-hidden leading-6 w-full min-h-[2rem] h-8 max-h-[6rem] py-1 peer rounded-md outline outline-1 outline-{primaryColor}{PrimaryColor} 
                        dark:outline-{primaryColor}{PrimaryColorDark} bg-transparent 
                        focus:outline-2 focus:outline-{primaryColor}{PrimaryColorHover} focus:dark:outline-{primaryColor}{PrimaryColorHoverDark} duration-150"""
        ):
          @input(event):
            self.onInput(event.target.InputElement.value)
            var linesCount = ($event.target.InputElement.value).split('\n').len
            event.target.style.height = event.target.style.minHeight
            event.target.style.height = $(linesCount.float * 1.75) & "rem"
      else:
        tInput(
          id = $(self.inputId),
          placeholder = " ",
          class = "px-4 w-full py-1 peer rounded-md outline outline-1 outline-{primaryColor}{PrimaryColor} dark:outline-{primaryColor}{PrimaryColorDark} bg-transparent focus:outline-2 focus:outline-{primaryColor}{PrimaryColorHover} focus:dark:outline-{primaryColor}{PrimaryColorHoverDark} duration-150"
        ):
          @input(event):
            self.onInput(event.target.InputElement.value)
      tLabel(
        class = "flex px-2 absolute pointer-events-none peer-focus:scale-75 peer-[:not(:placeholder-shown)]:scale-75 peer-[:not(:placeholder-shown)]:-top-4 peer-focus:-top-4 peer-[:not(:placeholder-shown)]:translate-x-2 peer-focus:translate-x-2 peer-[:not(:placeholder-shown)]:backdrop-blur-2xl peer-focus:backdrop-blur-2xl duration-150"
      ):
        {translate(self.placeholder)}
      if self.sendIcon:
        tSvg(
          viewBox = "0 0 24 24",
          class = "select-none cursor-pointer hover:scale-110 active:scale-90 absolute right-4 w-8 duration-150 h-full stroke-{primaryColor}{PrimaryColor} dark:stroke-{primaryColor}{PrimaryColorDark}"
        ):
          tPath(
            d = "M10.3009 13.6949L20.102 3.89742M10.5795 14.1355L12.8019 18.5804C13.339 19.6545 13.6075 20.1916 13.9458 20.3356C14.2394 20.4606 14.575 20.4379 14.8492 20.2747C15.1651 20.0866 15.3591 19.5183 15.7472 18.3818L19.9463 6.08434C20.2845 5.09409 20.4535 4.59896 20.3378 4.27142C20.2371 3.98648 20.013 3.76234 19.7281 3.66167C19.4005 3.54595 18.9054 3.71502 17.9151 4.05315L5.61763 8.2523C4.48114 8.64037 3.91289 8.83441 3.72478 9.15032C3.56153 9.42447 3.53891 9.76007 3.66389 10.0536C3.80791 10.3919 4.34498 10.6605 5.41912 11.1975L9.86397 13.42C10.041 13.5085 10.1295 13.5527 10.2061 13.6118C10.2742 13.6643 10.3352 13.7253 10.3876 13.7933C10.4468 13.87 10.491 13.9585 10.5795 14.1355Z",
            "stroke-width" = "2",
            "stroke-linecap" = "round",
            "stroke-linejoin" = "round"
          )
          @click:
            discard self.onSend()
