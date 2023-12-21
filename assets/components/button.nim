import
  happyx,
  ../common,
  ../colors


component Button:
  action: (proc():void) = (proc() = discard)
  isSquare: bool = false

  `template`:
    if self.isSquare:
      tButton(class = "flex text-neutral-900 justify-center items-center px-2 pt-1 pb-1 font-bold lowercase rounded-md bg-{primaryColor}{PrimaryColor} hover:bg-{primaryColor}{PrimaryColorHover} active:bg-{primaryColor}{PrimaryColorActive} dark:bg-{primaryColor}{PrimaryColorDark} dark:hover:bg-{primaryColor}{PrimaryColorHoverDark} dark:active:bg-{primaryColor}{PrimaryColorActiveDark} duration-150 "):
        slot
        @click:
          self.action()
    else:
      tButton(class = "flex text-neutral-900 justify-center items-center px-6 py-1 font-bold lowercase rounded-md bg-{primaryColor}{PrimaryColor} hover:bg-{primaryColor}{PrimaryColorHover} active:bg-{primaryColor}{PrimaryColorActive} dark:bg-{primaryColor}{PrimaryColorDark} dark:hover:bg-{primaryColor}{PrimaryColorHoverDark} dark:active:bg-{primaryColor}{PrimaryColorActiveDark} duration-150 "):
        slot
        @click:
          self.action()