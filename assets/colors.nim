import happyx

const
  PrimaryColor* = "-500"
  PrimaryColorHover* = "-600"
  PrimaryColorActive* = "-700"
  PrimaryColorDark* = "-200"
  PrimaryColorHoverDark* = "-300"
  PrimaryColorActiveDark* = "-400"
var
  primaryColor* = remember "pink"
  usePCIB* = remember false


func pickBg*(primary: string, level: int): string =
  result =
    case primary
    of "pink":
      case level
      of 950:
        "#141214"
      of 900:
        "#211920"
      of 800:
        "#282329"
      of 700: 
        "#473847"
      of 200:
        "#e3cfe1"
      of 100:
        "#f5d5f2"
      else:
        ""
    of "purple":
      case level
      of 950:
        "#141214"
      of 900:
        "#1e1921"
      of 800:
        "#272329"
      of 700:
        "#413847"
      of 200:
        "#decfe3"
      of 100:
        "#ebd5f5"
      else:
        ""
    of "red":
      case level
      of 950:
        "#141212"
      of 900:
        "#211919"
      of 800:
        "#292323"
      of 700:
        "#473838"
      of 200:
        "#e3cfcf"
      of 100:
        "#f5d5d5"
      else:
        ""
    of "green":
      case level
      of 950:
        "#121413"
      of 900:
        "#19211b"
      of 800:
        "#232926"
      of 700:
        "#38473e"
      of 200:
        "#cfe3d3"
      of 100:
        "#d5f5dc"
      else:
        ""
    of "blue":
      case level
      of 950:
        "#121314"
      of 900:
        "#191b21"
      of 800:
        "#232429"
      of 700:
        "#383a47"
      of 200:
        "#cfd4e3"
      of 100:
        "#d5dcf5"
      else:
        ""
    else:
      ""
  result = "[" & result & "]"
